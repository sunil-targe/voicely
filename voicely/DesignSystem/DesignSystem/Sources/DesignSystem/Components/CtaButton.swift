//
//  CtaButton.swift
//
//
//  Created by Sunil Targe on 15.08.2024.
//

import SwiftUI

public struct CtaButtonStyle: ButtonStyle {
    
    public let style: Style
    public let fontProvider: FontProvider
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(fontProvider.font(size: 16, weight: .bold))
            .padding(.horizontal)
            .applyReusableForeground(style.foreground)
            .applyReusableBackground(style.background)
            .applyReusableBorder(style.border)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

extension ButtonStyle where Self == CtaButtonStyle {
    
    public static func ctaButtonStyle(style: CtaButtonStyle.Style, fontProvider: FontProvider) -> Self {
        CtaButtonStyle(style: style, fontProvider: fontProvider)
    }
}

public extension CtaButtonStyle {
    struct Style {
        
        let foreground: ReusableStyle.Color
        let background: ReusableStyle.Color
        let border: ReusableStyle.Border
        
        public init(
            foreground: ReusableStyle.Color,
            background: ReusableStyle.Color,
            border: ReusableStyle.Border
        ) {
            self.foreground = foreground
            self.background = background
            self.border = border
        }
    }
}

extension CtaButtonStyle.Style {
    
    public static let standard: Self = .init(
        foreground: .hex("#FFFFFF"),
        background: .horizontal("#A734BD", "#FF006A"),
        border: .cornerRadius(24)
    )
    
    public static let selectedBordered: Self = .init(
        foreground: .hex("#FFFFFF"),
        background: .hex("#000000"),
        border: .init(radius: 24, width: 1, color: .horizontal("#A734BD", "#FF006A"))
    )
    
    public static let unSelectedBordered: Self = .init(
        foreground: .hex("#FFFFFF"),
        background: .hex("#000000"),
        border: .init(radius: 24, width: 1, color: .hex("#242126"))
    )
}

#Preview {
    VStack {
        Button(
            action: {},
            label: {
                Text("CTA Button")
                    .frame(height: 48)
            }
        )
        .buttonStyle(
            .ctaButtonStyle(
                style: .selectedBordered,
                fontProvider: .system
            )
        )
     
        Button(
            action: {},
            label: {
                Text("CTA Button")
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(
            .ctaButtonStyle(
                style: .standard,
                fontProvider: .system
            )
        )
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
}
