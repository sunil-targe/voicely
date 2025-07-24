import SwiftUI
import UniformTypeIdentifiers
import Vision
import PDFKit

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var extractedText: String
    @Binding var isProcessing: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showMainView: Bool
    
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
            
            // On real devices, we need to start accessing the security-scoped resource
            let shouldStopAccessing = url.startAccessingSecurityScopedResource()
            
            // Start text extraction with timeout
            let extractionTask = DispatchWorkItem {
                do {
                    let text = try self.extractTextFromFile(at: url)
                    DispatchQueue.main.async {
                        self.parent.extractedText = text
                        self.parent.isProcessing = false
                        self.parent.showMainView = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.parent.alertMessage = "Failed to extract text: \(error.localizedDescription)"
                        self.parent.showAlert = true
                        self.parent.isProcessing = false
                    }
                }
                
                // Always stop accessing the security-scoped resource
                if shouldStopAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            // Execute with timeout
            DispatchQueue.global(qos: .userInitiated).async(execute: extractionTask)
            
            // Set timeout to prevent hanging
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                if self.parent.isProcessing {
                    print("DocumentPicker: Text extraction timeout")
                    extractionTask.cancel()
                    self.parent.alertMessage = "Text extraction timed out. Please try again with a smaller file."
                    self.parent.showAlert = true
                    self.parent.isProcessing = false
                    
                    // Stop accessing the security-scoped resource
                    if shouldStopAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
            }
        }
        
        private func extractTextFromFile(at url: URL) throws -> String {
            let fileExtension = url.pathExtension.lowercased()
            print("DocumentPicker: Extracting text from file: \(url.lastPathComponent), extension: \(fileExtension)")
            
            switch fileExtension {
            case "txt":
                print("DocumentPicker: Processing text file")
                let text = try String(contentsOf: url, encoding: .utf8)
                print("DocumentPicker: Text file read successfully, length: \(text.count)")
                return cleanAndFormatText(text)
                
            case "rtf", "rtfd":
                print("DocumentPicker: Processing RTF file")
                let attributedString = try NSAttributedString(url: url, options: [:], documentAttributes: nil)
                let text = attributedString.string
                print("DocumentPicker: RTF file processed successfully, length: \(text.count)")
                return cleanAndFormatText(text)
                
            case "pdf":
                print("DocumentPicker: Processing PDF file")
                return try extractTextFromPDF(at: url)
                
            default:
                print("DocumentPicker: Unknown file type, trying as plain text")
                // Try to read as plain text
                let text = try String(contentsOf: url, encoding: .utf8)
                print("DocumentPicker: File read as plain text successfully, length: \(text.count)")
                return cleanAndFormatText(text)
            }
        }
        
        private func extractTextFromPDF(at url: URL) throws -> String {
            print("DocumentPicker: Attempting to extract text from PDF at: \(url.path)")
            
            // Try multiple approaches for PDF text extraction
            var extractedText = ""
            
            // Approach 1: Try using PDFKit (more reliable on real devices)
            if let pdfDocument = PDFDocument(url: url) {
                print("DocumentPicker: Using PDFKit for extraction")
                let pageCount = pdfDocument.pageCount
                
                for pageIndex in 0..<pageCount {
                    if let page = pdfDocument.page(at: pageIndex) {
                        if let pageContent = page.string {
                            extractedText += pageContent + "\n\n"
                        }
                    }
                }
                
                if !extractedText.isEmpty {
                    print("DocumentPicker: PDFKit extraction successful, text length: \(extractedText.count)")
                    return cleanAndFormatText(extractedText)
                }
            }
            
            // Approach 2: Fallback to Core Graphics (for older PDFs)
            print("DocumentPicker: Falling back to Core Graphics PDF extraction")
            guard let pdfDocument = CGPDFDocument(url as CFURL) else {
                print("DocumentPicker: Failed to open PDF with Core Graphics")
                throw NSError(domain: "PDFError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to open PDF document"])
            }
            
            let pageCount = pdfDocument.numberOfPages
            print("DocumentPicker: PDF has \(pageCount) pages")
            
            for pageIndex in 1...pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { 
                    print("DocumentPicker: Failed to access page \(pageIndex)")
                    continue 
                }
                
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
                    print("DocumentPicker: Extracted text from page \(pageIndex), length: \(text.count)")
                } else {
                    print("DocumentPicker: No text extracted from page \(pageIndex)")
                }
            }
            
            if extractedText.isEmpty {
                throw NSError(domain: "PDFError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No text content found in PDF"])
            }
            
            print("DocumentPicker: Core Graphics extraction successful, total text length: \(extractedText.count)")
            return cleanAndFormatText(extractedText)
        }
        
        private func extractTextFromImage(_ image: UIImage) -> String? {
            guard let cgImage = image.cgImage else { 
                print("DocumentPicker: Failed to get CGImage from UIImage")
                return nil 
            }
            
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
                    print("DocumentPicker: No text observations found in image")
                    return nil
                }
                
                print("DocumentPicker: Found \(observations.count) text observations")
                
                // Sort observations by vertical position (top to bottom)
                let sortedObservations = observations.sorted { obs1, obs2 in
                    obs1.boundingBox.minY > obs2.boundingBox.minY
                }
                
                let recognizedStrings = sortedObservations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                let rawText = recognizedStrings.joined(separator: " ")
                let cleanedText = cleanAndFormatText(rawText)
                
                print("DocumentPicker: Image text extraction successful, raw length: \(rawText.count), cleaned length: \(cleanedText.count)")
                return cleanedText.isEmpty ? nil : cleanedText
            } catch {
                print("DocumentPicker: Vision framework error: \(error)")
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
