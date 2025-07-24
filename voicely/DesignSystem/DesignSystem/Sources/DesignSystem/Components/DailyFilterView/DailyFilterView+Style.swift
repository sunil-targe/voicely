//
//  File.swift
//  
//
//  Created by Sunil Targe on 2025/6/22.
//

import SwiftUI

extension DailyFilterView {
    
    public struct Style {
        public let background: ReusableStyle.Color
        public let border: ReusableStyle.Border
        public let foreground: ReusableStyle.Color
        public let badgeForeground: ReusableStyle.Color
        public let badgeBackground: ReusableStyle.Color
        public let font: ReusableStyle.Font
        
        public init(
            background: ReusableStyle.Color,
            border: ReusableStyle.Border,
            foreground: ReusableStyle.Color,
            badgeForeground: ReusableStyle.Color,
            badgeBackground: ReusableStyle.Color,
            font: ReusableStyle.Font
        ) {
            self.background = background
            self.border = border
            self.foreground = foreground
            self.badgeForeground = badgeForeground
            self.badgeBackground = badgeBackground
            self.font = font
        }
    }
}

extension DailyFilterView.Style {
    
    public static let normal: Self = .init(
        background: .hex("#FFFFFF0D"),
        border: .init(radius: 80, width: 1, color: .hex("#FFFFFF40")),
        foreground: .hex("#FFFFFF80"),
        badgeForeground: .hex("#000000"),
        badgeBackground: .hex("#FFFFFF"),
        font: .init(size: 15, weight: .regular)
    )
    
    public static let selected: Self = .init(
        background: .horizontal("#A734BD", "#FF006A"),
        border: .cornerRadius(80),
        foreground: .hex("#FFFFFF"),
        badgeForeground: .horizontal("#A734BD", "#FF006A"),
        badgeBackground: .hex("#FFFFFF"),
        font: .init(size: 15, weight: .bold)
    )
}
