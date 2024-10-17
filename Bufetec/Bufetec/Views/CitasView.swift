import SwiftUI

struct CitasView: View {
    @StateObject private var viewModel = CitasViewModel()
    @State private var showCitas = false  // Estado para controlar la animación

    var body: some View {
        ZStack {
            // Fondo degradado azul claro
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .center, spacing: 20) {
                // Título personalizado para Citas
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

// Sub-vista para mostrar cada cita como una tarjeta
struct CitaCardView: View {
    let cita: CitasModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Mostrar solo el nombre del cliente y la hora
            Text("Cliente: \(cita.cliente_nombre ?? "N/A")")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Abogado: \(cita.abogado_nombre ?? "N/A")")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Hora: \(formatDate(cita.hora))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(height: 120) // Establecer una altura fija para todas las tarjetas
        .frame(maxWidth: .infinity) // Opcional: hacer que la tarjeta ocupe todo el ancho disponible
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

    // Función auxiliar para formatear la fecha
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium    // Ejemplo: 16 oct. 2024
        formatter.timeStyle = .short     // Ejemplo: 4:00 p. m.
        return formatter.string(from: date)
    }
}

#Preview {
    CitasView()
}
