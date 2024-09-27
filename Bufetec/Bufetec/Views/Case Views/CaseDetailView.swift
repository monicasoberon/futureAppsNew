import SwiftUI

struct CaseDetailView: View {
    var legalCase: LegalCase
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // ID del caso y estado
                HStack {
                    VStack {
                        Text("CaseID:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(legalCase.caseID)
                            .font(.title2)
                            .bold()
                    }
                    .padding()
                    .background(Color(hex: "#D0E8F2"))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isVisible)
                    
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(statusColor(for: legalCase.status))
                            .frame(width: 16, height: 16)
                        VStack(alignment: .leading) {
                            Text("Estado:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(legalCase.status)
                                .font(.title2)
                                .bold()
                        }
                    }
                    .padding()
                    .background(Color(hex: "#D0E8F2"))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.1), value: isVisible)
                }
                .padding(.horizontal)
                
                // Información del abogado asignado
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text("Abogado: \(legalCase.lawyerAssigned)")
                        .font(.body)
                }
                .padding()
                .background(Color(hex: "#D0E8F2"))
                .cornerRadius(12)
                .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5).delay(0.2), value: isVisible)
                
                // Cliente afectado
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text("Cliente: \(legalCase.clientID)")
                        .font(.body)
                }
                .padding()
                .background(Color(hex: "#D0E8F2"))
                .cornerRadius(12)
                .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5).delay(0.3), value: isVisible)
                
                Divider()
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.4), value: isVisible)
                
                // Detalles del caso
                VStack(alignment: .leading, spacing: 8) {
                    Text("Detalles del Caso:")
                        .font(.headline)
                        .bold()
                    Text(legalCase.caseDetails.isEmpty ? "Detalles no disponibles" : legalCase.caseDetails)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(hex: "#D0E8F2"))
                .cornerRadius(12)
                .shadow(color: Color("#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5).delay(0.5), value: isVisible)
                
                // Archivos
                VStack(alignment: .leading, spacing: 8) {
                    Text("Documentos:")
                        .font(.headline)
                        .bold()
                    if legalCase.files.isEmpty {
                        Text("No hay documentos disponibles")
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(legalCase.files, id: \.self) { file in
                            HStack {
                                Image(systemName: "doc.fill")
                                    .foregroundColor(.blue)
                                Text(file)
                                    .font(.body)
                            }
                            .padding(8)
                            .background(Color(hex: "#D0E8F2"))
                            .cornerRadius(8)
                            .shadow(color: Color("#0D214D").opacity(0.3), radius: 2, x: 0, y: 2)
                        }
                    }
                }
                .padding()
                .background(Color(hex: "#D0E8F2"))
                .cornerRadius(12)
                .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5).delay(0.6), value: isVisible)
                
                Spacer()
            }
            .padding(.top)
            .onAppear {
                isVisible = true
            }
        }
        .navigationTitle("\(legalCase.caseName)")
        .background(Color(hex: "#E6F2FF").ignoresSafeArea())
    }
}

func statusColor(for status: String) -> Color {
    switch status.lowercased() {
    case "en progreso":
        return Color.yellow
    case "abierto":
        return Color.green
    case "cerrado":
        return Color.red
    default:
        return Color.gray
    }
}
