import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = UserViewModel()
    @State private var isCreatingLawyer = false // Track if we're creating a new lawyer
    @State private var emailInput = "" // Email input for new lawyer
    @State private var conversionMessage: String? = nil // Message after lawyer conversion

    var body: some View {
        ZStack {
            // Fondo degradado azul claro a blanco
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Título estilizado
                Text("Lista de Abogados")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 20)

                // Mostrar botón si el usuario autenticado es abogado
                if viewModel.isCurrentUserLawyer {
                    Button(action: {
                        isCreatingLawyer = true
                    }) {
                        Text("Crear Nuevo Abogado")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }

                ScrollView {
                    VStack(spacing: 32) {  // Espaciado para un look más espacioso
                        ForEach(viewModel.users, id: \.id) { user in
                            NavigationLink(destination: LawyerDetailView(user: user)) {
                                HStack(spacing: 20) {  // Espaciado ajustado para un look limpio
                                    // Imagen del abogado con sombra reducida
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 90, height: 90)  // Tamaño aumentado para mayor énfasis
                                        .foregroundColor(.gray)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 1)) // Borde blanco
                                        .shadow(color: Color.blue.opacity(0.3), radius: 4)  // Sombra ajustada

                                    VStack(alignment: .leading, spacing: 5) {
                                        // Nombre del abogado con look profesional
                                        Text(user.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "#003366"))

                                        // Especialidad del abogado
                                        Text(user.especiality)
                                            .font(.subheadline)
                                            .foregroundColor(Color.blue.opacity(0.7))
                                    }

                                    Spacer()
                                }
                                .padding(20)  // Padding adicional para mayor espacio de toque
                                .background(Color.white)  // Fondo blanco para contraste
                                .cornerRadius(15)  // Bordes redondeados para un look pulido
                                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)  // Borde sutil
                                )
                                .scaleEffect(1.02)  // Escalado sutil para mayor énfasis
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                }

                // Modal para agregar nuevo abogado
                if isCreatingLawyer {
                    VStack {
                        Text("Convertir a Cliente en Abogado")
                            .font(.headline)
                            .padding()

                        TextField("Ingresa el email del cliente", text: $emailInput)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)

                        Button(action: {
                            viewModel.convertToLawyer(email: emailInput)
                            isCreatingLawyer = false
                        }) {
                            Text("Convertir")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }

                        Button("Cancelar") {
                            isCreatingLawyer = false
                        }
                        .padding(.top, 10)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)
                }

                if let message = conversionMessage {
                    Text(message)
                        .font(.body)
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchUsers()
            viewModel.checkIfCurrentUserIsLawyer()  // Llamar la función para verificar si es abogado
        }
        .onChange(of: viewModel.conversionMessage) { newMessage in
            conversionMessage = newMessage
        }
    }
}

#Preview {
    UserListView()
}
