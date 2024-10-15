import Foundation
import Combine
import FirebaseAuth

class CitasViewModel: ObservableObject {
    @Published var citas: [CitasModel] = []
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
}
