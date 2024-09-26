import Foundation
import Combine

class FaqViewModel: ObservableObject {
    @Published var faqs: [FaqModel] = []
    var cancellables = Set<AnyCancellable>()
    
    func fetchFAQs() {
        guard let url = URL(string: "http://localhost:3000/api/faq/") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [FaqModel].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedFaqs in
                self?.faqs = fetchedFaqs
            }
            .store(in: &cancellables)
    }
}
