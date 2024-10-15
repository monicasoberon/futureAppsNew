import SwiftUI

struct CreateCaseView: View {
    var abogadoId: String? // El ID del abogado asignado al caso
    @State private var clienteId: String = "" // El cliente seleccionado para el caso
    @State private var caseName: String = ""
    @State private var caseDetails: String = ""
    @State private var clientes: [Client] = [] // Lista de clientes para seleccionar
    @State private var isLoading = true // Estado de carga para obtener los clientes
    @Environment(\.dismiss) var dismiss // Para volver a la pantalla anterior

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss() // Botón de cancelar para volver atrás
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding(.leading)
                
                Spacer()
            }
            
            Text("Crear un nuevo caso")
                .font(.title)
                .padding()

            if isLoading {
                ProgressView("Cargando clientes...")
                    .onAppear(perform: fetchClientes)
            } else {
                // Selección del cliente
                Text("Seleccionar Cliente")
                    .font(.headline)
                    .padding(.top)

                Picker("Seleccionar Cliente", selection: $clienteId) {
                    ForEach(clientes, id: \.id) { client in
                        Text(client.name).tag(client.id)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // Nombre del caso
                Text("Nombre del Caso")
                    .font(.headline)
                    .padding(.top)
                TextField("Nombre del Caso", text: $caseName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()

                // Detalles del caso
                Text("Detalles del Caso")
                    .font(.headline)
                    .padding(.top)
                TextEditor(text: $caseDetails)
                    .frame(height: 150)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()

                // Botón para crear el caso
                Button(action: {
                    createNewCase() // Acción para crear el caso
                }) {
                    Text("Crear Caso")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .padding()
    }

    // Función para obtener la lista de clientes
    func fetchClientes() {
        guard let url = URL(string: "http://localhost:3000/api/usuarios/getAllClientes") else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedClients = try JSONDecoder().decode([Client].self, from: data)
                    DispatchQueue.main.async {
                        self.clientes = decodedClients
                        self.isLoading = false
                        
                        // Selección automática del primer cliente si está disponible
                        if let firstClient = clientes.first {
                            self.clienteId = firstClient.id
                        }
                    }
                } catch {
                    print("Error al decodificar clientes: \(error)")
                }
            }
        }.resume()
    }

    // Función para crear un nuevo caso
    func createNewCase() {
        guard let abogadoId = abogadoId else { return }
        
        guard let url = URL(string: "http://localhost:3000/api/casos/crearCaso/") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "cliente_id": clienteId,
            "abogado_asignado": abogadoId,
            "detalles": caseDetails,
            "nombre": caseName
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al crear el caso: \(error)")
            } else {
                print("Caso creado exitosamente")
                DispatchQueue.main.async {
                    dismiss() // Volver a la pantalla anterior tras crear el caso
                }
            }
        }.resume()
    }
}

// Modelo de Cliente
struct Client: Identifiable, Codable {
    var id: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "nombre"
    }
}
