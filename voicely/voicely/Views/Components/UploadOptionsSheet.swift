import SwiftUI

struct UploadOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showDocumentPicker: Bool
    @Binding var showImagePicker: Bool
    
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
                // Documents Option
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
                            Text("Documents")
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
                
                // Photos Option
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
                            Text("Photos")
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
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    UploadOptionsSheet(showDocumentPicker: .constant(false), showImagePicker: .constant(false))
} 