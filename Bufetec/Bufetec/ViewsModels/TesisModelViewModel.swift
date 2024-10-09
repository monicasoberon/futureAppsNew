import Foundation
import Combine

class TesisModelViewModel: ObservableObject {
    @Published var tesisModel: [TesisModel] = []
    @Published var searchText = "" {
        didSet {
            fetchGPTResponse(for: searchText)  // Trigger ChatGPT call when searchText changes
        }
    }
    @Published var chatGPTResponse = ""
    @Published var isFetchingResponse = false

    var cancellables = Set<AnyCancellable>()

    var filteredNews: [TesisModel] {
        if searchText.isEmpty {
            return tesisModel
        } else {
            return tesisModel.filter { news in
                news.tesis.lowercased().contains(searchText.lowercased()) ||
                news.description.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Fetching the news from the API
    func fetchTesisModel() {
        guard let url = URL(string: "http://localhost:3000/api/tesis/") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TesisModel].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedNews in
                self?.tesisModel = fetchedNews
            }
            .store(in: &cancellables)
    }

    // Fetching ChatGPT response from the API
    func fetchGPTResponse(for question: String) {
        // Check for empty or whitespace-only question
        guard !question.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Error: Question is empty. No API call made.")
            self.chatGPTResponse = ""
            return
        }
        
        isFetchingResponse = true
        SearchModel.shared.callGPTAPI(with: question) { [weak self] result in
            DispatchQueue.main.async {
                self?.isFetchingResponse = false
                switch result {
                case .success(let response):
                    self?.chatGPTResponse = response["answer"] as? String ?? "No answer found."
                    print("GPT API Response: \(response)")
                case .failure(let error):
                    self?.chatGPTResponse = "Error: \(error.localizedDescription)"
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
