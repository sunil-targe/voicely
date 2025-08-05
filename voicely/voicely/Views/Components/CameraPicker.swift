import SwiftUI
import Vision

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var extractedText: String
    @Binding var isProcessing: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showExtractedTextView: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            
            guard let image = info[.originalImage] as? UIImage else {
                parent.alertMessage = "Failed to capture image"
                parent.showAlert = true
                return
            }
            
            parent.isProcessing = true
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                
                if let text = self.extractTextFromImage(image) {
                    DispatchQueue.main.async {
                        self.parent.extractedText = text
                        self.parent.isProcessing = false
                        self.parent.showExtractedTextView = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.parent.alertMessage = "No text found in the captured image"
                        self.parent.showAlert = true
                        self.parent.isProcessing = false
                    }
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        private func extractTextFromImage(_ image: UIImage) -> String? {
            guard let cgImage = image.cgImage else { return nil }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                // This will be handled in the completion
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            do {
                try requestHandler.perform([request])
                
                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    return nil
                }
                
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                let rawText = recognizedStrings.joined(separator: " ")
                return cleanAndFormatText(rawText)
            } catch {
                return nil
            }
        }
        
        private func cleanAndFormatText(_ rawText: String) -> String {
            var cleanedText = rawText
            
            // Remove HTML tags but preserve structure
            cleanedText = cleanedText.replacingOccurrences(of: "<[^>]*>", with: "", options: .regularExpression)
            
            // Remove CSS styles
            cleanedText = cleanedText.replacingOccurrences(of: "\\{[^}]*\\}", with: "", options: .regularExpression)
            
            // Remove color codes and formatting
            cleanedText = cleanedText.replacingOccurrences(of: "#[0-9A-Fa-f]{6}", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "rgb\\([^)]*\\)", with: "", options: .regularExpression)
            
            // Remove font family declarations
            cleanedText = cleanedText.replacingOccurrences(of: "font-family:[^;]*;", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "font-size:[^;]*;", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "font-weight:[^;]*;", with: "", options: .regularExpression)
            
            // Remove common RTF formatting
            cleanedText = cleanedText.replacingOccurrences(of: "\\\\[a-z]+[0-9]*", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "\\\\'[0-9a-fA-F]{2}", with: "", options: .regularExpression)
            
            // Remove extra whitespace and normalize
            cleanedText = cleanedText.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "\\n\\s*\\n", with: "\n\n", options: .regularExpression)
            
            // Remove empty lines at the beginning and end
            cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Format paragraphs properly
            cleanedText = cleanedText.replacingOccurrences(of: "\n{3,}", with: "\n\n", options: .regularExpression)
            
            // Capitalize first letter of sentences
            let sentences = cleanedText.components(separatedBy: ". ")
            let formattedSentences = sentences.map { sentence in
                if !sentence.isEmpty {
                    return sentence.prefix(1).uppercased() + sentence.dropFirst()
                }
                return sentence
            }
            cleanedText = formattedSentences.joined(separator: ". ")
            
            // Ensure proper spacing after punctuation
            cleanedText = cleanedText.replacingOccurrences(of: "([.!?])([A-Za-z])", with: "$1 $2", options: .regularExpression)
            
            return cleanedText
        }
    }
} 