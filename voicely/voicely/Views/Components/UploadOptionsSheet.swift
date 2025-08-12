import SwiftUI

struct UploadOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showDocumentPicker: Bool
    @Binding var showImagePicker: Bool
    
    var body: some View {
        VStack(spacing: 0) {
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
                    HStack(alignment: .center) {
                        Image(systemName: "doc.fill").imageScale(.medium)
                            .foregroundColor(.blue)
                            .offset(y: -6)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Documents")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("PDF, RTF, txt files")
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
                        Image(systemName: "photo").imageScale(.medium)
                            .foregroundColor(.green)
                            .offset(y: -6)
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
