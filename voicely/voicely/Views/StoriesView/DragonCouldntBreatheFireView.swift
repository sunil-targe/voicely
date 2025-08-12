import SwiftUI

struct DragonCouldntBreatheFireView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Story content
                VStack(alignment: .leading, spacing: 24) {
                    // Title
//                    Text("The Dragon Who Couldn't Breathe Fire")
//                        .font(.system(size: 32, weight: .bold, design: .serif))
//                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
//                        .padding(.top, 12)

                    // Subtitle
                    Text("A Tale of Hidden Talents")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.orange)
                        .padding(.vertical, 10)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
High up in the misty mountains, lived a young dragon named Spark. Unlike other dragons who could breathe magnificent flames, Spark could only produce tiny puffs of smoke. The other dragons would laugh and say, "What kind of dragon are you if you can't breathe fire?"
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🔥 Spark's Struggles:")
                                .font(.headline)
                                .foregroundColor(.orange)

                            Group {
                                Text("• He tried to breathe fire but only coughed smoke")
                                Text("• Other dragons made fun of his small puffs")
                                Text("• He felt like he wasn't a real dragon")
                                Text("• He wanted to be like the others so badly")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
One day, a terrible storm hit the mountain. The wind was so strong that it blew out all the fires in the dragon caves. The dragons were cold and miserable, and they couldn't cook their food or keep warm.

Spark watched as the other dragons tried to relight their fires, but the wind kept blowing them out. Then he had an idea! His tiny puffs of smoke might be small, but they were gentle and steady.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"Maybe my small puffs can help in a different way," Spark thought as he carefully blew his gentle smoke onto the embers, slowly bringing the fires back to life.
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
The other dragons were amazed! Spark's gentle puffs were perfect for carefully tending fires without burning them out. Soon, all the dragon caves were warm and cozy again, and the dragons realized that Spark had a special talent all along.

From that day on, Spark became known as the dragon who could tend fires better than anyone else. He learned that being different doesn't mean being less—it means having unique gifts that others might need.
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
    DragonCouldntBreatheFireView()
} 
