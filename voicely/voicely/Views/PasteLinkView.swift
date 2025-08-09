import SwiftUI
import DesignSystem
import UIKit

struct PasteLinkView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var linkText = ""
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var extractedText = ""
    @State private var showExtractedTextView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Content
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Web Link")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        TextField("https://example.com", text: $linkText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.URL)
                    }
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            if let clipboardString = UIPasteboard.general.string {
                                linkText = clipboardString
                            }
                        }) {
                            HStack {
                                Image(systemName: "doc.on.clipboard")
                                Text("Paste")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            linkText = ""
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        processLink()
                    }) {
                        HStack {
                            if isProcessing {
                                ProgressView().tint(.white)
                            } else {
                                Image(systemName: "arrow.right.circle")
                            }
                            Text(isProcessing ? "Extracting..." : "Extract Content")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(linkText.isEmpty || isProcessing ? Color.gray : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(linkText.isEmpty || isProcessing)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
            .navigationTitle("Paste Link")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if linkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isProcessing {
                            dismiss()
                        } else {
                            processLink()
                        }
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .sheet(isPresented: $showExtractedTextView) {
                ExtractedTextView(extractedText: $extractedText, mainVM: mainVM)
            }
        }
    }
    
    private func processLink() {
        guard !linkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isProcessing = true
        
        // Normalize and validate URL
        let normalized = normalizeURLString(linkText)
        guard let url = URL(string: normalized) else {
            presentError("Please enter a valid web link")
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        // Use a common desktop user agent to receive full HTML
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                presentError("Failed to load page: \(error.localizedDescription)")
                return
            }
            guard let data = data, !data.isEmpty else {
                presentError("The page returned no content")
                return
            }
            
            // Try HTML -> plain text with NSAttributedString first
            var plainText: String?
            if let attributed = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            ) {
                plainText = attributed.string
            } else if let htmlString = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1) {
                plainText = stripHTMLTags(from: htmlString)
            }
            
            guard var text = plainText?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
                presentError("Could not extract readable text from the page")
                return
            }
            
            text = cleanAndFormatText(text)
            
            DispatchQueue.main.async {
                self.extractedText = text
                self.isProcessing = false
                self.showExtractedTextView = true
            }
        }.resume()
    }
    
    private func presentError(_ message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.showAlert = true
            self.isProcessing = false
        }
    }
    
    private func normalizeURLString(_ input: String) -> String {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return trimmed }
        if trimmed.lowercased().hasPrefix("http://") || trimmed.lowercased().hasPrefix("https://") {
            return trimmed
        }
        // If it looks like a domain, prefix https://
        if trimmed.contains(".") && !trimmed.contains(" ") {
            return "https://\(trimmed)"
        }
        return trimmed
    }
    
    private func stripHTMLTags(from html: String) -> String {
        var working = html
        // Remove script and style blocks
        working = working.replacingOccurrences(of: "(?is)<script[\\s\\S]*?</script>", with: "", options: .regularExpression)
        working = working.replacingOccurrences(of: "(?is)<style[\\s\\S]*?</style>", with: "", options: .regularExpression)
        // Remove comments
        working = working.replacingOccurrences(of: "(?is)<!--.*?-->", with: "", options: .regularExpression)
        // Replace <br> and </p> with newlines
        working = working.replacingOccurrences(of: "(?i)<br\\s*/?>", with: "\n", options: .regularExpression)
        working = working.replacingOccurrences(of: "(?i)</p>", with: "\n\n", options: .regularExpression)
        // Strip remaining tags
        working = working.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        return working
    }
    
    private func cleanAndFormatText(_ text: String) -> String {
        var cleaned = text
        // Remove excessive backslashes and escape remnants
        cleaned = cleaned.replacingOccurrences(of: "\\\\+", with: "", options: .regularExpression)
        // Normalize whitespace
        cleaned = cleaned.replacingOccurrences(of: "[\t\r]", with: " ", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "\n{3,}", with: "\n\n", options: .regularExpression)
        cleaned = cleaned.replacingOccurrences(of: "[ ]{2,}", with: " ", options: .regularExpression)
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        // Ensure sentences are capitalized reasonably
        cleaned = capitalizeSentences(in: cleaned)
        return cleaned
    }
    
    private func capitalizeSentences(in text: String) -> String {
        let delimiters: CharacterSet = CharacterSet(charactersIn: ".!?\n")
        var result = ""
        var startIndex = text.startIndex
        
        while startIndex < text.endIndex {
            // Find next delimiter range
            if let range = text.rangeOfCharacter(from: delimiters, range: startIndex..<text.endIndex) {
                let sentence = String(text[startIndex..<range.upperBound])
                result += sentence.capitalizedFirstLetter()
                startIndex = range.upperBound
            } else {
                let tail = String(text[startIndex..<text.endIndex])
                result += tail.capitalizedFirstLetter()
                break
            }
        }
        return result
    }
}

private extension String {
    func capitalizedFirstLetter() -> String {
        guard let first = first else { return self }
        return String(first).uppercased() + dropFirst()
    }
}

#Preview {
    PasteLinkView()
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
} 
