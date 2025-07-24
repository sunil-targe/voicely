//
//  HighlightBannerAction.swift
//  DesignSystem
//
//  Created by Sunil Targe on 2025/6/22.
//

import SwiftUI

public struct HighlightBannerAction: View {
    public var body: some View {
        Button(action: action,
               label: {
            HStack(alignment: .center, spacing: 16) {
                if let icon {
                    icon.resizable()
                        .scaledToFit()
                        .foregroundColor(color)
                        .frame(width: 20, height: 20)
                }
                
                Text(text)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .multilineTextAlignment(.leading)
                if let secondaryIcon {
                    Spacer(minLength: 1)
                    secondaryIcon.resizable()
                        .scaledToFit()
                        .foregroundColor(color)
                        .frame(width: 20, height: 20)
                        .offset(x: 10)
                } else {
                    Spacer(minLength: 6)
                }
            }
        })
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
    }
    
    public init(
        icon: Image?,
        text: String,
        secondaryIcon: Image?,
        color: Color,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.text = text
        self.secondaryIcon = secondaryIcon
        self.color = color
        self.action = action
    }
    
    private let icon: Image?
    private let text: String
    private let secondaryIcon: Image?
    private let color: Color
    private let action: () -> Void
}

#Preview {
    VStack(spacing: 20) {
        HighlightBannerAction(icon: nil, text: "Enjoy 3 FREE cake credits to get started — your treat on us! 🎁", secondaryIcon: .init(systemName: "wand.and.stars"), color: .init(.green)) {
        }
        
        HighlightBannerAction(icon: .init(systemName: "crown.fill"), text: "2 free credit remaining. Go Pro for endless fun! ✨", secondaryIcon: .init(systemName: "chevron.forward"), color: .init(.green)) {
        }
        
        HighlightBannerAction(icon: .init(systemName: "crown.fill"), text: "⏰ Just 1 free credit left! Go Pro for endless fun! 🍥🚀", secondaryIcon: .init(systemName: "chevron.forward"), color: .init(.orange)) {
        }
        
        HighlightBannerAction(icon: .init(systemName: "crown.fill"), text: "No more free credits 😢 — unlock unlimited designs with Pro! 🍥🚀", secondaryIcon: .init(systemName: "chevron.forward"), color: .init(.red)) {
            
        }
        
        Spacer()
    }
}
