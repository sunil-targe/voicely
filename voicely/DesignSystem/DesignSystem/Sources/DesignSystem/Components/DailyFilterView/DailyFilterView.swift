//
//  DailyFilterView.swift
//  
//
//  Created by Sunil Targe on 2025/6/22.
//

import SwiftUI

public struct DailyFilterView: View {
    
    public var body: some View {
        ZStack {
            HStack(spacing: 4) {
                Text(name)
                
                if let icon {
                    icon.resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .applyReusableForeground(style.foreground)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .frame(height: 36)
            .applyReusableFont(style.font, provider: fontProvider)
            .applyReusableForeground(style.foreground)
            .applyReusableBackground(style.background)
            .applyReusableBorder(style.border)
            .condition(!badge.isEmpty) {
                $0.overlay(
                    Text(badge)
                        .font(fontProvider.font(size: 12))
                        .frame(minWidth: 12)
                        .padding(.horizontal, 3)
                        .applyReusableForeground(style.badgeForeground)
                        .applyReusableBackground(style.badgeBackground)
                        .clipShape(.capsule(style: .circular))
                        .padding(.top, -5)
                        .padding(.leading, 3),
                    alignment: .topLeading
                )
            }
        }
    }
    
    public init(
        name: String,
        badge: String,
        icon: Image?,
        style: Style,
        fontProvider: FontProvider
    ) {
        self.name = name
        self.badge = badge
        self.icon = icon
        self.style = style
        self.fontProvider = fontProvider
    }
    
    // MARK: - Private
    
    private let name: String
    private let badge: String
    private let icon: Image?
    private let style: Style
    private let fontProvider: FontProvider
}

#Preview {
    HStack {
        DailyFilterView(
            name: "Nearby",
            badge: "",
            icon: nil,
            style: .selected,
            fontProvider: .system
        )
        DailyFilterView(
            name: "Nearby",
            badge: "1",
            icon: Image(systemName: "map"),
            style: .selected,
            fontProvider: .system
        )
        DailyFilterView(
            name: "3Some",
            badge: "",
            icon: nil,
            style: .normal,
            fontProvider: .system
        )
        DailyFilterView(
            name: "Hot",
            badge: "99+",
            icon: Image(systemName: "flame.fill"),
            style: .normal,
            fontProvider: .system
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(Color.black)
}
