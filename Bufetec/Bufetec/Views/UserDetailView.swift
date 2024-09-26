import SwiftUI

struct LawyerDetailView: View {
    var user: UserModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Fallback image if no URL or default picture is provided
            Image("default_picture")
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 160)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(20)

            Text("Nombre: \(user.name)")
                .font(.title2)
                .bold()

            Text("Correo: \(user.email)")
                .font(.subheadline)

            Text("Especialidad: \(user.especiality)")
                .font(.subheadline)

            Text("Descripción del Abogado: \(user.description)")
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Detalles del Abogado")
    }
}
