//
//  IntroModalView.swift
//  
//
//  Created by Sunil Targe on 14.08.2024.
//

import SwiftUI

public struct IntroModalViewStyle {
    let border: ReusableStyle.Border
    let background: ReusableStyle.Color
    let foreground: ReusableStyle.Color
    let ctaButtonBackground: ReusableStyle.Color
    let ctaBorder: ReusableStyle.Border
}

/// Defines view with optional top view, title, and subtitle.
/// Can be reused as an intro view with one button for closing it.
/// Used in "Fresh Faces" as an introduction view.
///
public struct IntroModalView<TopView: View>: View {
    
    public let topView: (() -> TopView)?
    public let title: String
    public let subtitle: String
    public let ctaButtonTitle: String
    public let style: IntroModalViewStyle
    public let onCtaAction: () -> Void

    let fontProvider: FontProvider
    
    public var body: some View {
        VStack {
            VStack(spacing: 24) {
                
                topView?()
                
                VStack(spacing: 12) {
                    Text(title)
                        .multilineTextAlignment(.center)
                        .font(fontProvider.font(size: 24, weight: .bold))
                    Text(subtitle)
                        .multilineTextAlignment(.center)
                        .font(fontProvider.font(size: 14, weight: .regular))
                }
                .padding(.horizontal, 20)
                
                Button(
                    action: onCtaAction,
                    label: {
                        Text(ctaButtonTitle)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                )
                .buttonStyle(
                    .ctaButtonStyle(
                        style: .standard,
                        fontProvider: fontProvider
                    )
                )
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 32)
            .applyReusableForeground(style.foreground)
            .applyReusableBackground(style.background)
            .applyReusableBorder(style.border)
        }
        .ignoresSafeArea()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
    }
    
    public init(
        @ViewBuilder topView: @escaping () -> TopView = { EmptyView() },
        title: String,
        subtitle: String,
        ctaButtonTitle: String,
        style: IntroModalViewStyle,
        fontProvider: FontProvider,
        onCtaAction: @escaping () -> Void
    ) {
        self.topView = topView
        self.title = title
        self.subtitle = subtitle
        self.ctaButtonTitle = ctaButtonTitle
        self.style = style
        self.fontProvider = fontProvider
        self.onCtaAction = onCtaAction
    }
}

extension IntroModalViewStyle {
    public static let standard: Self = .init(
        border: .cornerRadius(24),
        background: .vertical("#502E7C", "#211E23"),
        foreground: .hex("#FFFFFF"),
        ctaButtonBackground: .horizontal("#A734BD", "#FF006A"),
        ctaBorder: .cornerRadius(24)
    )
}

#if DEBUG
#Preview {
    return VStack {
        Text(String(repeating: String.loremIpsum, count: 10))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
    .foregroundColor(Color.white)
    .overlay(
        IntroModalView(
            title: "Hottest men who Recently Joined",
            subtitle: "Be one of the first to welcome the hottest new guys in the app. Don't miss your chance to make new connections and unforgettable memories!",
            ctaButtonTitle: "Continue",
            style: .standard,
            fontProvider: .system,
            onCtaAction: {}
        )
    )
}

extension String {
    static let loremIpsum = """
        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
        """
}
#endif
