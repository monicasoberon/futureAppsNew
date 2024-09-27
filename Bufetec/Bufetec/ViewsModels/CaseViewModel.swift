import Foundation
import Combine

class CaseViewModel: ObservableObject {
    @Published var cases: [LegalCase] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCases() {
        guard let url = URL(string: "http://localhost:3000/api/casos/") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [LegalCase].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedCases in
                self?.cases = fetchedCases
            }
            .store(in: &cancellables)
    }
}
