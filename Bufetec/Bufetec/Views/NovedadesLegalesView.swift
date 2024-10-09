import SwiftUI

struct NovedadesLegales: View {
    @ObservedObject var viewModel = TesisModelViewModel()

    var body: some View {
        ZStack {
            // Full-screen background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea() // Extend the gradient across the entire view

            VStack {
                // Custom Title
                Text("Novedades Legales")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#003366"))
                    .padding(.top, 20)
                    .padding(.leading, 16)

                // Search Bar
                TextField("Buscar novedades legales...", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Legal News List
                List(viewModel.filteredNews, id: \.id) { news in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(news.registroDigital)
                            .font(.headline)
                            .foregroundColor(Color(hex: "#003366"))
                        Text(news.tesis)
                            .font(.subheadline)
                        Text(news.description)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                            .truncationMode(.tail)
                    }
                    .padding(.vertical, 8)
                }
                .background(Color.clear) // Ensure List has a clear background
                .scrollContentBackground(.hidden) // Hide default background of the List

                // ChatGPT Response
                if viewModel.isFetchingResponse {
                    ProgressView("Cargando respuesta...")
                        .padding()
                } else if !viewModel.chatGPTResponse.isEmpty {
                    Text(viewModel.chatGPTResponse)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .onAppear {
                viewModel.fetchTesisModel()  // Fetch news when the view appears
            }
        }
    }
}

#Preview {
    NovedadesLegales()
}
