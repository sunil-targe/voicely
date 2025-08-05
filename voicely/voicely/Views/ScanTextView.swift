import SwiftUI
import DesignSystem
import Vision
import PhotosUI

struct ScanTextView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCamera = false
    @State private var extractedText = ""
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showExtractedTextView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Scan Text")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Capture text from images using your camera")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                // Content
                VStack(spacing: 20) {
                    Text("Point your camera at any text document, book, or image containing text. The app will extract and convert the text to speech.")
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Start Scanning")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
            .navigationTitle("Scan Text")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(extractedText: $extractedText, isProcessing: $isProcessing, showAlert: $showAlert, alertMessage: $alertMessage, showExtractedTextView: $showExtractedTextView)
            }
            .sheet(isPresented: $showExtractedTextView) {
                ExtractedTextView(extractedText: $extractedText, mainVM: mainVM)
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}



#Preview {
    ScanTextView()
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
} 