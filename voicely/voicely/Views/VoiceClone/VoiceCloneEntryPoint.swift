import SwiftUI

struct VoiceCloneEntryPoint: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Clone icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.6, green: 0.8, blue: 1.0).opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "waveform.badge.plus")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.6, green: 0.8, blue: 1.0))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Clone Your Voice")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text("Record a short sample to create your personalized voice")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray2))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray3))
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if DEBUG
#Preview {
    VoiceCloneEntryPoint(onTap: {})
        .background(Color.black)
        .padding()
}
#endif
