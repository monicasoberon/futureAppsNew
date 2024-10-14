
import SwiftUI

struct PrecedentesView: View {
    @StateObject private var viewModel = PrecedentesViewModel()
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title with styling
                Text("Precedentes (Sentencias)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 20)

                // Search Bar with styling
                TextField("Buscar precedentes...", text: $viewModel.searchText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onSubmit {
                        viewModel.fetchGPTResponse(for: viewModel.searchText)
                    }
                
                if viewModel.isFetchingResponse {
                    ProgressView("Buscando respuesta...")
                        .padding()
                }

                // Filtered List of Tesis with card style and color palette
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.filteredPrecedentes) { precedente in
                            Link(destination: URL(string: "https://sjfsemanal.scjn.gob.mx/detalle/ejecutoria/\(precedente.registroDigital)")!) {
                                VStack(alignment: .leading, spacing: 6) { // Changes to centered alignment
                                    Text(precedente.registroDigital)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#003366"))

                                    Text(precedente.precedente.replacingOccurrences(of: "\n", with: " "))
                                        .font(.subheadline)
                                        .foregroundColor(Color.blue.opacity(0.7))
                                        .lineLimit(3)
                                        .truncationMode(.tail)

                                    Text(precedente.notas.replacingOccurrences(of: "\n", with: " "))
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.gray)
                                        .lineLimit(3)
                                        .truncationMode(.tail)

                                    
                                    Text(precedente.promovente.replacingOccurrences(of: "\n", with: " "))
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .lineLimit(3)
                                        .truncationMode(.tail)
                                }
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                                )
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchAllPrecedentes()
        }
    }
}

#Preview {
    PrecedentesView()
}
