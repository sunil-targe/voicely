//
//  UploadFileView.swift
//  voicely
//
//  Created by Gaurav on 02/08/25.
//

import SwiftUI
import UniformTypeIdentifiers
import VisionKit
import PhotosUI
import Vision

struct UploadFileView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showOptionsSheet = false
    @State private var showDocumentPicker = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var extractedText = ""
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedImage: UIImage?
    @State private var showFullScreenText = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Upload File")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Choose a file or take a photo to extract text")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                // Upload Button
                Button(action: {
                    showOptionsSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Select File or Photo")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.up")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                
                Spacer()
                
                if isProcessing {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Processing file...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showOptionsSheet) {
            UploadOptionsSheet(
                showDocumentPicker: $showDocumentPicker,
                showImagePicker: $showImagePicker,
                showCamera: $showCamera
            )
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(extractedText: $extractedText, isProcessing: $isProcessing, showAlert: $showAlert, alertMessage: $alertMessage, showFullScreenText: $showFullScreenText)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, extractedText: $extractedText, isProcessing: $isProcessing, showAlert: $showAlert, alertMessage: $alertMessage, showFullScreenText: $showFullScreenText)
        }
        .sheet(isPresented: $showCamera) {
            CameraView(selectedImage: $selectedImage, extractedText: $extractedText, isProcessing: $isProcessing, showAlert: $showAlert, alertMessage: $alertMessage, showFullScreenText: $showFullScreenText)
        }
        .fullScreenCover(isPresented: $showFullScreenText) {
            FullScreenTextView(extractedText: $extractedText, mainVM: mainVM, dismiss: dismiss)
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
}

// Bottom Sheet for Upload Options
struct UploadOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showDocumentPicker: Bool
    @Binding var showImagePicker: Bool
    @Binding var showCamera: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(.systemGray4))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            // Title
            Text("Choose Upload Method")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            // Options
            VStack(spacing: 16) {
                // Document Picker Option
                Button(action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showDocumentPicker = true
                    }
                }) {
                    HStack {
                        Image(systemName: "doc.text")
                            .font(.title2)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Choose Document")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("PDF, RTF, Text files")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Image Picker Option
                Button(action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showImagePicker = true
                    }
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.green)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Choose Photo")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("From your photo library")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Camera Option
                Button(action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showCamera = true
                    }
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.title2)
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Take Photo")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Use camera to capture text")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// Full Screen Text View
struct FullScreenTextView: View {
    @Binding var extractedText: String
    @ObservedObject var mainVM: MainViewModel
    let dismiss: DismissAction
    @Environment(\.dismiss) private var dismissFullScreen
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Extracted Text")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button("Use Text") {
                        mainVM.inputText = extractedText
                        dismissFullScreen()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                // Text Content
                ScrollView {
                    Text(extractedText)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color(.systemBackground))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismissFullScreen()
                    }
                }
            }
        }
    }
}

// Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var extractedText: String
    @Binding var isProcessing: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showFullScreenText: Bool
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [
            .plainText,
            .pdf,
            .rtf,
            .rtfd
        ]
        
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
            
            // Start accessing the security-scoped resource
            guard url.startAccessingSecurityScopedResource() else {
                parent.alertMessage = "Failed to access the selected file"
                parent.showAlert = true
                parent.isProcessing = false
                return
            }
            
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                do {
                    let text = try self.extractTextFromFile(at: url)
                    DispatchQueue.main.async {
                        self.parent.extractedText = text
                        self.parent.isProcessing = false
                        self.parent.showFullScreenText = true
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
            case "txt", "rtf", "rtfd":
                let rawText = try String(contentsOf: url, encoding: .utf8)
                return cleanAndFormatText(rawText)
            case "pdf":
                let rawText = try extractTextFromPDF(at: url)
                return cleanAndFormatText(rawText)
            case "doc", "docx":
                let rawText = try extractTextFromWordDocument(at: url)
                return cleanAndFormatText(rawText)
            default:
                // Try to read as text file for other extensions
                if let text = try? String(contentsOf: url, encoding: .utf8) {
                    return cleanAndFormatText(text)
                } else if let text = try? String(contentsOf: url, encoding: .ascii) {
                    return cleanAndFormatText(text)
                } else {
                    throw NSError(domain: "UnsupportedFileType", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unsupported file type"])
                }
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
            
            // Remove RTF formatting and backslashes - more comprehensive
            cleanedText = cleanedText.replacingOccurrences(of: "\\\\[a-zA-Z]+[0-9]*", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "\\\\'[0-9a-fA-F]{2}", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "\\\\[^\\\\]*\\\\", with: "", options: .regularExpression)
            
            // Remove standalone backslashes that are causing issues
            cleanedText = cleanedText.replacingOccurrences(of: "\\\\", with: "", options: .regularExpression)
            
            // Remove PDF-specific formatting
            cleanedText = cleanedText.replacingOccurrences(of: "BT\\s*[^E]*ET", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "Tf\\s*[0-9]+", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "Td\\s*[0-9.-]+\\s*[0-9.-]+", with: "", options: .regularExpression)
            
            // Remove any remaining formatting artifacts
            cleanedText = cleanedText.replacingOccurrences(of: "\\[\\s*\\]", with: "", options: .regularExpression)
            cleanedText = cleanedText.replacingOccurrences(of: "\\(\\s*\\)", with: "", options: .regularExpression)
            
            // Clean up multiple spaces and normalize
            cleanedText = cleanedText.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Preserve paragraph structure
            cleanedText = cleanedText.replacingOccurrences(of: "\\n\\s*\\n", with: "\n\n", options: .regularExpression)
            
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
            
            // Final cleanup of any remaining artifacts
            cleanedText = cleanedText.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            return cleanedText
        }
        
        private func extractTextFromPDF(at url: URL) throws -> String {
            guard let pdfDocument = CGPDFDocument(url as CFURL) else {
                throw NSError(domain: "PDFError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to open PDF"])
            }
            
            var extractedText = ""
            let pageCount = pdfDocument.numberOfPages
            
            for pageIndex in 1...pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { continue }
                
                // Try to extract text directly from PDF first (better quality)
                if let pageText = extractTextFromPDFPage(page) {
                    extractedText += pageText + "\n\n"
                } else {
                    // Fallback to image-based extraction
                    let pageRect = page.getBoxRect(.mediaBox)
                    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                    
                    let image = renderer.image { context in
                        context.cgContext.translateBy(x: 0, y: pageRect.size.height)
                        context.cgContext.scaleBy(x: 1, y: -1)
                        context.cgContext.drawPDFPage(page)
                    }
                    
                    if let text = extractTextFromImage(image) {
                        extractedText += text + "\n\n"
                    }
                }
            }
            
            let rawText = extractedText.isEmpty ? "No text could be extracted from the PDF" : extractedText
            return cleanAndFormatText(rawText)
        }
        
        private func extractTextFromPDFPage(_ page: CGPDFPage) -> String? {
            // This is a simplified approach - in a real app, you might want to use PDFKit
            // for better text extraction
            return nil
        }
        
        private func extractTextFromWordDocument(at url: URL) throws -> String {
            // For Word documents, we'll need to use a different approach
            // This is a simplified version - in a real app, you might want to use a library like TextEdit
            let data = try Data(contentsOf: url)
            
            // Try to extract text from the data
            if let text = String(data: data, encoding: .utf8) {
                return cleanAndFormatText(text)
            } else if let text = String(data: data, encoding: .ascii) {
                return cleanAndFormatText(text)
            } else {
                throw NSError(domain: "WordDocumentError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to extract text from Word document"])
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
            request.recognitionLanguages = ["en-US"]
            request.minimumTextHeight = 0.01
            
            do {
                try requestHandler.perform([request])
                
                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    return nil
                }
                
                // Sort observations by vertical position to maintain reading order
                let sortedObservations = observations.sorted { obs1, obs2 in
                    let y1 = obs1.boundingBox.minY
                    let y2 = obs2.boundingBox.minY
                    return y1 > y2 // Top to bottom
                }
                
                let recognizedStrings = sortedObservations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                let rawText = recognizedStrings.joined(separator: " ")
                return cleanAndFormatText(rawText)
            } catch {
                return nil
            }
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var extractedText: String
    @Binding var isProcessing: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showFullScreenText: Bool
    @Environment(\.dismiss) private var dismiss
    
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
            picker.dismiss(animated: true)
            
            guard let result = results.first else { return }
            
            parent.isProcessing = true
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self.parent.selectedImage = image
                        self.extractTextFromImage(image)
                    } else {
                        self.parent.alertMessage = "Failed to load image"
                        self.parent.showAlert = true
                        self.parent.isProcessing = false
                    }
                }
            }
        }
        
        private func extractTextFromImage(_ image: UIImage) {
            guard let cgImage = image.cgImage else {
                parent.alertMessage = "Failed to process image"
                parent.showAlert = true
                parent.isProcessing = false
                return
            }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { [weak self] request, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.parent.alertMessage = "Failed to extract text: \(error.localizedDescription)"
                        self?.parent.showAlert = true
                        self?.parent.isProcessing = false
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        self?.parent.alertMessage = "No text found in image"
                        self?.parent.showAlert = true
                        self?.parent.isProcessing = false
                        return
                    }
                    
                    let recognizedStrings = observations.compactMap { observation in
                        observation.topCandidates(1).first?.string
                    }
                    
                    let rawText = recognizedStrings.joined(separator: " ")
                    self?.parent.extractedText = self?.cleanAndFormatText(rawText) ?? rawText
                    self?.parent.isProcessing = false
                    self?.parent.showFullScreenText = true
                }
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.parent.alertMessage = "Failed to process image: \(error.localizedDescription)"
                    self.parent.showAlert = true
                    self.parent.isProcessing = false
                }
            }
        }
        
        private func cleanAndFormatText(_ rawText: String) -> String {
            var cleanedText = rawText
            
            // Remove HTML tags
            cleanedText = cleanedText.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            
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

// Camera View
struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var extractedText: String
    @Binding var isProcessing: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showFullScreenText: Bool
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                extractTextFromImage(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        private func extractTextFromImage(_ image: UIImage) {
            parent.isProcessing = true
            
            guard let cgImage = image.cgImage else {
                parent.alertMessage = "Failed to process image"
                parent.showAlert = true
                parent.isProcessing = false
                return
            }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { [weak self] request, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.parent.alertMessage = "Failed to extract text: \(error.localizedDescription)"
                        self?.parent.showAlert = true
                        self?.parent.isProcessing = false
                        return
                    }
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        self?.parent.alertMessage = "No text found in image"
                        self?.parent.showAlert = true
                        self?.parent.isProcessing = false
                        return
                    }
                    
                    let recognizedStrings = observations.compactMap { observation in
                        observation.topCandidates(1).first?.string
                    }
                    
                    let rawText = recognizedStrings.joined(separator: " ")
                    self?.parent.extractedText = self?.cleanAndFormatText(rawText) ?? rawText
                    self?.parent.isProcessing = false
                    self?.parent.showFullScreenText = true
                }
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.parent.alertMessage = "Failed to process image: \(error.localizedDescription)"
                    self.parent.showAlert = true
                    self.parent.isProcessing = false
                }
            }
        }
        
        private func cleanAndFormatText(_ rawText: String) -> String {
            var cleanedText = rawText
            
            // Remove HTML tags
            cleanedText = cleanedText.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            
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

#Preview {
    UploadFileView()
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
}



