import SwiftUI

struct FavoritesListView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selectedStory: Story?
    
    private var favoriteStories: [Story] {
        Story.allStories.filter { favoritesManager.favoriteStoryIDs.contains($0.id) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if favoriteStories.isEmpty {
                Text("No favorites yet")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ], spacing: 10) {
                        ForEach(favoriteStories, id: \.id) { story in
                            StoryGridCard(story: story)
                                .onTapGesture {
                                    selectedStory = story
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Favorites")
        .background(Color(.systemBackground))
        .fullScreenCover(item: $selectedStory) { story in
            BookPageView(story: story)
        }
    }
}

#Preview {
    FavoritesListView()
        .environmentObject(FavoritesManager())
}


