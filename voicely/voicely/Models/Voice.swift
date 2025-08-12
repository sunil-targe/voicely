//
//  Voice.swift
//  voicely
//
//  Created by Sunil Targe on 2025/6/25.
//

import Foundation
import SwiftUI

struct Voice: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
    let description: String
    let color: ColorCodable
    let voice_id: String
    var emotion: String = "auto"
    var language: String = "Automatic"
    var channel: String = "mono"
    let preferredListenTime: String
    
    static let `default` = Voice(id: UUID(), name: "Grandma Willow", description: "Wise, mature, and gentle", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Wise_Woman", preferredListenTime: "bedtime")
    
    static let all: [Voice] = [
        Voice(
            id: UUID(),
            name: "Grandma Willow",
            description: "Wise, mature, and gentle",
            color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)),
            voice_id: "Wise_Woman",
            preferredListenTime: "bedtime"
        ),
        Voice(
            id: UUID(),
            name: "Honey Bear",
            description: "Sweet and gentle",
            color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)),
            voice_id: "Sweet_Girl_2",
            preferredListenTime: "bedtime"
        ),
        Voice(
            id: UUID(),
            name: "Sunny Butterfly",
            description: "Lovely and sweet",
            color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.53)),
            voice_id: "Lovely_Girl",
            preferredListenTime: "afternoon"
        ),
        Voice(
            id: UUID(),
            name: "Calm Woman",
            description: "Calm and soothing",
            color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)),
            voice_id: "Calm_Woman",
            preferredListenTime: "bedtime"
        ),
        Voice(
            id: UUID(),
            name: "Rainbow Friend",
            description: "Friendly and approachable",
            color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.53)),
            voice_id: "Friendly_Person",
            preferredListenTime: "morning"
        ),
        Voice(
            id: UUID(),
            name: "Sparkle Star",
            description: "Inspiring and energetic",
            color: ColorCodable(color: Color(red: 0.67, green: 0.91, blue: 0.67)),
            voice_id: "Inspirational_girl",
            preferredListenTime: "morning"
        ),
        Voice(
            id: UUID(),
            name: "Thunder Bear",
            description: "Deep and powerful",
            color: ColorCodable(color: Color(red: 0.47, green: 0.81, blue: 0.98)),
            voice_id: "Deep_Voice_Man",
            preferredListenTime: "evening"
        ),
        Voice(
            id: UUID(),
            name: "Cozy Cloud",
            description: "Casual and relaxed",
            color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)),
            voice_id: "Casual_Guy",
            preferredListenTime: "afternoon"
        ),
        Voice(
            id: UUID(),
            name: "Bubbles the Bunny",
            description: "Lively and cheerful",
            color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.98)),
            voice_id: "Lively_Girl",
            preferredListenTime: "morning"
        ),
        Voice(
            id: UUID(),
            name: "Gentle Giant",
            description: "Patient and understanding",
            color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)),
            voice_id: "Patient_Man",
            preferredListenTime: "bedtime"
        ),
        Voice(
            id: UUID(),
            name: "Brave Knight",
            description: "Young and brave",
            color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)),
            voice_id: "Young_Knight",
            preferredListenTime: "afternoon"
        ),
        Voice(
            id: UUID(),
            name: "Mighty Oak",
            description: "Determined and strong",
            color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)),
            voice_id: "Determined_Man",
            preferredListenTime: "morning"
        ),
        Voice(
            id: UUID(),
            name: "Polite Penguin",
            description: "Decent and polite",
            color: ColorCodable(color: Color(red: 0.47, green: 0.81, blue: 0.98)),
            voice_id: "Decent_Boy",
            preferredListenTime: "afternoon"
        ),
        Voice(
            id: UUID(),
            name: "Wise Owl",
            description: "Imposing and authoritative",
            color: ColorCodable(
                color: Color(
                    red: 0.67,
                    green: 0.91,
                    blue: 0.67
                )
            ),
            voice_id: "Imposing_Manner",
            preferredListenTime: "evening"
        ),
        Voice(
            id: UUID(),
            name: "Royal Unicorn",
            description: "Elegant and refined",
            color: ColorCodable(
                color: Color(
                    red: 0.85,
                    green: 0.80,
                    blue: 0.98
                )
            ),
            voice_id: "Elegant_Man",
            preferredListenTime: "evening"
        ),
        Voice(
            id: UUID(),
            name: "Sacred Tree",
            description: "Spiritual and wise",
            color: ColorCodable(
                color: Color(
                    red: 0.85,
                    green: 0.80,
                    blue: 0.92
                )
            ),
            voice_id: "Abbess",
            preferredListenTime: "bedtime"
        ),
        Voice(
            id: UUID(),
            name: "Joyful Jellyfish",
            description: "Exuberant and lively",
            color: ColorCodable(
                color: Color(
                    red: 0.98,
                    green: 0.67,
                    blue: 0.80
                )
            ),
            voice_id: "Exuberant_Girl",
            preferredListenTime: "morning"
        )
    ]
}

// Helper to encode/decode SwiftUI Color
struct ColorCodable: Codable, Equatable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
    }
}
