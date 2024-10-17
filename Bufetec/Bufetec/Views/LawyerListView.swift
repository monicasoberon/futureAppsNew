import SwiftUI

struct LawyerListView: View {
    @StateObject var viewModel = UserViewModel()  // Usa tu ViewModel existente

    var body: some View {
        ZStack {
            // Fondo degradado de azul claro a blanco
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Título estilizado
                Text("Selecciona un Abogado")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 20)

                // Lista desplazable de abogados
                ScrollView {
                    VStack(spacing: 32) {
                        // Recorre los usuarios (abogados) y renderiza cada uno
                        ForEach(viewModel.users, id: \.id) { user in
                            lawyerRow(for: user)  // Refactorizado a una función separada para mayor legibilidad
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchUsers()  // Obtiene los abogados (usuarios)
        }
    }

    // Función para renderizar cada fila de abogado
    @ViewBuilder
    func lawyerRow(for user: UserModel) -> some View {
        NavigationLink(destination: LawyerAvailabilityView(lawyer: user)) {
            HStack(spacing: 20) {
                // Imagen de perfil del abogado con AsyncImage
                AsyncImage(url: URL(string: user.photo)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(color: Color.blue.opacity(0.3), radius: 6)
                    case .failure:
                        Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(color: Color.blue.opacity(0.3), radius: 6)
                    @unknown default:
                        EmptyView()
                    }
                }

                // Nombre y especialidad del abogado
                VStack(alignment: .leading, spacing: 5) {
                    Text(user.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#003366"))

                    Text(user.especiality)
                        .font(.subheadline)
                        .foregroundColor(Color.blue.opacity(0.8))
                }

                Spacer()
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.6), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    LawyerListView()
}
