import Foundation
import Combine
import FirebaseAuth

class CitasViewModel: ObservableObject {
    @Published var citas: [CitasModel] = []             // List of fetched citas
    @Published var availableTimes: [Date] = []          // Available time slots (9 AM to 5 PM)
    @Published var isLoading = false                    // Loading state for both views
    @Published var successMessage: String?              // Success message after creating a cita
    @Published var showConfirmation = false             // Show confirmation in LawyerAvailabilityView
    @Published var errorMessage: String?                // Error message for both views
    @Published var showErrorAlert = false               // Controls when to show error alert
    @Published var userEmail: String?                   // Email of the currently logged-in user
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Citas Fetching Logic
    // Fetch user's email and citas
    func fetchUserEmail() {
        guard let currentUser = Auth.auth().currentUser else {
            self.errorMessage = "No hay usuario autenticado"
            self.showErrorAlert = true
            return
        }
        
        guard let email = currentUser.email else {
            self.errorMessage = "No se ha obtenido el correo electrónico del usuario"
            self.showErrorAlert = true
            return
        }
        
        DispatchQueue.main.async {
            self.userEmail = email
            self.fetchCitas(for: email)
        }
    }

    // Fetch citas by user email
    func fetchCitas(for email: String) {
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://localhost:3000/api/citas/citaByEmail/\(encodedEmail)") else {
            self.errorMessage = "URL inválida para obtener citas"
            self.showErrorAlert = true
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al obtener citas: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No se recibió respuesta del servidor."
                    self.showErrorAlert = true
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let citas = try decoder.decode([CitasModel].self, from: data)
                
                DispatchQueue.main.async {
                    self.citas = citas
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al decodificar las citas: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }

    // MARK: - Lawyer Availability Logic
    // Fetch booked times for a lawyer on a specific date
    func fetchBookedTimes(for lawyerId: String, on date: Date) {
        isLoading = true
        guard let url = URL(string: "http://localhost:3000/api/citas/lawyers/\(lawyerId)/availability?date=\(formatDateForBackend(date: date))") else {
            DispatchQueue.main.async {
                self.errorMessage = "URL inválida"
                self.showErrorAlert = true
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al obtener horarios: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No se recibió respuesta del servidor."
                    self.showErrorAlert = true
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let bookedTimes = try decoder.decode([Date].self, from: data)
                self.generateAvailableTimes(on: date, excluding: bookedTimes)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al decodificar horarios: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
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

    // Create a new cita
    func createMeeting(with lawyer: UserModel, at time: Date) {
        let userId = "currentUserId"  // Replace with actual logic to get the user ID
        
        let url = URL(string: "http://localhost:3000/api/citas")!
        let meetingDetails: [String: Any] = [
            "cliente_id": userId,
            "abogado_id": lawyer.id,
            "hora": ISO8601DateFormatter().string(from: time)
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: meetingDetails) else {
            DispatchQueue.main.async {
                self.errorMessage = "Error al serializar la solicitud."
                self.showErrorAlert = true
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al crear la cita: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    self.successMessage = "Tu cita ha sido creada exitosamente."
                    self.showConfirmation = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al crear la cita: Código de estado \(response.debugDescription)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
    
    // Helper function to format the date as "YYYY-MM-DD" for the backend API
    func formatDateForBackend(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
