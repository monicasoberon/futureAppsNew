import SwiftUI

struct CaseDetailView: View {
    
    var legalCase: LegalCase
    @State private var isVisible: Bool = false

    var body: some View {
        ZStack {
            // Full-view background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea() // Extend the gradient across the entire screen

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
                        .background(Color.white.opacity(0.8)) // Lighter background for readability
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
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.1), value: isVisible)
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
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.2), value: isVisible)
                    
                    // Affected Person
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        
                        Text("Persona afectada: \(legalCase.clientID)")
                            .font(.body)
                            .padding(.horizontal)
                            .opacity(isVisible ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5).delay(0.3), value: isVisible)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.2), value: isVisible)
                    
                    Divider()
                        .padding(.horizontal)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.4), value: isVisible)
                    
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
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.5), value: isVisible)
                    
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
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 2, x: 0, y: 2)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(color: Color(hex: "#0D214D").opacity(0.3), radius: 4, x: 0, y: 4)
                    .padding(.horizontal)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.6), value: isVisible)
                    
                    Spacer()
                }
                .navigationTitle("\(legalCase.caseName)")
                .padding(.top)
                .onAppear {
                    isVisible = true
                }
            }
        }
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

#Preview {
    CaseDetailView(legalCase: LegalCase.defaultValue)
}
