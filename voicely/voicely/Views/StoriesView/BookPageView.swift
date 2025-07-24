//
//  BookPageView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/7/28.
//

import SwiftUI

struct BookPageView: View {
    @Environment(\.dismiss) private var dismiss
    let story: Story

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    playHapticFeedback()
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.medium)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.4))
                        .padding([.bottom, .trailing], 6)
                }
                .padding(.horizontal)
            }
            
            switch story.storyViewName {
            case "BraveLittleRabbitView":
                BraveLittleRabbitView()
            case "BearFamilyHibernationView":
                BearFamilyHibernationView()
            case "DragonCouldntBreatheFireView":
                DragonCouldntBreatheFireView()
            case "DreamOfFlyingView":
                DreamOfFlyingView()
            case "ForestFriendsStormView":
                ForestFriendsStormView()
            case "LostKittenJourneyView":
                LostKittenJourneyView()
            case "MermaidOceanLessonView":
                MermaidOceanLessonView()
            case "SecretGardenDiscoveryView":
                SecretGardenDiscoveryView()
            case "ToysNighttimeAdventureView":
                ToysNighttimeAdventureView()
            case "YoungWizardLessonView":
                YoungWizardLessonView()
            default:
                Text("Story not found")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    BookPageView(story: Story.allStories[0])
}
