import SwiftUI

struct HomePageView: View {
    @ObservedObject var viewModel: UserViewModel
    @ObservedObject var citasViewModel: CitasViewModel
    @StateObject private var citasviewModel2 = CitasViewModel()

    
    @Binding var selectedMenuOption: SideMenuOptionModel

    // State variable to hold the selected lawyer for navigation
    @State private var selectedLawyer: UserModel?

    // State variable to hold random lawyers
    @State private var randomLawyers: [UserModel] = []

    // Computed property to get the first 3 citas
    private var topCitas: [CitasModel] {
        Array(citasViewModel.citas.prefix(3))
    }

    var body: some View {
        NavigationStack {
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
                                    selectedMenuOption = .casesView
                                }) {
                                    VStack {
                                        Text("Mis Casos")
                                    }
                                    .padding()
                                    .background(Color.cyan)
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
                                    especialty: user.especiality,
                                    onProfileView: { selectedLawyer = user } // Set selected lawyer
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                        // Citas Recientes - Top 3 Citas
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Citas Recientes")
                                .font(.headline)
                                .padding(.horizontal)

                            if let userEmail = citasviewModel2.userEmail {
                                if citasviewModel2.citas.isEmpty {
                                    Text("No hay citas para el usuario \(userEmail).")
                                        .padding()
                                        .foregroundColor(.gray)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 10) { // Wrap in HStack for horizontal layout
                                            ForEach(citasviewModel2.citas) { cita in
                                                NewsCardView(cita: cita)
                                                    .frame(width: 300) // Set a fixed width for each card
                                                    .padding(.vertical) // Adjust padding as needed
                                            }
                                        }
                                        .padding(.horizontal) // Optional padding around HStack
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
                DispatchQueue.main.async {
                    viewModel.fetchUsers()
                    citasviewModel2.fetchUserEmail()
                }
            }
            .onReceive(viewModel.$users) { users in
                if randomLawyers.isEmpty && !users.isEmpty {
                    randomLawyers = Array(users.shuffled().prefix(3))
                }
            }
            .onReceive(citasViewModel.$citas) { citas in
                print("Number of citas loaded in HomePageView: \(citas.count)") // Debugging
                print("Top 3 citas: \(topCitas)") // To confirm the top 3 citas
            }
            // Navigation to LawyerDetailView
            .navigationDestination(isPresented: .constant(selectedLawyer != nil)) {
                if let lawyer = selectedLawyer {
                    LawyerDetailView(user: lawyer)
                        .onDisappear {
                            // Reset selected lawyer when navigation is dismissed
                            selectedLawyer = nil
                        }
                }
            }
        }
    }
}



// MARK: - Reusable Components

struct LawyerCardView: View {
    var name: String
    var especialty: String
    var onProfileView: () -> Void

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
                onProfileView() // Notify the action
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
    var cita: CitasModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Client Name
            Text("Cliente: \(cita.cliente_nombre ?? "N/A")")
                .font(.subheadline)
                .bold()
                .foregroundColor(Color(hex: "#003366"))
            
            // Lawyer Name
            Text("Abogado: \(cita.abogado_nombre ?? "N/A")")
                .font(.subheadline)
                .foregroundColor(Color.blue.opacity(0.7))

            // Appointment Time
            Text("Hora: \(formatDate(cita.hora))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 3)
    }

    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium    // Example: Oct 16, 2024
        formatter.timeStyle = .short     // Example: 4:00 PM
        return formatter.string(from: date)
    }
}


#Preview {
    HomePageView(viewModel: UserViewModel(), citasViewModel: CitasViewModel(), selectedMenuOption: .constant(.homeView))
}
