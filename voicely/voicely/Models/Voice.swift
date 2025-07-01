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
    
    static let `default` = Voice(id: UUID(), name: "Wise Woman", description: "Wise, mature, and gentle", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Wise_Woman")
    
    static let all: [Voice] = [
        Voice(id: UUID(), name: "Wise Woman", description: "Wise, mature, and gentle", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Wise_Woman"),
        Voice(id: UUID(), name: "Sweet Girl", description: "Sweet and gentle", color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)), voice_id: "Sweet_Girl_2"),
        Voice(id: UUID(), name: "Lovely Girl", description: "Lovely and sweet", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.53)), voice_id: "Lovely_Girl"),
        Voice(id: UUID(), name: "Calm Woman", description: "Calm and soothing", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)), voice_id: "Calm_Woman"),
        Voice(id: UUID(), name: "Friendly Person", description: "Friendly and approachable", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.53)), voice_id: "Friendly_Person"),
        Voice(id: UUID(), name: "Inspirational Girl", description: "Inspiring and energetic", color: ColorCodable(color: Color(red: 0.67, green: 0.91, blue: 0.67)), voice_id: "Inspirational_girl"),
        Voice(id: UUID(), name: "Deep Voice Man", description: "Deep and powerful", color: ColorCodable(color: Color(red: 0.47, green: 0.81, blue: 0.98)), voice_id: "Deep_Voice_Man"),
        Voice(id: UUID(), name: "Casual Guy", description: "Casual and relaxed", color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)), voice_id: "Casual_Guy"),
        Voice(id: UUID(), name: "Lively Girl", description: "Lively and cheerful", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.98)), voice_id: "Lively_Girl"),
        Voice(id: UUID(), name: "Patient Man", description: "Patient and understanding", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Patient_Man"),
        Voice(id: UUID(), name: "Young Knight", description: "Young and brave", color: ColorCodable(color: Color(red: 0.67, green: 0.98, blue: 0.53)), voice_id: "Young_Knight"),
        Voice(id: UUID(), name: "Determined Man", description: "Determined and strong", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)), voice_id: "Determined_Man"),
        Voice(id: UUID(), name: "Decent Boy", description: "Decent and polite", color: ColorCodable(color: Color(red: 0.47, green: 0.81, blue: 0.98)), voice_id: "Decent_Boy"),
        Voice(id: UUID(), name: "Imposing Manner", description: "Imposing and authoritative", color: ColorCodable(color: Color(red: 0.67, green: 0.91, blue: 0.67)), voice_id: "Imposing_Manner"),
        Voice(id: UUID(), name: "Elegant Man", description: "Elegant and refined", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.98)), voice_id: "Elegant_Man"),
        Voice(id: UUID(), name: "Abbess", description: "Spiritual and wise", color: ColorCodable(color: Color(red: 0.85, green: 0.80, blue: 0.92)), voice_id: "Abbess"),
        Voice(id: UUID(), name: "Exuberant Girl", description: "Exuberant and lively", color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.80)), voice_id: "Exuberant_Girl")
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
