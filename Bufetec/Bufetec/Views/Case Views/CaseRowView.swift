import SwiftUI

struct CaseRowView: View {
    var legalCase: LegalCase

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(legalCase.caseName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#003366"))

                // Si deseas mostrar el `id`, puedes usar esta línea en lugar de `caseID`
                Text("ID: \(legalCase.id)") // Cambiado de `caseID` a `id`
                    .font(.caption)
                    .foregroundColor(Color(hex: "#757575"))
            }
            .padding(.leading, 8)

            Spacer()

            // Status indicator circle
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(statusColor(for: legalCase.status))
        }
        .padding()
        .background(Color.white) // Consistent background for list rows
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)
    }

    // Function to get status color
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "abierto":
            return Color.green
        case "en progreso":
            return Color.yellow
        case "cerrado":
            return Color.red
        default:
            return Color.gray
        }
    }
}

#Preview {
    CaseRowView(legalCase: LegalCase.defaultValue)
}
