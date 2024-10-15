import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @State private var userEmail: String? = Auth.auth().currentUser?.email
    @State private var userFirstName: String?
    @State private var userLastName: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if userLoggedIn {
                    // Navigate to HomePage if the user is logged in
                    MainPageView()
                } else {
                    // Stay on the Login page if the user isn't logged in
                    LoginView()
                }
            }
            .onAppear {
                // Listen for changes in authentication state
                Auth.auth().addStateDidChangeListener { auth, user in
                    userLoggedIn = (user != nil)
                    if let user = user {
                        // Retrieve user information
                        userEmail = user.email
                        // For Google users, you may want to retrieve additional info from your authentication flow
                        userFirstName = user.displayName?.components(separatedBy: " ").first
                        userLastName = user.displayName?.components(separatedBy: " ").dropFirst().joined(separator: " ") // Gets last name
                        
                        // Obtener el ID Token y enviarlo al backend
                        user.getIDToken { idToken, error in
                            if let error = error {
                                print("Error al obtener el ID Token: \(error.localizedDescription)")
                                return
                            }
                            if let idToken = idToken {
                                print("ID Token obtenido: \(idToken)")
                                sendIdTokenToBackend(idToken: idToken)
                            }
                        }
                    }
                }
            }
        }
    }
}

func sendIdTokenToBackend(idToken: String) {
    // Configura la URL de tu backend
    guard let url = URL(string: "http://localhost:3000/api/usuarios/loginOrRegister") else {
        print("URL inválida")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // Agrega el ID Token en el encabezado Authorization
    request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Si necesitas enviar datos adicionales en el cuerpo de la solicitud, puedes agregarlos aquí
    let body: [String: Any] = [:]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error al enviar el token al backend: \(error.localizedDescription)")
            return
        }
        guard let data = data else {
            print("No se recibió respuesta del servidor")
            return
        }
        // Maneja la respuesta del backend
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Respuesta del backend: \(jsonResponse)")
            }
        } catch {
            print("Error al parsear la respuesta del backend: \(error.localizedDescription)")
        }
    }
    task.resume()
}

#Preview {
    HomeView()
}
