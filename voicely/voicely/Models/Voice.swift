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
    var language: String = "None"
    var channel: String = "mono"
    
    static let `default` = Voice(
        id: UUID(),
        name: "Friendly Person",
        description: "Friendly and approachable",
        color: ColorCodable(color: Color(red: 0.98, green: 0.67, blue: 0.53)),
        voice_id: "Friendly_Person",
        emotion: "auto",
        language: "None",
        channel: "mono"
    )
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
