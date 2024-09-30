import Foundation
import Combine

class LegalNewsViewModel: ObservableObject {
    @Published var legalNews: [LegalNews] = []
    @Published var searchText = ""
    @Published var chatGPTResponse = ""
    @Published var isFetchingResponse = false

    var cancellables = Set<AnyCancellable>()

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

    // Fetching the news from the API
    func fetchLegalNews() {
        guard let url = URL(string: "http://localhost:3000/api/noticias/") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [LegalNews].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedNews in
                self?.legalNews = fetchedNews
            }
            .store(in: &cancellables)
    }
}
