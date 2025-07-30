import SwiftUI

struct ToysNighttimeAdventureView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("The Toys' Nighttime Adventure")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .padding(.top, 12)

                    // Subtitle
                    Text("When the Children Are Asleep")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.pink)
                        .padding(.bottom, 8)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
When the last child's eyes closed and the house grew quiet, the toys in the playroom began to stir. Teddy Bear stretched his fluffy arms, Doll opened her bright eyes, and the wooden blocks started to glow with a magical light.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🧸 The Toy Friends:")
                                .font(.headline)
                                .foregroundColor(.pink)

                            Group {
                                Text("• Teddy Bear - the brave leader")
                                Text("• Doll - the kind helper")
                                Text("• Wooden Blocks - the builders")
                                Text("• Toy Car - the speedy explorer")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
Together, the toys planned their nightly adventure. Teddy Bear suggested they build a castle, Doll wanted to have a tea party, and the wooden blocks were excited to create a magical bridge to the moon.

They worked together, each toy using their special talents. Teddy Bear carried the heavy blocks, Doll set the table with tiny cups, and the toy car raced around delivering messages to all the other toys in the house.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"The best adventures happen when friends work together," whispered Teddy Bear, "and the best friends are the ones who make each other smile."
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.pink.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
As the first light of dawn peeked through the window, the toys knew it was time to return to their places. They cleaned up their magical castle, put away the tiny tea cups, and settled back into their spots, ready to wait for the children to wake up.

The children never knew about the amazing adventures their toys had while they slept, but they always wondered why their toys seemed to smile a little brighter each morning.
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
                    .fill(Color(red: 40/255, green: 30/255, blue: 35/255))
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
            )
            .padding(6)
        }
    }
}

#Preview {
    ToysNighttimeAdventureView()
} 
