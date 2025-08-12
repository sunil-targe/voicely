import SwiftUI

struct LostKittenJourneyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Story content
                VStack(alignment: .leading, spacing: 24) {
                    // Title
//                    Text("The Lost Kitten's Journey Home")
//                        .font(.system(size: 32, weight: .bold, design: .serif))
//                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
//                        .padding(.top, 12)
                    
                    // Subtitle
                    Text("A Tale of Kindness and Home")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.pink)
                        .padding(.vertical, 10)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
A tiny gray kitten named Whiskers lived in a cozy house with a loving family. One day, while chasing a butterfly, Whiskers wandered too far and got lost in the big city. The tall buildings and loud noises were scary, and Whiskers didn't know how to find her way back home.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🐱 Whiskers' Adventure:")
                                .font(.headline)
                                .foregroundColor(.pink)

                            Group {
                                Text("• She wandered through busy streets")
                                Text("• She met a kind old lady who gave her milk")
                                Text("• A friendly dog helped her cross the road")
                                Text("• A little girl shared her sandwich")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
As Whiskers walked through the city, she met many kind strangers who helped her along the way. The old lady gave her warm milk, the friendly dog protected her from traffic, and the little girl shared her lunch. Each person showed her that the world was full of kindness.

Finally, after many days of wandering, Whiskers heard a familiar voice calling her name. It was her family, who had been searching for her everywhere! They were so happy to see her, and Whiskers was overjoyed to be back in her warm, safe home.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"Sometimes getting lost helps us find the kindness in others," Whiskers purred as she snuggled with her family, grateful for all the helpful friends she had met on her journey.
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.pink.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
From that day on, Whiskers never wandered too far from home, but she always remembered the kindness of strangers. She learned that even in the biggest, scariest places, there are always people ready to help and show love to those in need.

Her family was so grateful to have her back, and they promised to always keep her safe. Whiskers knew that home was the best place to be, but she also knew that the world was full of wonderful people who care about others.
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
    LostKittenJourneyView()
} 
