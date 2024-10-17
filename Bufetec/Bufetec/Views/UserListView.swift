import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = UserViewModel()
    @State private var isCreatingLawyer = false
    @State private var emailInput = ""
    @State private var conversionMessage: String? = nil

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Lista de Abogados")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 20)

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
                    VStack(spacing: 32) {
                        ForEach(viewModel.users, id: \.id) { user in
                            NavigationLink(destination: LawyerDetailView(user: user)) {
                                HStack(spacing: 20) {
                                    AsyncImage(url: URL(string: user.photo)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 90, height: 90)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 90, height: 90)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                                .shadow(color: Color.blue.opacity(0.3), radius: 4)
                                        case .failure:
                                            Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 90, height: 90)
                                                .foregroundColor(.gray)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                                .shadow(color: Color.blue.opacity(0.3), radius: 4)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(user.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "#003366"))

                                        Text(user.especiality)
                                            .font(.subheadline)
                                            .foregroundColor(Color.blue.opacity(0.7))
                                    }

                                    Spacer()
                                }
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                                )
                                .scaleEffect(1.02)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                }

                // Resto de tu código...
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchUsers()
            viewModel.checkIfCurrentUserIsLawyer()
        }
        .onChange(of: viewModel.conversionMessage) { newMessage in
            conversionMessage = newMessage
        }
    }
}

#Preview {
    UserListView()
}
