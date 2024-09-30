import SwiftUI

struct NovedadesLegales: View {
    @ObservedObject var viewModel = LegalNewsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Buscar novedades legales...", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Legal News List
                List(viewModel.filteredNews) { news in
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
                if viewModel.isFetchingResponse {
                    ProgressView("Cargando respuesta...")
                } else if !viewModel.chatGPTResponse.isEmpty {
                    Text(viewModel.chatGPTResponse)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Novedades Legales")
            .onAppear {
                viewModel.fetchLegalNews()  // Fetch news when the view appears
            }
        }
    }
}

#Preview {
    NovedadesLegales()
}
