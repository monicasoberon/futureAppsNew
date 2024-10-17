import Foundation
import Combine
import FirebaseAuth

class CitasViewModel: ObservableObject {
    @Published var citas: [CitasModel] = []
    @Published var availableTimes: [Date] = []
    @Published var errorMessage: String? = nil
    @Published var showErrorAlert: Bool = false
    @Published var successMessage: String? = nil
    @Published var showConfirmation: Bool = false
    @Published var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var userEmail: String? = nil
    
    func fetchUserEmail() {
            guard let currentUser = Auth.auth().currentUser else {
                print("No hay usuario autenticado")
                return
            }
            
            guard let email = currentUser.email else {
                print("No se ha obtenido el correo electrónico del usuario")
                return
            }
            
            DispatchQueue.main.async {
                self.userEmail = email
                print("Correo electrónico del usuario: \(email)")
                self.fetchCitas()
            }
        }

        func fetchCitas() {
            guard let email = userEmail else {
                print("No se ha obtenido el correo electrónico del usuario")
                return
            }
            
            guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "http://localhost:3000/api/citas/citaByEmail/\(encodedEmail)") else {
                print("URL inválida")
                return
            }

            print("Realizando solicitud al backend para obtener las citas para el usuario con email: \(email)")

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error al realizar la solicitud: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No se recibió respuesta del servidor")
                    return
                }

                // Mostrar el contenido de la respuesta para verificar si está devolviendo citas
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Respuesta del servidor: \(jsonString)")
                }

                do {
                    let decoder = JSONDecoder()
                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    
                    decoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        
                        if let date = isoFormatter.date(from: dateString) {
                            return date
                        } else {
                            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Formato de fecha no válido: \(dateString)")
                        }
                    }
                    
                    var decodedCitas = try decoder.decode([CitasModel].self, from: data)
                    
                    // Después de decodificar las citas, obtenemos los nombres de los usuarios
                    let dispatchGroup = DispatchGroup()
                    
                    for index in decodedCitas.indices {
                        let cita = decodedCitas[index]
                        
                        // Obtener nombre del cliente
                        dispatchGroup.enter()
                        self.fetchUsuarioNombre(by: cita.cliente_id) { nombre in
                            decodedCitas[index].cliente_nombre = nombre
                            dispatchGroup.leave()
                        }
                        
                        // Obtener nombre del abogado
                        dispatchGroup.enter()
                        self.fetchUsuarioNombre(by: cita.abogado_id) { nombre in
                            decodedCitas[index].abogado_nombre = nombre
                            dispatchGroup.leave()
                        }
                    }
                    
                    // Una vez que se han obtenido todos los nombres, actualizamos las citas
                    dispatchGroup.notify(queue: .main) {
                        self.citas = decodedCitas
                        print("Citas obtenidas: \(self.citas.count)")
                    }
                    
                } catch {
                    print("Error al decodificar las citas: \(error)")
                }
            }.resume()
        }
        
        // Función para obtener el nombre del usuario por ID
        func fetchUsuarioNombre(by id: String, completion: @escaping (String?) -> Void) {
            guard let url = URL(string: "http://localhost:3000/api/usuarios/userById/\(id)") else {
                print("URL inválida para usuario con ID: \(id)")
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error al obtener usuario: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No se recibió respuesta del servidor para usuario con ID: \(id)")
                    completion(nil)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let usuario = try decoder.decode(UsuarioModel.self, from: data)
                    completion(usuario.nombre)
                } catch {
                    print("Error al decodificar el usuario: \(error)")
                    completion(nil)
                }
            }.resume()
        }

    // Fetch booked times using fetchCitas and filter by lawyer ID and date
    func fetchBookedTimes(for lawyerId: String, on date: Date) {
        isLoading = true
        fetchCitas()  // Fetch all citas first
        
        // Filter citas by lawyer ID and the specific date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Small delay to wait for fetchCitas to complete
            let bookedTimes = self.citas.filter { cita in
                return cita.abogado_id == lawyerId &&
                cita.hora >= startOfDay && cita.hora < endOfDay
            }.map { $0.hora }
            
            self.generateAvailableTimes(on: date, excluding: bookedTimes)
            self.isLoading = false
        }
    }
    
    // Generate available time slots from 9 AM to 5 PM, excluding booked times
    func generateAvailableTimes(on date: Date, excluding bookedTimes: [Date]) {
        var slots: [Date] = []
        let calendar = Calendar.current
        
        for hour in 9..<17 {
            if let slot = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) {
                slots.append(slot)
            }
        }
        
        availableTimes = slots.filter { !bookedTimes.contains($0) }
    }
    
    func createMeeting(with lawyer: UserModel, at time: Date) {
        // Get Firebase UID for current user (cliente_id)
        guard let firebaseUid = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async {
                self.errorMessage = "No se pudo obtener el UID del usuario autenticado."
                self.showErrorAlert = true
            }
            return
        }

        // URL to your backend API for creating a new appointment (cita)
        let url = URL(string: "http://localhost:3000/api/citas")!
        
        // Prepare meeting details to send to the backend
        let meetingDetails: [String: Any] = [
            "cliente_id": firebaseUid,  // Send the Firebase UID here
            "abogado_id": lawyer.id,    // The lawyer's ID
            "hora": ISO8601DateFormatter().string(from: time)  // The appointment time
        ]
        
        // Serialize the meeting details to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: meetingDetails) else {
            DispatchQueue.main.async {
                self.errorMessage = "Error al serializar la solicitud."
                self.showErrorAlert = true
            }
            return
        }

        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, _, error in
            // Handle error
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al crear la cita: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                return
            }
            
            // Handle success case
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        // Try to decode response (if the server sends a response body)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            print("Cita creada exitosamente: \(json)")
                        }
                        self.successMessage = "Tu cita ha sido creada exitosamente."
                        self.showConfirmation = true
                    } catch {
                        self.errorMessage = "Error al procesar la respuesta del servidor."
                        self.showErrorAlert = true
                    }
                }
            } else {
                // Handle no data case
                DispatchQueue.main.async {
                    self.errorMessage = "No se recibió respuesta del servidor."
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
}
