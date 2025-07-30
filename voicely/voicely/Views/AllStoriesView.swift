import SwiftUI
import DesignSystem

struct AllStoriesView: View {
    let stories: [Story]
    @State private var selectedStory: Story?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        playHapticFeedback()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text("All Stories")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Placeholder for balance
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Stories Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 20) {
                        ForEach(stories) { story in
                            StoryGridCard(story: story)
                                .onTapGesture {
                                    playHapticFeedback()
                                    selectedStory = story
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemBackground))
            .fullScreenCover(item: $selectedStory) { story in
                BookPageView(story: story)
            }
        }
        .navigationBarHidden(true)
    }
}

struct StoryGridCard: View {
    let story: Story
    
    var body: some View {
        VStack(spacing: 12) {
            // Story Image with 2:3 aspect ratio
            Image(story.thumbnailImageName)
                .resizable()
                .aspectRatio(2/3, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)
            
            // Story Title
            Text(story.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AllStoriesView(stories: Story.allStories)
} 
