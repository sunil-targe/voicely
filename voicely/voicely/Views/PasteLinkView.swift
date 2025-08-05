import SwiftUI
import DesignSystem

struct PasteLinkView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var linkText = ""
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "globe")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Paste a Link")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Paste a web link to extract content")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                // Content
                VStack(spacing: 20) {
                    Text("Paste a web link below and the app will extract text content from the webpage for text-to-speech conversion.")
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Web Link")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        TextField("https://example.com", text: $linkText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
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
                                Text("Paste from Clipboard")
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
                            Image(systemName: "arrow.right.circle")
                            Text("Extract Content")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(linkText.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(linkText.isEmpty)
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
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func processLink() {
        guard !linkText.isEmpty else { return }
        
        isProcessing = true
        
        // Validate URL format
        guard let url = URL(string: linkText), UIApplication.shared.canOpenURL(url) else {
            alertMessage = "Please enter a valid web link"
            showAlert = true
            isProcessing = false
            return
        }
        
        // For now, we'll show a placeholder message
        // In a real implementation, you would fetch the webpage content
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alertMessage = "Link processing feature is coming soon! This will extract text content from web pages."
            showAlert = true
            isProcessing = false
        }
    }
}

#Preview {
    PasteLinkView()
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
} 