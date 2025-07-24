import SwiftUI
import DesignSystem

struct WriteTextView: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "textformat")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Write Your Story")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Create your own story or text content")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                // Content
                VStack(spacing: 20) {
                    Text("This feature allows you to write your own text content that can be converted to speech using your selected voice.")
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        // Navigate to MainView for text writing
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            // This will be handled by the NavigationLink in ContentView
                        }
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Start Writing")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
            .navigationTitle("Write Text")
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
    WriteTextView()
        .environmentObject(PurchaseViewModel.shared)
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
} 