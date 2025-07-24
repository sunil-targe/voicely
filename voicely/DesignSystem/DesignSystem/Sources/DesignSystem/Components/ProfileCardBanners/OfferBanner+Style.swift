//
//  OfferBanner+Style.swift
//
//
//  Created by Sunil Targe on 2024/7/29.
//

import SwiftUI

extension OfferBanner {
    
    public struct Style {
        public let background: ReusableStyle.Color
        public let foreground: ReusableStyle.Color
        public let corners: UIRectCorner
        public let cornerRadius: CGFloat
        public let strokeColors: [Color]
        public let fontProvider: FontProvider
        
        public init(
            background: ReusableStyle.Color,
            foreground: ReusableStyle.Color,
            corners: UIRectCorner,
            cornerRadius: CGFloat,
            strokeColors: [Color],
            fontProvider: FontProvider
        ) {
            self.background = background
            self.foreground = foreground
            self.corners = corners
            self.cornerRadius = cornerRadius
            self.strokeColors = strokeColors
            self.fontProvider = fontProvider
        }
    }
}

extension OfferBanner.Style {
    
    public static let standard: Self = .init(
        background: .hex("422334"),
        foreground: .hex("FFFFFF"),
        corners: [
            .topLeft,
            .topRight
        ],
        cornerRadius: 20, 
        strokeColors: [
            .hex("FF006A"),
            .hex("FF82B6")
        ],
        fontProvider: .system
    )
}

