import Combine
import FirebaseAuth

class CaseViewModel: ObservableObject {
    @Published var cases: [LegalCase] = []
    @Published var userId: String? = nil  // Almacenar el _id de MongoDB del usuario
    @Published var isAbogado: Bool = false // Agregar una propiedad para rastrear si el usuario es abogado

    private var cancellables = Set<AnyCancellable>()

    // Función para obtener el _id del usuario autenticado desde el backend
    func fetchUserId() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No hay usuario autenticado")
            return
        }
        
        guard let email = currentUser.email else {
            print("No se ha obtenido el correo electrónico del usuario")
            return
        }

        // Hacer la solicitud al endpoint para obtener el _id del usuario
        guard let url = URL(string: "http://localhost:3000/api/usuarios/userByEmail/\(email)") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al hacer la solicitud: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibió respuesta del servidor")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let userId = jsonResponse?["_id"] as? String, let tipo = jsonResponse?["tipo"] as? String {
                    DispatchQueue.main.async {
                        self.userId = userId
                        self.isAbogado = (tipo == "abogado") // Actualizamos isAbogado según el tipo
                        self.fetchCases() // Llamamos a fetchCases una vez obtenemos el userId
                    }
                }
            } catch {
                print("Error al parsear la respuesta del servidor: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Función para obtener los casos del usuario
    func fetchCases() {
        guard let userId = userId else {
            print("No se ha obtenido el _id del usuario")
            return
        }

        guard let url = URL(string: "http://localhost:3000/api/casos/casosPorUsuario/\(userId)") else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [LegalCase].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedCases in
                self?.cases = fetchedCases
            }
            .store(in: &cancellables)
    }
}
