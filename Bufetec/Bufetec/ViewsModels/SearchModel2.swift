//
//  SearchModel2.swift
//  Bufetec
//
//  Created by Jorge on 14/10/24.
//

import Foundation

class SearchModel2 {
    
    static let shared = SearchModel2()  // Singleton instance
    
    private init() {}  // Private init to prevent instantiation
    
    // Function to make the API call
    func callGPTAPI(with question: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        print("Question received by callGPTAPI: '\(question)'")  // Log the question
        
        // Prepare the URL and request
        guard let url = URL(string: "http://localhost:3000/api/gpt2") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Use JSONEncoder to encode the JSON body
        let body = ["question": question]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
            print("JSON body being sent: \(body)")  // Log JSON body content
        } catch {
            completion(.failure(error))
            print("Error encoding JSON: \(error.localizedDescription)")
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Error during API call: \(error.localizedDescription)")
                return
            }
            
            // Log the HTTP response status
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                print("Error: No data received from API.")
                return
            }
            
            // Parse the response JSON
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                    print("GPT API Response: \(jsonResponse)")  // Print response to the console
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
                    completion(.failure(error))
                    print("Error: Invalid JSON format")
                }
            } catch {
                completion(.failure(error))
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
