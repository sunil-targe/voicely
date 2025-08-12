import SwiftUI

struct SecretGardenDiscoveryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
//                    Text("The Secret Garden Discovery")
//                        .font(.system(size: 32, weight: .bold, design: .serif))
//                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
//                        .padding(.top, 12)

                    // Subtitle
                    Text("Where Magic Grows in Hidden Places")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.yellow)
                        .padding(.vertical, 10)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
Behind an old stone wall, hidden by ivy and forgotten by time, lay a secret garden. No one knew it was there until two curious children, Lily and Max, discovered a rusty key that seemed to glow with a mysterious light.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🌸 The Garden's Wonders:")
                                .font(.headline)
                                .foregroundColor(.yellow)

                            Group {
                                Text("• Flowers that sang when touched")
                                Text("• Trees that grew candy instead of fruit")
                                Text("• Butterflies that sparkled like diamonds")
                                Text("• A fountain that flowed with rainbow water")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
When Lily and Max unlocked the garden gate, they couldn't believe their eyes! The garden was alive with magic—flowers that sang sweet melodies, trees that grew candy instead of fruit, and butterflies that sparkled like tiny diamonds. A fountain in the center flowed with rainbow-colored water.

The children spent hours exploring every corner of the magical garden. They learned that the garden had been waiting for someone to discover its secrets and bring it back to life with their imagination and wonder.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"Sometimes the most magical places are hidden in plain sight," whispered the garden's caretaker, a wise old owl, "waiting for those with open hearts to discover them."
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
From that day on, Lily and Max became the guardians of the secret garden. They shared its magic with their friends, teaching them that wonder and imagination could make the ordinary world extraordinary. The garden grew more beautiful with each visit, spreading its magic to everyone who believed in its wonders.

The children learned that magic wasn't just in fairy tales—it was in the curiosity to explore, the courage to discover, and the joy of sharing beautiful secrets with others.
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
                    .fill(Color(red: 30/255, green: 35/255, blue: 30/255))
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
            )
            .padding(6)
        }
    }
}

#Preview {
    SecretGardenDiscoveryView()
} 
