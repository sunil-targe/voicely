import SwiftUI

struct ForestFriendsStormView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Story content
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("The Forest Friends and the Storm")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .padding(.top, 12)
                    
                    // Subtitle
                    Text("When Friends Work Together")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.green)
                        .padding(.bottom, 8)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
In a peaceful forest, lived a wise old owl, a busy squirrel, a gentle deer, and a playful rabbit. They were the best of friends and helped each other every day. The owl would watch for danger, the squirrel would gather food, the deer would clear paths, and the rabbit would make everyone laugh.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🌳 The Forest Friends:")
                                .font(.headline)
                                .foregroundColor(.green)

                            Group {
                                Text("• Wise Owl - Watched and warned of danger")
                                Text("• Busy Squirrel - Gathered and stored food")
                                Text("• Gentle Deer - Cleared paths and helped others")
                                Text("• Playful Rabbit - Brought joy and laughter")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
One day, dark clouds gathered overhead, and a terrible storm began to rage. The wind howled through the trees, and rain poured down in sheets. The forest friends were scared, but they knew they had to work together to stay safe.

The owl found a sturdy hollow tree for shelter, the squirrel gathered extra food for everyone, the deer helped guide the others to safety, and the rabbit kept everyone's spirits up with funny stories.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"Together we are stronger than any storm," the wise owl said as they huddled safely in the hollow tree, sharing warmth and friendship.
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
When the storm finally passed, the forest was a bit messy, but all the friends were safe and sound. They worked together to clean up the forest, helping each other rebuild their homes and restore the beauty of their woodland home.

From that day on, they knew that no matter what challenges came their way, they could face them together. Their friendship had made them stronger than any storm, and their forest was more beautiful than ever.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .background(
                RoundedRectangle(cornerRadius: 52)
                    .fill(Color(red: 30/255, green: 30/255, blue: 35/255)) // dark card color
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
            )
            .padding(6)
        }
    }
}

#Preview {
    ForestFriendsStormView()
} 
