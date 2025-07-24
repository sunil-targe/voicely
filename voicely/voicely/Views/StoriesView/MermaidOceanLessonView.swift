import SwiftUI

struct MermaidOceanLessonView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Story content
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("The Mermaid's Ocean Lesson")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .padding(.top, 12)

                    // Subtitle
                    Text("Protecting Our Beautiful Seas")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.cyan)
                        .padding(.bottom, 8)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
Deep beneath the waves, in a beautiful coral reef, lived a young mermaid named Coral. She loved exploring the ocean and learning about all the amazing sea creatures. But one day, she noticed something troubling—the ocean wasn't as clean and healthy as it used to be.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🌊 Coral's Discoveries:")
                                .font(.headline)
                                .foregroundColor(.cyan)

                            Group {
                                Text("• She found plastic floating in the water")
                                Text("• Some fish seemed sad and unhealthy")
                                Text("• The coral reef wasn't as colorful")
                                Text("• She wanted to help protect her home")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
Coral decided to learn everything she could about protecting the ocean. She talked to wise old sea turtles, learned from the dolphins about clean water, and studied how the coral reef worked. She discovered that even small actions could make a big difference.

She started by cleaning up small pieces of trash she found, teaching other sea creatures to be careful with their ocean home, and spreading the word about how important it was to keep the seas clean and healthy.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"Every little bit helps," Coral told her friends, "and when we all work together, we can make the ocean beautiful again for everyone."
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.cyan.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
Soon, other sea creatures joined Coral's mission. The fish helped clean up tiny pieces of debris, the sea turtles taught others about ocean conservation, and even the dolphins helped spread the message far and wide.

The coral reef began to glow with health again, the fish swam happily in clean water, and the ocean became a more beautiful place for all its inhabitants. Coral learned that being a guardian of the ocean was one of the most important jobs anyone could have.
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
    MermaidOceanLessonView()
} 
