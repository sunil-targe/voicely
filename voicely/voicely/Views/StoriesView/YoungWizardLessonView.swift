import SwiftUI

struct YoungWizardLessonView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
//                    Text("The Young Wizard's Lesson")
//                        .font(.system(size: 32, weight: .bold, design: .serif))
//                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
//                        .padding(.top, 12)

                    // Subtitle
                    Text("The Magic of Kindness")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.purple)
                        .padding(.vertical, 10)

                    // Story content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("""
In a faraway land, there was a young wizard named Felix who dreamed of becoming the greatest magician in the world. He practiced spells every day, hoping to discover the most powerful magic of all.
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Highlighted section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🪄 Felix's Magical Journey:")
                                .font(.headline)
                                .foregroundColor(.purple)

                            Group {
                                Text("• He learned spells for light and wind")
                                Text("• He could make flowers bloom with a word")
                                Text("• He wanted to find the greatest magic of all")
                                Text("• He searched for a spell to make everyone happy")
                            }
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        Text("""
One day, Felix met an old woman who was cold and hungry. He tried every spell he knew, but nothing seemed to help. Finally, he gave her his own cloak and shared his lunch with her. The woman's eyes sparkled, and she smiled warmly at Felix.

"Thank you, young wizard," she said. "You have discovered the greatest magic of all—kindness."
""")
                            .font(.system(size: 18, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.white)

                        // Quote section
                        VStack(alignment: .leading) {
                            Text("""
"The most powerful magic is the magic of kindness," Felix realized, "because it can change the world one heart at a time."
""")
                                .italic()
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.purple.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text("""
From that day on, Felix used his magic to help others, spreading kindness wherever he went. He learned that true greatness wasn't about power, but about making the world a better place for everyone.

The people of the land loved Felix, not just for his magic, but for his big heart. And Felix knew that he had found the greatest magic of all.
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
                    .fill(Color(red: 35/255, green: 30/255, blue: 40/255))
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
            )
            .padding(6)
        }
    }
}

#Preview {
    YoungWizardLessonView()
} 
