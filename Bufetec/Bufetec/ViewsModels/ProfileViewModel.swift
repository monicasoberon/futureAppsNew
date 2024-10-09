import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileModel?
    @Published var isLoading = false
    @Published var isSaving = false
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
            
            do {
                let decoder = JSONDecoder()
                let fetchedProfile = try decoder.decode(ProfileModel.self, from: data)
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
    
    func saveChanges() {
        guard let profile = profile, profile.type == "abogado" else { return }
        
        isSaving = true
        guard let url = URL(string: "http://localhost:3000/api/usuarios/updateDescriptionAndEspecialidad") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": profile.email,
            "newDescription": profile.description ?? "",
            "newEspecialidad": profile.especiality ?? ""
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isSaving = false
            }
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error updating user profile: \(error.localizedDescription)"
                }
                return
            }
            DispatchQueue.main.async {
                self?.errorMessage = "Profile updated successfully"
            }
        }.resume()
    }
}
