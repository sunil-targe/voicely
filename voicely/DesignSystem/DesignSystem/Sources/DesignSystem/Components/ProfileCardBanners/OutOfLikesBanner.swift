//
//  OutOfLikesBanner.swift
//
//
//  Created by Sunil Targe on 2024/7/25.
//

import SwiftUI

public struct OutOfLikesBanner: View {
    public var body: some View {
        Button(action: action,
               label: {
            HStack {
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
    }
    
    public init(
        title: String,
        ctaText: String,
        style: Style = .standard,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.ctaText = ctaText
        self.style = style
        self.action = action
    }
    
    private let title: String
    private let ctaText: String
    private let style: Style
    private let action: () -> Void
}

#Preview {
    OutOfLikesBanner(
        title: "Out of Likes for now",
        ctaText: "Get More →",
        style: .standard
    ) {}
}
