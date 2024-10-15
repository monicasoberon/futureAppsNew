import SwiftUI

struct CitasView: View {
    @StateObject private var viewModel = CitasViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let userEmail = viewModel.userEmail {
                    if viewModel.citas.isEmpty {
                        Text("No hay citas para el usuario \(userEmail).")
                            .padding()
                    } else {
                        List(viewModel.citas) { cita in
                            VStack(alignment: .leading) {
                                Text("ID de Cita: \(cita.id)")
                                    .font(.headline)
                                
                                if let clienteNombre = cita.cliente_nombre {
                                    Text("Cliente: \(clienteNombre)")
                                        .font(.subheadline)
                                } else {
                                    Text("Cliente ID: \(cita.cliente_id)")
                                        .font(.subheadline)
                                }
                                
                                if let abogadoNombre = cita.abogado_nombre {
                                    Text("Abogado: \(abogadoNombre)")
                                        .font(.subheadline)
                                } else {
                                    Text("Abogado ID: \(cita.abogado_id)")
                                        .font(.subheadline)
                                }
                                
                                Text("Hora: \(formatDate(cita.hora))")
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                    }
                } else {
                    Text("Cargando el correo electrónico del usuario...")
                        .padding()
                        .onAppear {
                            viewModel.fetchUserEmail()
                        }
                }
            }
            .navigationTitle("Citas")
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.citas.isEmpty && viewModel.userEmail != nil },
            set: { _ in }
        )) {
            Alert(title: Text("Error"), message: Text("No se pudieron cargar las citas"), dismissButton: .default(Text("OK")))
        }
    }
    
    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium    // Ejemplo: Oct 16, 2024
        formatter.timeStyle = .short     // Ejemplo: 4:00 PM
        return formatter.string(from: date)
    }
}

#Preview {
    CitasView()
}
