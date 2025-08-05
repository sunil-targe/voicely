import SwiftUI
import UniformTypeIdentifiers
import Vision

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var extractedText: String
    @Binding var isProcessing: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showExtractedTextView: Bool
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [.plainText, .rtf, .rtfd, .pdf]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            parent.isProcessing = true
            
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                do {
                    let text = try self.extractTextFromFile(at: url)
                    DispatchQueue.main.async {
                        self.parent.extractedText = text
                        self.parent.isProcessing = false
                        self.parent.showExtractedTextView = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.parent.alertMessage = "Failed to extract text: \(error.localizedDescription)"
                        self.parent.showAlert = true
                        self.parent.isProcessing = false
                    }
                }
            }
        }
        
        private func extractTextFromFile(at url: URL) throws -> String {
            let fileExtension = url.pathExtension.lowercased()
            
            switch fileExtension {
            case "txt":
                let text = try String(contentsOf: url, encoding: .utf8)
                return cleanAndFormatText(text)
                
            case "rtf", "rtfd":
                let attributedString = try NSAttributedString(url: url, options: [:], documentAttributes: nil)
                let text = attributedString.string
                return cleanAndFormatText(text)
                
            case "pdf":
                return try extractTextFromPDF(at: url)
                
            default:
                // Try to read as plain text
                let text = try String(contentsOf: url, encoding: .utf8)
                return cleanAndFormatText(text)
            }
        }
        
        private func extractTextFromPDF(at url: URL) throws -> String {
            guard let pdfDocument = CGPDFDocument(url as CFURL) else {
                throw NSError(domain: "PDFError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to open PDF"])
            }
            
            var extractedText = ""
            let pageCount = pdfDocument.numberOfPages
            
            for pageIndex in 1...pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { continue }
                
                let pageRect = page.getBoxRect(.mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                
                let image = renderer.image { context in
                    UIColor.white.setFill()
                    context.fill(pageRect)
                    
                    context.cgContext.translateBy(x: 0, y: pageRect.size.height)
                    context.cgContext.scaleBy(x: 1, y: -1)
                    context.cgContext.drawPDFPage(page)
                }
                
                if let text = extractTextFromImage(image) {
                    extractedText += text + "\n\n"
                }
            }
            
            return cleanAndFormatText(extractedText)
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