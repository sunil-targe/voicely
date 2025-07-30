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
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ], spacing: 10) {
                        ForEach(stories) { story in
                            StoryGridCard(story: story)
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
        VStack(spacing: 0) {
            // Story Image with 2:3 aspect ratio
            Image(story.thumbnailImageName)
                .resizable()
                .aspectRatio(2/3, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)
            
            // Story Title
            Text(story.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .padding([.horizontal, .bottom], 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AllStoriesView(stories: Story.allStories)
} 
