import SwiftUI

struct CaseDetailView: View {
    var legalCase: LegalCase
    @State private var isVisible: Bool = false
    @State private var lawyerName: String = "Cargando..."
    @State private var clientName: String = "Cargando..."
    @State private var selectedStatus: String = ""
    @State private var isSaving = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL  // Variable de entorno añadida

    // Variable para determinar si el usuario es abogado
    var isAbogado: Bool

    var body: some View {
        ZStack {
            // Fondo degradado de toda la vista
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Nombre del Caso y Estatus
                    HStack {
                        VStack {
                            Text("Nombre del Caso:")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Text(legalCase.caseName)
                                .font(.title2)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: isVisible)

                        Spacer()

                        // Mostrar y cambiar estatus
                        VStack {
                            Text("Estatus:")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            if isAbogado {
                                Picker("Estatus", selection: $selectedStatus) {
                                    Text("Abierto").tag("abierto")
                                    Text("En Progreso").tag("en progreso")
                                    Text("Cerrado").tag("cerrado")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .onChange(of: selectedStatus, perform: { newValue in
                                    changeStatus(newStatus: newValue)
                                })
                            } else {
                                Text(legalCase.status)
                                    .font(.title2)
                                    .bold()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.1), value: isVisible)
                    }
                    .padding(.horizontal)

                    // Información del abogado
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)

                        Text("Abogado: \(lawyerName)")
                            .font(.body)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.2), value: isVisible)

                    // Información del cliente
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)

                        Text("Cliente: \(clientName)")
                            .font(.body)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.3), value: isVisible)

                    Divider()
                        .padding(.horizontal)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.4), value: isVisible)

                    // Detalles del caso
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Detalles del Caso:")
                            .font(.headline)
                            .bold()
                        Text(legalCase.caseDetails.isEmpty ? "Detalles no disponibles" : legalCase.caseDetails)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.5), value: isVisible)

                    // Sección de Archivos
                    if !legalCase.files.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Archivos:")
                                .font(.headline)
                                .bold()

                            ForEach(legalCase.files, id: \.self) { fileURLString in
                                if let fileURL = URL(string: fileURLString) {
                                    // Extraer un nombre de archivo para mostrar
                                    let fileName = fileURL.lastPathComponent.isEmpty ? "Archivo" : fileURL.lastPathComponent

                                    Button(action: {
                                        openURL(fileURL)
                                    }) {
                                        HStack {
                                            Image(systemName: "doc.text")
                                                .foregroundColor(.blue)
                                            Text(fileName)
                                                .foregroundColor(.blue)
                                                .underline()
                                        }
                                        .padding(8)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(8)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                        .padding(.horizontal)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.6), value: isVisible)
                    }

                    Spacer()
                }
                .navigationTitle(legalCase.caseName)
                .onAppear {
                    isVisible = true
                    fetchUserDetails(for: legalCase.lawyerAssigned) { name in
                        self.lawyerName = name
                    }
                    fetchUserDetails(for: legalCase.clientID) { name in
                        self.clientName = name
                    }
                    selectedStatus = legalCase.status
                }
            }
        }
    }

    // Función para obtener los detalles del usuario (nombre) a partir del _id
    func fetchUserDetails(for userId: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/usuarios/userById/\(userId)") else {
            print("URL inválida")
            completion("No disponible")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al obtener detalles del usuario: \(error)")
                completion("No disponible")
                return
            }

            guard let data = data else {
                print("No se recibió respuesta")
                completion("No disponible")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let name = json["nombre"] as? String {
                    DispatchQueue.main.async {
                        completion(name)
                    }
                }
            } catch {
                print("Error al parsear la respuesta: \(error)")
                completion("No disponible")
            }
        }.resume()
    }

    // Función para cambiar el estatus del caso
    func changeStatus(newStatus: String) {
        guard let url = URL(string: "http://localhost:3000/api/casos/cambiarEstatus/\(legalCase.id)") else {
            print("URL inválida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "nuevoEstatus": newStatus
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al cambiar estatus: \(error)")
            } else {
                print("Estatus cambiado a \(newStatus)")
            }
        }.resume()
    }
}

// Función que define los colores del estatus
func statusColor(for status: String) -> Color {
    switch status.lowercased() {
    case "en progreso":
        return Color.yellow
    case "abierto":
        return Color.green
    case "cerrado":
        return Color.red
    default:
        return Color.gray
    }
}

#Preview {
    CaseDetailView(legalCase: LegalCase.defaultValue, isAbogado: true)
}
