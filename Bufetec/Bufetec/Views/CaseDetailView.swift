//
//  CaseDetailView.swift
//  Bufetec
//
//  Created by Jorge on 17/09/24.
//
import SwiftUI

struct CaseDetailView: View {
    
    var legalCase: LegalCase
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // CaseID and Status
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
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#D0E8F2")) // Azul claro
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(statusColor(for: legalCase.status))
                            .frame(width: 16, height: 16)
                        
                        VStack(alignment: .leading) {
                            Text("Status:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(legalCase.status)
                                .font(.title2)
                                .bold()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#D0E8F2")) // Azul claro
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                }
                .padding(.horizontal)
                
                // Lawyer Info
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    
                    Text("Abogado: \(legalCase.lawyerAssigned)")
                        .font(.body)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#D0E8F2")) // Azul claro
                .cornerRadius(12)
                .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                .padding(.horizontal)
                
                // Affected person
                Text("Persona afectada: \(legalCase.clientID)")
                    .font(.body)
                    .padding(.horizontal)
                Divider()
                    .padding(.horizontal)
                
                // Case Details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Datos en general sobre el caso específico:")
                        .font(.headline)
                        .bold()
                    Text(legalCase.caseDetails.isEmpty ? "Detalles no disponibles" : legalCase.caseDetails)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(hex: "#D0E8F2")) // Azul claro
                .cornerRadius(12)
                .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                .padding(.horizontal)
                
                // Documents Section
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
                                    .foregroundColor(.primary)
                            }
                            .padding(8)
                            .background(Color(hex: "#D0E8F2")) // Azul claro
                            .cornerRadius(8)
                            .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 2, x: 0, y: 2)
                        }
                    }
                }
                .padding()
                .background(Color(hex: "#D0E8F2")) // Azul claro
                .cornerRadius(12)
                .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Detalles del Caso")
            .padding(.top)
            .background(Color(hex: "#E6F2FF").ignoresSafeArea()) // Fondo azul claro
        }
        .background(Color(hex: "#E6F2FF").ignoresSafeArea()) // Fondo azul claro
    }
}

// Function that defines the colors for status
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

// Extension to use hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    CaseDetailView(legalCase: LegalCase.defaultValue)
}
