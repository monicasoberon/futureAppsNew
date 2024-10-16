import SwiftUI

struct HomePageView: View {
    @ObservedObject var lawyerviewModel: UserViewModel
    @Binding var selectedMenuOption: SideMenuOptionModel

    @State private var searchQuery = ""
    @State private var legalNews = [
        "New Business Law Regulations",
        "Recent Family Law Updates",
        "Civil Rights Legal Changes"
    ]
    
    // Computed property to get 3 random lawyers
    private var randomLawyers: [UserModel] {
        Array(lawyerviewModel.users.shuffled().prefix(3))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Section with logo and shadow effect
                Image("bufetec_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300)
                    .frame(maxWidth: .infinity)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 10, x: 0, y: 5)

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
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedMenuOption = .appointmentView
                        }) {
                            Text("Generar Cita")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedMenuOption = .tesisView
                        }) {
                            Text("Ver Tesis")
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)

                // Featured Lawyers (Random 3 Lawyers)
                VStack(alignment: .leading, spacing: 15) {
                    Text("Abogados")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#003366"))

                    ForEach(randomLawyers, id: \.id) { user in
                        LawyerCardView(
                            name: user.name,
                            especialty: user.especiality
                        )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)

                // Legal News Feed
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tesis Recientes")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#003366"))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(legalNews, id: \.self) { news in
                                NewsCardView(title: news)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)

                // Contact and Support
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Necesitas Ayuda?")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#003366"))

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
                            .foregroundColor(Color(hex: "#003366"))

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
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
            }
            .padding()
        }
        .onAppear {
            lawyerviewModel.fetchUsers() // Ensure users are fetched
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

// Preview
#Preview {
    HomePageView(lawyerviewModel: UserViewModel(), selectedMenuOption: .constant(.homeView))
}
