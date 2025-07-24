//
//  OfferBanner.swift
//
//
//  Created by Sunil Targe on 2024/7/25.
//

import SwiftUI

public struct OfferBanner: View {
    public var body: some View {
        Button(action: action,
               label: {
            HStack(spacing: 12) {
                if let icon {
                    icon.resizable()
                        .scaledToFit()
                        .applyReusableForeground(style.foreground)
                        .frame(width: 20, height: 20)
                }
                Text(title)
                    .font(style.fontProvider.font(size: 16, weight: .semibold))
                    .applyReusableForeground(style.foreground)
                Spacer()
                Text(ctaText)
                    .font(style.fontProvider.font(size: 14, weight: .regular))
                    .applyReusableForeground(style.foreground)
            }
        })
        .padding(.horizontal)
        .frame(height: 40)
        .applyReusableBackground(style.background)
        .cornerRadius(
            style.cornerRadius,
            corners: style.corners
        )
        .overlay(
            RoundedCorner(
                radius: style.cornerRadius,
                corners: style.corners
            )
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: style.strokeColors),
                    startPoint: .leading,
                    endPoint: .trailing),
                lineWidth: 1.5
            )
        )
    }
    
    public init(
        icon: Image?,
        title: String,
        ctaText: String,
        style: Style = .standard,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.ctaText = ctaText
        self.style = style
        self.action = action
    }
    
    private let icon: Image?
    private let title: String
    private let ctaText: String
    private let style: Style
    private let action: () -> Void
}

#Preview {
    VStack {
        OutOfLikesBanner(
            title: "Out of Likes for now",
            ctaText: "Get More →"
        ) {}
        
        OfferBanner(
            icon: Image(systemName: "crown.fill"),
            title: "Get 69% OFF",
            ctaText: "Get Discount →",
            style: .standard
        ) {}
    }
}
