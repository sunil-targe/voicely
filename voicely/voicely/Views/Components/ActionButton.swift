import SwiftUI

struct ActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .foregroundColor(.white.opacity(0.7))
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ActionButton(icon: "textformat", title: "Write text")
        .padding()
        .background(Color(.systemBackground))
} 
