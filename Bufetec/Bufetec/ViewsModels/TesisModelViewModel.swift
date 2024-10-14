import Foundation
import Combine

class TesisModelViewModel: ObservableObject {
    @Published var tesisList: [TesisModel] = []
    @Published var filteredTesis: [TesisModel] = []
    @Published var gptResponseArray: [Int] = []
    @Published var searchText = ""
    @Published var isFetchingResponse = false
    
    // Computed property to display the saved `registroDigital` numbers
    var gptResponseDisplay: String {
        gptResponseArray.map(String.init).joined(separator: ", ")
    }
    
    private let url = URL(string: "http://localhost:3000/api/tesis/")!

    func fetchAllTesis() {
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
                let tesis = try JSONDecoder().decode([TesisModel].self, from: data)
                DispatchQueue.main.async {
                    self.tesisList = tesis
                    self.filteredTesis = tesis
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchGPTResponse(for question: String) {
        guard !question.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.filteredTesis = tesisList
            return
        }

        isFetchingResponse = true
        SearchModel.shared.callGPTAPI(with: question) { [weak self] result in
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
                            self?.filteredTesis = []
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
        filteredTesis = tesisList.filter { idStrings.contains($0.registroDigital) }
    }
}
