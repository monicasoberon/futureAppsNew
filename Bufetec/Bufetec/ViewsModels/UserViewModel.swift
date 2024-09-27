import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers() {
        guard let url = URL(string: "http://localhost:3000/api/usuarios/getAllAbogados") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedUsers in
                self?.users = fetchedUsers
            }
            .store(in: &cancellables)
    }
}
