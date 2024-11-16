//
//  NetworkingManager.swift
//  TranslateMe
//
//  Created by Noah Russell on 11/16/24.
//

import Foundation

class NetworkingManager {
    static func translate(input: String, from sourceLang: String, to targetLang: String, completion: @escaping (Result<String, Error>) -> Void) {
        let baseUrl = "https://api.mymemory.translated.net/get"
        
        // URL encode the source language and target language for the query parameters
        guard let encodedSourceLang = sourceLang.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedTargetLang = targetLang.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "Invalid language", code: 400, userInfo: [NSLocalizedDescriptionKey: "The source or target language could not be URL encoded."])))
            return
        }

        // Prepare the body parameters for the POST request
        let parameters = [
            "q": input,
            "langpair": "\(sourceLang)|\(targetLang)"
        ]
        
        // Create the URL for the POST request
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: [NSLocalizedDescriptionKey: "The constructed URL is invalid."])))
            return
        }

        // Set up the URLRequest for the POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Convert the parameters to a URL-encoded query string
        let bodyString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        // Start the network request
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: [NSLocalizedDescriptionKey: "No data received from the translation service."])))
                return
            }

            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let responseData = json["responseData"] as? [String: Any],
                   let translatedText = responseData["translatedText"] as? String {
                    // Decode any percent-encoded characters
                    let decodedText = translatedText.removingPercentEncoding ?? translatedText
                    completion(.success(decodedText))
                } else {
                    // Handle unexpected response format
                    completion(.failure(NSError(domain: "Parsing error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse the translation response."])))
                }
            } catch {
                // Handle JSON parsing error
                completion(.failure(NSError(domain: "JSON parsing error", code: 500, userInfo: [NSLocalizedDescriptionKey: "There was an error parsing the translation response."])))
            }
        }.resume()
    }
}
