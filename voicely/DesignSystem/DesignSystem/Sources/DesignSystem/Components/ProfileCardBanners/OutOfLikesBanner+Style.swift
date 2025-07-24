//
//  OutOfLikesBanner+Style.swift
//  
//
//  Created by Sunil Targe on 2024/7/29.
//

import SwiftUI

extension OutOfLikesBanner {
    
    public struct Style {
        public let background: ReusableStyle.Color
        public let foreground: ReusableStyle.Color
        public let corners: UIRectCorner
        public let cornerRadius: CGFloat
        public let fontProvider: FontProvider

        
        public init(
            background: ReusableStyle.Color,
            foreground: ReusableStyle.Color,
            corners: UIRectCorner,
            cornerRadius: CGFloat,
            fontProvider: FontProvider
        ) {
            self.background = background
            self.foreground = foreground
            self.corners = corners
            self.cornerRadius = cornerRadius
            self.fontProvider = fontProvider
        }
    }
}

extension OutOfLikesBanner.Style {
    
    public static let standard: Self = .init(
        background: .hex("FFE6F0"),
        foreground: .hex("6B002D"),
        corners: [
            .topLeft,
            .topRight
        ],
        cornerRadius: 20,
        fontProvider: .system
    )
}

