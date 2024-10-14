//
//  PrecedentesViewModel.swift
//  Bufetec
//
//  Created by Jorge on 14/10/24.
//

import Foundation
import Combine

class PrecedentesViewModel: ObservableObject {
    @Published var precedentesList: [PrecedentesModel] = []
    @Published var filteredPrecedentes: [PrecedentesModel] = []
    @Published var gptResponseArray: [Int] = []
    @Published var searchText = ""
    @Published var isFetchingResponse = false
    
    // Computed property to display the saved `registroDigital` numbers
    var gptResponseDisplay: String {
        gptResponseArray.map(String.init).joined(separator: ", ")
    }
    
    private let url = URL(string: "http://localhost:3000/api/precedentes/")!

    func fetchAllPrecedentes() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch tesis: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let precedentes = try JSONDecoder().decode([PrecedentesModel].self, from: data)
                DispatchQueue.main.async {
                    self.precedentesList = precedentes
                    self.filteredPrecedentes = precedentes
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchGPTResponse(for question: String) {
        guard !question.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.filteredPrecedentes = precedentesList
            return
        }

        isFetchingResponse = true
        SearchModel2.shared.callGPTAPI(with: question) { [weak self] result in
            DispatchQueue.main.async {
                self?.isFetchingResponse = false
                switch result {
                case .success(let response):
                    print("API call success. Response:", response)  // Debugging print
                    if let messageString = response["message"] as? String {
                        // Parse the string into an array of Int
                        if let data = messageString.data(using: .utf8),
                           let ids = try? JSONSerialization.jsonObject(with: data, options: []) as? [Int] {
                            print("Successfully parsed IDs:", ids)  // Confirm successful parsing
                            self?.gptResponseArray = ids
                            self?.applyFilterWithResponseIDs()
                            print("Fetched registroDigital IDs: \(ids)")  // Print the array to console
                        } else {
                            print("Failed to parse `message` as [Int]. Original message string:", messageString)
                            self?.filteredPrecedentes = []
                        }
                    } else {
                        print("Unexpected format: `message` key not a string. Actual response:", response)
                    }
                case .failure(let error):
                    print("Error in API call: \(error.localizedDescription)")
                }
            }
        }
    }



    
    private func applyFilterWithResponseIDs() {
        let idStrings = gptResponseArray.map(String.init)
        filteredPrecedentes = precedentesList.filter { idStrings.contains($0.registroDigital) }
    }
}
