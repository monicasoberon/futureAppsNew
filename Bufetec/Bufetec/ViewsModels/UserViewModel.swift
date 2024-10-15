import Foundation
import FirebaseAuth
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var conversionMessage: String? = nil // Mensaje después de convertir a abogado
    @Published var isCurrentUserLawyer = false // Verificar si el usuario es abogado

    private var cancellables = Set<AnyCancellable>()

    // Función para obtener los abogados desde el backend
    func fetchUsers() {
        guard let url = URL(string: "http://localhost:3000/api/usuarios/getAllAbogados") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedUsers in
                self?.users = fetchedUsers
            }
            .store(in: &cancellables)
    }

    // Función para verificar si el usuario autenticado es abogado
    func checkIfCurrentUserIsLawyer() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No hay usuario autenticado")
            return
        }

        let email = currentUser.email  // Obtener el email del usuario autenticado

        guard let url = URL(string: "http://localhost:3000/api/usuarios/userByEmail/\(email ?? "")") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al obtener el tipo de cuenta: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibió respuesta del servidor")
                return
            }

            // Procesar la respuesta, solo obtener el campo "tipo"
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let accountType = jsonResponse?["tipo"] as? String {
                    DispatchQueue.main.async {
                        // Si el tipo de cuenta es "abogado", actualizamos la variable
                        self.isCurrentUserLawyer = (accountType == "abogado")
                    }
                } else {
                    print("Error: No se encontró el campo 'tipo' en la respuesta")
                }
            } catch {
                print("Error al parsear la respuesta del servidor: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Función para convertir un cliente en abogado
    func convertToLawyer(email: String) {
        guard let url = URL(string: "http://localhost:3000/api/usuarios/convertirAbogado/\(email)") else {
            conversionMessage = "Error: URL inválida"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.conversionMessage = "Error al convertir: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.conversionMessage = "No se recibió respuesta del servidor"
                }
                return
            }

            // Procesar la respuesta
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                DispatchQueue.main.async {
                    if let message = jsonResponse?["message"] as? String {
                        self.conversionMessage = message
                    } else {
                        self.conversionMessage = "Error: Respuesta inesperada del servidor"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.conversionMessage = "Error al parsear la respuesta del servidor"
                }
            }
        }.resume()
    }
}
