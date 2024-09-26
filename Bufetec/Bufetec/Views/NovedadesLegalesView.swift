import SwiftUI

struct LegalNews: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: String
}

struct NovedadesLegales: View {
    @State private var legalNews: [LegalNews] = [
        LegalNews(title: "Nueva reforma laboral en México", description: "El gobierno aprobó una reforma para mejorar las condiciones laborales.", date: "25 de septiembre, 2024"),
        LegalNews(title: "Cambios en el sistema judicial", description: "El poder judicial introduce cambios significativos en los procedimientos penales.", date: "20 de septiembre, 2024"),
        LegalNews(title: "Regulaciones sobre fintech", description: "La CNBV regula aún más el uso de criptomonedas y empresas fintech.", date: "15 de septiembre, 2024"),
        LegalNews(title: "Modificaciones a la ley de propiedad intelectual", description: "Cambios recientes en la ley protegen a los creadores de contenido digital.", date: "10 de septiembre, 2024")
    ]
    
    @State private var searchText = ""
    @State private var chatGPTResponse = ""
    @State private var isFetchingResponse = false
    
    var filteredNews: [LegalNews] {
        if searchText.isEmpty {
            return legalNews
        } else {
            return legalNews.filter { news in
                news.title.lowercased().contains(searchText.lowercased()) ||
                news.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Buscar novedades legales...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Legal News List
                List(filteredNews) { news in
                    VStack(alignment: .leading) {
                        Text(news.title)
                            .font(.headline)
                        Text(news.description)
                            .font(.subheadline)
                        Text(news.date)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                // ChatGPT Response
                if isFetchingResponse {
                    ProgressView("Cargando respuesta...")
                } else if !chatGPTResponse.isEmpty {
                    Text(chatGPTResponse)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Novedades Legales")
        }
    }
}

#Preview {
    NovedadesLegales()
}
