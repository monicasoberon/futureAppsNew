import SwiftUI

struct HomePageView: View {
    @ObservedObject var viewModel: UserViewModel
    @ObservedObject var tesisViewModel: TesisModelViewModel
    @Binding var selectedMenuOption: SideMenuOptionModel

    // Computed property to get 3 random lawyers
    private var randomLawyers: [UserModel] {
        Array(viewModel.users.shuffled().prefix(3))
    }

    // Computed property to get 3 random tesis
    private var randomTesis: [TesisModel] {
        Array(tesisViewModel.tesisList.shuffled().prefix(3))
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    // Hero Section
                    Image("bufetec_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Justicia al Alcance de Todos")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#003366"))
                            .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)

                        HStack(spacing: 15) {
                            Button(action: {
                                selectedMenuOption = .lawyersView
                            }) {
                                Text("Buscar Abogado")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                selectedMenuOption = .appointmentView
                            }) {
                                Text("Generar Cita")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                selectedMenuOption = .tesisView
                            }) {
                                VStack {
                                    Text("Ver")
                                    Text("Tesis")
                                }
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    // Featured Lawyers (Random 3 Lawyers)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Abogados")
                            .font(.headline)

                        ForEach(randomLawyers, id: \.id) { user in
                            LawyerCardView(
                                name: user.name,
                                especialty: user.especiality
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    // Legal News Feed - Random 3 Tesis
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tesis Recientes")
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(randomTesis, id: \.registroDigital) { tesis in
                                    NewsCardView(title: tesis.tesis)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    // Contact and Support
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Necesitas Ayuda?")
                                .font(.headline)

                            Button("Contactar Soporte") {
                                selectedMenuOption = .contactView
                            }
                            .font(.system(size: 13.5))
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)

                            Text("Dudas?")
                                .font(.headline)

                            Button("FAQ") {
                                selectedMenuOption = .faqView
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchUsers() // Ensure users are fetched
            tesisViewModel.fetchAllTesis() // Ensure tesis are fetched
        }
    }
}



// MARK: - Reusable Components

struct LawyerCardView: View {
    var name: String
    var especialty: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(name)")
                    .font(.subheadline).bold()
                    .foregroundColor(Color(hex: "#003366"))
                Text(especialty)
                    .font(.caption)
                    .foregroundColor(Color.blue.opacity(0.7))
            }
            Spacer()
            Button("Ver Perfil") {
                // Navigation action
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 3)
    }
}

struct NewsCardView: View {
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(Color(hex: "#003366"))
            Text("Click to read more")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 3)
    }
}

#Preview {
    HomePageView(viewModel: UserViewModel(), tesisViewModel: TesisModelViewModel(), selectedMenuOption: .constant(.homeView))
}
