import SwiftUI

struct ExtractedTextView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var extractedText: String
    @ObservedObject var mainVM: MainViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        mainVM.inputText = extractedText
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Use Text")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        extractedText = ""
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
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
                .padding(.top, 20)
                
                // Extracted Text Display
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Extracted Text")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(extractedText.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    
                    ScrollView {
                        Text(extractedText)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationTitle("Extracted Text")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ExtractedTextView(extractedText: .constant("Sample extracted text for preview"), mainVM: MainViewModel(selectedVoice: Voice.default))
} 
