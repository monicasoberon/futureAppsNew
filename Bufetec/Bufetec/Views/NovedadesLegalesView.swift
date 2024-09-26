//
//  NovedadesLegalesView.swift
//  Bufetec
//
//  Created by Luis Gzz on 25/09/24.
//

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
    
    var chatAPI = ChatGPTAPI() // Instancia de la clase ChatGPTAPI
    
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
                if isFetchingResponse {
                    ProgressView("Consultando a ChatGPT...") // Indicador de carga mientras se espera la respuesta
                } else if !chatGPTResponse.isEmpty {
                    Text("Respuesta de ChatGPT: \(chatGPTResponse)")
                        .padding()
                }
                
                List(filteredNews) { news in
                    VStack(alignment: .leading) {
                        Text(news.title)
                            .font(.headline)
                            .foregroundColor(Color.blue) // Título en azul
                        Text(news.description)
                            .font(.subheadline)
                            .foregroundColor(Color.gray) // Descripción en gris
                        Text(news.date)
                            .font(.footnote)
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.vertical, 5)
                    .background(Color.blue.opacity(0.1)) // Fondo ligeramente azul para cada noticia
                    .cornerRadius(8)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Novedades Legales en México")
                .background(Color.blue.opacity(0.05))
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.light, for: .navigationBar)
                .searchable(text: $searchText, prompt: "Buscar noticias legales o preguntar a ChatGPT")
                .onChange(of: searchText) { newValue in
                    if !newValue.isEmpty {
                        // Llamar a ChatGPT cuando se ingrese texto
                        fetchResponse(for: newValue)
                    }
                }
            }
        }
    }
    
    // Método para llamar a ChatGPT
    func fetchResponse(for query: String) {
        isFetchingResponse = true
        chatAPI.sendQuery(query) { response in
            DispatchQueue.main.async {
                self.chatGPTResponse = response
                self.isFetchingResponse = false
            }
        }
    }
}

#Preview {
    NovedadesLegales()
}
