//
//  CitasView.swift
//  Bufetec
//
//  Created by Luis Gzz on 15/10/24.
//
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
                        List(viewModel.citas, id: \.id) { cita in
                            CitaRowView(cita: cita)
                        }
                    }
                } else {
                    Text("Cargando el correo electrónico del usuario...")
                        .padding()
                }
            }
            .navigationTitle("Citas")
            .onAppear {
                viewModel.fetchUserEmail()
            }
        }
    }
}

struct CitaRowView: View {
    let cita: CitasModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("ID de Cita: \(cita.id)")
                .font(.headline)
            Text("Cliente ID: \(cita.cliente_id)")
                .font(.subheadline)
            Text("Abogado ID: \(cita.abogado_id)")
                .font(.subheadline)
            Text("Hora: \(formatDate(cita.hora))")
                .font(.subheadline)
        }
        .padding()
    }
    
    // Helper function to format the date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    CitasView()
}
