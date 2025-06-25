import Foundation

class SpeechService {
    private let apiKey = AppSecrets.apiKey // secrete key
    private let endpoint = "https://api.replicate.com/v1/predictions"

    func generateSpeech(text: String, voiceID: String, emotion: String, channel: String, languageBoost: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        debugPrint(">>>\(apiKey)")
        let body: [String: Any] = [
            "version": "e284910d4e34c005ad32f20ab45194417c9d0425fb94c22d8470e2a3c22525fa", // Replace with actual version from Replicate
            "input": [
                "text": text,
                "voice_id": voiceID,
                "emotion": emotion,
                "channel": channel,
                "language_boost": languageBoost
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            // Print raw response for debugging
            print("Raw response: ", String(data: data, encoding: .utf8) ?? "No response string")
            // Try to decode error response first
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                print("API Error: \(apiError.detail)")
                completion(.failure(NSError(domain: "SpeechService", code: 2, userInfo: [NSLocalizedDescriptionKey: apiError.detail])))
                return
            }
            do {
                let prediction = try JSONDecoder().decode(PredictionResponse.self, from: data)
                self.pollForResult(predictionID: prediction.id, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func pollForResult(predictionID: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let statusURLString = "https://api.replicate.com/v1/predictions/\(predictionID)"
        guard let url = URL(string: statusURLString) else { return }
        var request = URLRequest(url: url)
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        func poll() {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error { completion(.failure(error)); return }
                guard let data = data else { return }
                // Print raw response for debugging
                print("Polling response: ", String(data: data, encoding: .utf8) ?? "No response string")
                // Try to decode error response first
                if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    print("API Error: \(apiError.detail)")
                    completion(.failure(NSError(domain: "SpeechService", code: 2, userInfo: [NSLocalizedDescriptionKey: apiError.detail])))
                    return
                }
                do {
                    let prediction = try JSONDecoder().decode(PredictionResponse.self, from: data)
                    if prediction.status == "succeeded", let audioURLString = prediction.output, let audioURL = URL(string: audioURLString) {
                        completion(.success(audioURL))
                    } else if prediction.status == "failed" {
                        completion(.failure(NSError(domain: "SpeechService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Speech generation failed"])) )
                    } else {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                            poll()
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
        poll()
    }
}

struct PredictionResponse: Decodable {
    let id: String
    let status: String
    let output: String?
}

struct APIErrorResponse: Decodable {
    let detail: String
} 
