//
//  CitasViewModel.swift
//  Bufetec
//
//  Created by Luis Gzz on 15/10/24.
//

import Foundation
import Combine

class CitasViewModel: ObservableObject {
    @Published var citas: [CitasModel] = []
    var cancellables = Set<AnyCancellable>()
    
    @Published var userEmail: String? = nil

    func fetchUserEmail() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No hay usuario autenticado")
            return
        }
        
        guard let email = currentUser.email else {
            print("No se ha obtenido el correo electrónico del usuario")
            return
        }
        
        DispatchQueue.main.async {
            self.userEmail = email
            self.fetchCitas() // Llamamos a fetchCitas una vez obtenemos el email
        }
    }

    func fetchCitas() {
        guard let email = userEmail else {
            print("No se ha obtenido el correo electrónico del usuario")
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/api/citaByEmail/\(email)") else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [CitasModel].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedCitas in
                self?.citas = fetchedCitas
            }
            .store(in: &cancellables)
    }
}
