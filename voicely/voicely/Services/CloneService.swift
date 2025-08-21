import Foundation
import AVFoundation

class CloneService {
    private let apiKey = AppSecrets.apiKey
    private let endpoint = "https://api.replicate.com/v1/predictions"
    private let firebaseStorageService: FirebaseStorageServiceProtocol
    
    init(firebaseStorageService: FirebaseStorageServiceProtocol = FirebaseStorageService()) {
        self.firebaseStorageService = firebaseStorageService
    }
    
    func cloneVoice(audioData: Data, voiceName: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Validate audio data
        guard audioData.count > 0 else {
            completion(.failure(CloneServiceError.invalidAudioData))
            return
        }
        
        // Check if audio data is too large (Replicate has limits)
        let maxSize = 19 * 1024 * 1024 // 19MB limit
        guard audioData.count <= maxSize else {
            completion(.failure(CloneServiceError.audioTooLarge))
            return
        }
        
        print("CloneService: Audio data size: \(audioData.count) bytes")
        
        // Generate unique file name
        let fileName = AudioFileNameGenerator.generateFileName(for: voiceName)
        print("CloneService: Generated file name: \(fileName)")
        
        // Upload to Firebase Storage first
        Task {
            do {
                let publicURL = try await firebaseStorageService.uploadAudioFile(audioData, fileName: fileName)
                print("CloneService: Audio uploaded to Firebase: \(publicURL)")
                
                // Now call the voice cloning API with the public URL
                await MainActor.run {
                    self.callVoiceCloningAPI(voiceFileURL: publicURL, completion: completion)
                }
            } catch {
                print("CloneService: Firebase upload failed: \(error)")
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func callVoiceCloningAPI(voiceFileURL: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(CloneServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Token \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "version": "aa25ee1296b5c036b003ef80d32c83983c522e8c7d6f108460bbb0af97ebe93a", // version hash from Replicate
            "input": [
                "voice_file": voiceFileURL,
                "accuracy": 0.7,
                "need_noise_reduction": false,
                "need_volume_normalization": false
            ]
        ]
        
        print("CloneService: Voice cloning request body: \(body)")
        
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
                    
                    print("CloneService: Prediction status: \(prediction.status)")
                    print("CloneService: Prediction output: \(prediction.output?.voice_id ?? "nil")")
                    
                    if prediction.status == "succeeded", let output = prediction.output {
                        print("CloneService: Voice cloning succeeded with ID: \(output.voice_id)")
                        completion(.success(output.voice_id))
                    } else if prediction.status == "failed" {
                        print("CloneService: Voice cloning failed")
                        let errorMessage = prediction.error ?? "Unknown error"
                        print("CloneService: Error details: \(errorMessage)")
                        completion(.failure(NSError(domain: "CloneService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Voice cloning failed: \(errorMessage)"])))
                    } else {
                        print("CloneService: Still processing, polling again in 2 seconds...")
                        // Still processing, poll again after delay
                        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                            poll()
                        }
                    }
                } catch {
                    print("CloneService: JSON decoding error: \(error)")
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
    let output: CloneOutput?
    let error: String?
    let logs: String?
}

struct CloneOutput: Decodable {
    let voice_id: String
    let model: String
    let preview: String?
}

// MARK: - Error Types
enum CloneServiceError: LocalizedError {
    case invalidURL
    case noData
    case cloningFailed
    case invalidAudioData
    case audioTooLarge
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .noData:
            return "No data received from server"
        case .cloningFailed:
            return "Voice cloning failed"
        case .invalidAudioData:
            return "Invalid audio data provided"
        case .audioTooLarge:
            return "Audio file is too large (max 50MB)"
        }
    }
}
