import SwiftUI

struct CitasView: View {
    @StateObject private var viewModel = CitasViewModel()
    @State private var showCitas = false  // State to control the animation
    
    var body: some View {
        ZStack {
            // Light blue gradient background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 20) {
                // Custom title for Citas
                Text("Mis Citas")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 50)

                if let userEmail = viewModel.userEmail {
                    if viewModel.citas.isEmpty {
                        Text("No hay citas para el usuario \(userEmail).")
                            .padding()
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            ForEach(viewModel.citas) { cita in
                                CitaCardView(cita: cita)
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(.easeInOut(duration: 0.6), value: showCitas)
                            }
                        }
                    }
                } else {
                    Text("Cargando el correo electrónico del usuario...")
                        .padding()
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .onAppear {
                viewModel.fetchUserEmail()
                withAnimation(.spring()) {
                    showCitas = true
                }
            }
        }
    }
}

// Sub-view to display each cita as a card
struct CitaCardView: View {
    let cita: CitasModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ID de Cita: \(cita.id)")
                .font(.headline)
                .foregroundColor(.primary)

            if let clienteNombre = cita.cliente_nombre {
                Text("Cliente: \(clienteNombre)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Cliente ID: \(cita.cliente_id)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let abogadoNombre = cita.abogado_nombre {
                Text("Abogado: \(abogadoNombre)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Abogado ID: \(cita.abogado_id)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text("Hora: \(formatDate(cita.hora))")
                .font(.subheadline)
                .foregroundColor(.primary)
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
        .padding(.top, 10)
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
    CitasView()
}
