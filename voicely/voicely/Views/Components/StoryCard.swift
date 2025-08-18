import SwiftUI

struct StoryCard: View {
    let story: Story
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                Image(story.thumbnailImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                // Story Title
                Text(story.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding([.horizontal, .bottom], 8)
            }
            Button(action: {
                favoritesManager.toggleFavorite(story.id)
            }) {
                Image(systemName: favoritesManager.isFavorite(story.id) ? "heart.fill" : "heart")
                    .foregroundColor(favoritesManager.isFavorite(story.id) ? .red : .white.opacity(0.8))
                    .padding(6)
            }
        }
        .frame(width: 120, height: 170)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    StoryCard(story: Story.allStories.first!)
        .padding()
        .background(Color(.systemBackground))
} 
