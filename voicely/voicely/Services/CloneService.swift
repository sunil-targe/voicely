import Foundation
import AVFoundation

class CloneService {
    private let apiKey = AppSecrets.apiKey
    private let endpoint = "https://api.replicate.com/v1/predictions"
    
    func cloneVoice(audioData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(CloneServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert audio data to base64 for API
        let base64Audio = audioData.base64EncodedString()
        let audioDataURI = "data:audio/wav;base64,\(base64Audio)"
        
        let body: [String: Any] = [
            "version": "aa25ee1296b5c036b003ef80d32c83983c522e8c7d6f108460bbb0af97ebe93a", // version hash from Replicate
            "input": [
                "voice_file": audioDataURI
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(CloneServiceError.noData))
                return
            }
            
            // Print raw response for debugging
            print("Clone API Response: ", String(data: data, encoding: .utf8) ?? "No response string")
            
            // Try to decode error response first
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                print("Clone API Error: \(apiError.detail)")
                completion(.failure(NSError(domain: "CloneService", code: 2, userInfo: [NSLocalizedDescriptionKey: apiError.detail])))
                return
            }
            
            do {
                let prediction = try JSONDecoder().decode(ClonePredictionResponse.self, from: data)
                self.pollForCloneResult(predictionID: prediction.id, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func pollForCloneResult(predictionID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let statusURLString = "https://api.replicate.com/v1/predictions/\(predictionID)"
        guard let url = URL(string: statusURLString) else {
            completion(.failure(CloneServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        func poll() {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(CloneServiceError.noData))
                    return
                }
                
                // Print raw response for debugging
                print("Clone Polling response: ", String(data: data, encoding: .utf8) ?? "No response string")
                
                // Try to decode error response first
                if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    print("Clone API Error: \(apiError.detail)")
                    completion(.failure(NSError(domain: "CloneService", code: 2, userInfo: [NSLocalizedDescriptionKey: apiError.detail])))
                    return
                }
                
                do {
                    let prediction = try JSONDecoder().decode(ClonePredictionResponse.self, from: data)
                    
                    if prediction.status == "succeeded", let voiceID = prediction.output {
                        completion(.success(voiceID))
                    } else if prediction.status == "failed" {
                        completion(.failure(CloneServiceError.cloningFailed))
                    } else {
                        // Still processing, poll again after delay
                        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
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

// MARK: - Response Models
struct ClonePredictionResponse: Decodable {
    let id: String
    let status: String
    let output: String? // The voice_id returned from the API
}

// MARK: - Error Types
enum CloneServiceError: LocalizedError {
    case invalidURL
    case noData
    case cloningFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .noData:
            return "No data received from server"
        case .cloningFailed:
            return "Voice cloning failed"
        }
    }
}
