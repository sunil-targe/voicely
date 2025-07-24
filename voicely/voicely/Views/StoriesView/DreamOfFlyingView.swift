import SwiftUI

struct DreamOfFlyingView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Story content
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("The Dream of Flying")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .padding(.top, 12)

                    // Subtitle
                    Text("Where Imagination Takes Flight")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.cyan)
                        .padding(.bottom, 8)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
Every night, little Emma would lie in her bed and look out the window at the stars. She would watch the clouds drift by and imagine what it would be like to float among them, to touch the moon, to dance with the stars.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("✨ Emma's Dreams:")
                                .font(.headline)
                                .foregroundColor(.cyan)

                            Group {
                                Text("• She dreamed of soaring through fluffy clouds")
                                Text("• She wanted to reach the highest mountain peaks")
                                Text("• She imagined flying with the birds at sunrise")
                                Text("• She wished to touch the rainbow after rain")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
One magical evening, as Emma was falling asleep, she felt something strange happening. Her bed began to float gently upward, and she realized she was actually flying! The stars twinkled around her like diamonds, and the clouds felt soft like cotton candy.

She soared through the night sky, past the moon, and danced among the constellations. The wind carried her higher and higher, and she felt completely free and happy.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"Sometimes the most amazing adventures happen in our dreams," Emma whispered as she floated among the stars, "and those dreams can make anything possible."
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.cyan.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
When Emma woke up the next morning, she felt different somehow. She knew that even though her flying adventure was a dream, the feeling of freedom and possibility was real. From that day on, she carried that sense of wonder with her everywhere she went.

She learned that imagination is like having wings—it can take you anywhere you want to go, even if it's just in your mind. And sometimes, those dreamy thoughts can inspire the most wonderful real adventures.
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
    DreamOfFlyingView()
} 
