import SwiftUI

struct StoryCard: View {
    let story: Story
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                // Story Image with 2:3 aspect ratio
                Image(story.thumbnailImageName)
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(.horizontal, 6)
                    .frame(width: 120)
                    .clipped()
                    .cornerRadius(8)
                Spacer()
            }
            VStack {
                // Story Title at bottom
                Text(story.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 4)
                    .offset(y: 4)
            }
            .padding(.vertical)
        }
        .frame(width: 120, height: 200)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    StoryCard(story: Story.allStories.first!)
        .padding()
        .background(Color(.systemBackground))
} 
