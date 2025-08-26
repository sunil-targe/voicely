import Foundation
import FirebaseStorage
import FirebaseCore

// MARK: - Firebase Storage Service Protocol
protocol FirebaseStorageServiceProtocol {
    func uploadAudioFile(_ audioData: Data, fileName: String) async throws -> String
    func deleteAudioFile(fileName: String) async throws
}

// MARK: - Firebase Storage Service Implementation
class FirebaseStorageService: FirebaseStorageServiceProtocol {
    private let storage = Storage.storage()
    private let bucketName = "voicely_clones"
    
    // MARK: - Upload Audio File
    func uploadAudioFile(_ audioData: Data, fileName: String) async throws -> String {
        let storageRef = storage.reference()
        let audioRef = storageRef.child("\(bucketName)/\(fileName)")
        
        // Set metadata for the audio file
        let metadata = StorageMetadata()
        metadata.contentType = "audio/wav"
        metadata.cacheControl = "public, max-age=31536000" // 1 year cache
        
        do {
            // Upload the file
            let _ = try await audioRef.putDataAsync(audioData, metadata: metadata)
            
            // Get the download URL
            let downloadURL = try await audioRef.downloadURL()
            
            print("FirebaseStorageService: Audio uploaded successfully")
            print("FirebaseStorageService: Download URL: \(downloadURL.absoluteString)")
            
            return downloadURL.absoluteString
        } catch {
            print("FirebaseStorageService: Upload failed with error: \(error)")
            throw FirebaseStorageError.uploadFailed(error)
        }
    }
    
    // MARK: - Delete Audio File
    func deleteAudioFile(fileName: String) async throws {
        let storageRef = storage.reference()
        let audioRef = storageRef.child("\(bucketName)/\(fileName)")
        
        do {
            try await audioRef.delete()
            print("FirebaseStorageService: Audio file deleted successfully: \(fileName)")
        } catch {
            print("FirebaseStorageService: Delete failed with error: \(error)")
            throw FirebaseStorageError.deleteFailed(error)
        }
    }
}

// MARK: - Firebase Storage Error Types
enum FirebaseStorageError: LocalizedError {
    case uploadFailed(Error)
    case deleteFailed(Error)
    case invalidFileName
    case invalidAudioData
    
    var errorDescription: String? {
        switch self {
        case .uploadFailed(let error):
            return "Failed to upload audio file: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete audio file: \(error.localizedDescription)"
        case .invalidFileName:
            return "Invalid file name provided"
        case .invalidAudioData:
            return "Invalid audio data provided"
        }
    }
}

// MARK: - Audio File Name Generator
struct AudioFileNameGenerator {
    static func generateFileName(for voiceName: String) -> String {
        let timestamp = Date().timeIntervalSince1970
        let sanitizedName = voiceName.replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "[^a-zA-Z0-9_-]", with: "", options: .regularExpression)
        return "voice_clone_\(sanitizedName)_\(Int(timestamp)).wav"
    }
}
