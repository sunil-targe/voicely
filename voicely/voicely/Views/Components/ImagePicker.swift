import SwiftUI
import PhotosUI
import Vision

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var extractedText: String
    @Binding var isProcessing: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showMainView: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let result = results.first else { 
                picker.dismiss(animated: true)
                return 
            }
            
            parent.isProcessing = true
            
            // Don't dismiss the picker immediately - wait for processing to complete
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    if let error = error {
                        self.parent.alertMessage = "Failed to load image: \(error.localizedDescription)"
                        self.parent.showAlert = true
                        self.parent.isProcessing = false
                        picker.dismiss(animated: true)
                        return
                    }
                    
                    guard let image = object as? UIImage else {
                        self.parent.alertMessage = "Failed to load image"
                        self.parent.showAlert = true
                        self.parent.isProcessing = false
                        picker.dismiss(animated: true)
                        return
                    }
                    
                    // Start text extraction with timeout
                    let extractionTask = DispatchWorkItem {
                        print("ImagePicker: Starting text extraction...")
                        if let text = self.extractTextFromImage(image) {
                            print("ImagePicker: Text extraction successful, length: \(text.count)")
                            DispatchQueue.main.async {
                                self.parent.extractedText = text
                                self.parent.isProcessing = false
                                // Dismiss picker first, then show MainView
                                picker.dismiss(animated: true) {
                                    // Small delay to ensure picker is fully dismissed
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        print("ImagePicker: Opening MainView with extracted text")
                                        self.parent.showMainView = true
                                    }
                                }
                            }
                        } else {
                            print("ImagePicker: Text extraction failed - no text found")
                            DispatchQueue.main.async {
                                self.parent.alertMessage = "No readable text found in the image. Please try a different image with clearer text."
                                self.parent.showAlert = true
                                self.parent.isProcessing = false
                                picker.dismiss(animated: true)
                            }
                        }
                    }
                    
                    // Execute with timeout
                    DispatchQueue.global(qos: .userInitiated).async(execute: extractionTask)
                    
                    // Set timeout to prevent hanging
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                        if self.parent.isProcessing {
                            print("ImagePicker: Text extraction timeout")
                            extractionTask.cancel()
                            self.parent.alertMessage = "Text extraction timed out. Please try again with a simpler image."
                            self.parent.showAlert = true
                            self.parent.isProcessing = false
                            picker.dismiss(animated: true)
                        }
                    }
                }
            }
        }
        
        private func extractTextFromImage(_ image: UIImage) -> String? {
            guard let cgImage = image.cgImage else { return nil }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                // This will be handled in the completion
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["en-US"] // Add English as primary language
            request.minimumTextHeight = 0.01 // Lower threshold for better detection
            
            do {
                try requestHandler.perform([request])
                
                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    return nil
                }
                
                // Sort observations by vertical position (top to bottom)
                let sortedObservations = observations.sorted { obs1, obs2 in
                    obs1.boundingBox.minY > obs2.boundingBox.minY
                }
                
                let recognizedStrings = sortedObservations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                let rawText = recognizedStrings.joined(separator: " ")
                
                // Only return if we have meaningful text
                let cleanedText = cleanAndFormatText(rawText)
                return cleanedText.isEmpty ? nil : cleanedText
            } catch {
                print("Vision framework error: \(error)")
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