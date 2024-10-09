import Foundation
import Combine

class SideMenuProfileViewModel: ObservableObject {
    @Published var profile: SideMenuProfileModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchUserProfile(email: String) {
        guard let url = URL(string: "http://localhost:3000/api/usuarios/userByEmail/\(email)") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error fetching user profile: \(error.localizedDescription)"
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received from server"
                }
                return
            }

            // Imprimir la respuesta JSON para verificar la estructura
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
                let fetchedProfile = try decoder.decode(SideMenuProfileModel.self, from: data)
                DispatchQueue.main.async {
                    self?.profile = fetchedProfile
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode user profile: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
