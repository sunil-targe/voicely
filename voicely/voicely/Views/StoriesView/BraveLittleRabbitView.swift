import SwiftUI

struct BraveLittleRabbitView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Story content
                VStack(alignment: .leading, spacing: 24) {
                    // Title
//                    Text("The Brave Little Rabbit")
//                        .font(.system(size: 36, weight: .bold, design: .serif))
//                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
//                        .padding(.top, 12)

                    // Subtitle
                    Text("Finding Courage in the Forest")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.yellow)
                        .padding(.vertical, 10)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
Once upon a time, in a lush green forest, lived a little rabbit named Thumper. Unlike other rabbits who were quick and confident, Thumper was small and often afraid. He would hide behind bushes when he heard loud noises and trembled at the sight of shadows.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🐰 Thumper's Challenges:")
                                .font(.headline)
                                .foregroundColor(.yellow)

                            Group {
                                Text("• He was afraid of the dark forest paths")
                                Text("• Loud sounds made him jump and hide")
                                Text("• Other animals seemed so much braver")
                                Text("• He wanted to explore but was too scared")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
One day, Thumper heard a tiny voice crying for help. It was a baby bird that had fallen from its nest. The other animals were too busy to notice, but Thumper could see the little bird clearly.

His heart was pounding, but something inside him told him he had to help. Taking a deep breath, Thumper hopped toward the baby bird, trying to ignore his trembling legs.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"Even though I'm scared, I can still be brave," Thumper whispered to himself as he carefully picked up the baby bird and carried it to safety.
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
From that day on, Thumper learned that being brave doesn't mean never being afraid. It means doing what's right even when you're scared. The other animals began to see Thumper differently, and he started to see himself differently too.

He still felt afraid sometimes, but now he knew that courage was a choice he could make every day. The little rabbit who was once so timid became known as the brave little rabbit who helped others find their courage too.
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
    BraveLittleRabbitView()
} 
