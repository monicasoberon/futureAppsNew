import SwiftUI

struct LawyerDetailView: View {
    var user: UserModel

    @State private var showDetail = false  // Estado para alternar la vista detallada

    var body: some View {
        ZStack {
            // Fondo degradado azul claro
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .center, spacing: 20) {

                // Título personalizado para los detalles del abogado
                Text("Detalles del Abogado")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top,70)

                // Imagen ajustada del perfil
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: showDetail ? 240 : 280, height: showDetail ? 240 : 280) // Animación de escala
                            .shadow(color: Color.blue.opacity(0.4), radius: 20, x: 0, y: 10)

                        // Utilizamos AsyncImage para cargar la imagen desde la URL
                        AsyncImage(url: URL(string: user.photo)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: showDetail ? 220 : 260, height: showDetail ? 220 : 260)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: showDetail ? 220 : 260, height: showDetail ? 220 : 260)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                                    .scaleEffect(showDetail ? 1 : 1.1)
                            case .failure:
                                // Imagen de marcador de posición si falla la carga
                                Image("default_picture")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: showDetail ? 220 : 260, height: showDetail ? 220 : 260)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                                    .scaleEffect(showDetail ? 1 : 1.1)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 10)

                // Información del abogado en una tarjeta animada
                if showDetail {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Información del Abogado")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.bottom, 5)

                            // Nombre del abogado
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .shadow(color: .blue.opacity(0.2), radius: 2, x: 0, y: 2)

                            // Correo con icono
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            // Especialidad con icono
                            HStack {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(.blue)
                                Text("Especialidad: \(user.especiality)")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }

                            // Descripción con etiqueta en negrita
                            Text("Descripción:")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(user.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.6), value: showDetail)
                        Spacer()
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
        .padding(.top, -80)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.spring()) {
                    showDetail = true
                }
            }
        }
    }
}
