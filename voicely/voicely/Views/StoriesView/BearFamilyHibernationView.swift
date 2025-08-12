//
//  BearFamilyHibernationView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/7/29.
//

import SwiftUI

struct BearFamilyHibernationView: View {
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // Title
//                Text("The Bear Family’s Hibernation")
//                    .font(.system(size: 32, weight: .bold, design: .serif))
//                    .foregroundColor(.orange)
//                    .padding(.top, 12)
                
                // Subtitle
                Text("Preparing for Winter Together")
                    .font(.system(size: 20, weight: .medium, design: .serif))
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)
                
                // Intro Paragraph
                Text("""
In a dense forest filled with tall pines, lived Papa Bear, Mama Bear, and Baby Bear. Their den was a warm cave, perfect for their winter hibernation. As autumn leaves fell, they began preparing for their long sleep, knowing winter was near. They needed food to last and a cozy den to keep them warm.
""")
                .font(.system(size: 18, design: .serif))
                .lineSpacing(6)
                .foregroundColor(.white)
                
                // Bullet List of Actions
                VStack(alignment: .leading, spacing: 8) {
                    Text("🧸 What each bear did:")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Group {
                        Text("• Papa Bear roamed the forest, collecting sweet berries and catching fish from the stream.")
                        Text("• Mama Bear gathered soft leaves and moss, lining the den to make it snug.")
                        Text("• Baby Bear, eager to help, scampered around, finding small nuts and seeds to store.")
                    }
                    .font(.system(size: 18, design: .serif))
                    .foregroundColor(.white)
                    .lineSpacing(5)
                }
                
                // Quote section
                VStack(alignment: .leading) {
                    Text("“Even when Papa Bear got a thorn in his paw or Mama Bear struggled with heavy branches, they helped each other, laughing and learning.”")
                        .italic()
                        .font(.system(size: 18, design: .serif))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Ending
                Text("""
As the first snowflakes fell, the bears finished their preparations. They checked their food piles—berries, fish, nuts, and seeds—and fluffed the moss in their den.

That night, they snuggled close, sharing one last story about a brave bear who saved his family. As they drifted off, the wind howled outside, but their den was warm and safe. The bears slept soundly, dreaming of spring, knowing their love and teamwork would carry them through winter.
""")
                .font(.system(size: 18, design: .serif))
                .lineSpacing(6)
                .foregroundColor(.white)
                .padding(.bottom, 12)
            }
            .padding()
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
    BearFamilyHibernationView()
}
