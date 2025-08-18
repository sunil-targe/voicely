import SwiftUI
import DesignSystem

struct AllStoriesView: View {
    let stories: [Story]
    @State private var selectedStory: Story?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
            VStack(spacing: 0) {
                // Stories Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ], spacing: 10) {
                        ForEach(stories) { story in
                            StoryGridCard(story: story)
                                .environmentObject(favoritesManager)
                                .onTapGesture {
                                    playHapticFeedback()
                                    selectedStory = story
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("All Stories 📖")
            .background(Color(.systemBackground))
            .fullScreenCover(item: $selectedStory) { story in
                BookPageView(story: story)
            }
    }
}

struct StoryGridCard: View {
    let story: Story
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                Spacer(minLength: 6)
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
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    AllStoriesView(stories: Story.allStories)
} 
