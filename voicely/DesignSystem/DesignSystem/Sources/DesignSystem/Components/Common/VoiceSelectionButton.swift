//
//  VoiceSelectionButton.swift
//  DesignSystem
//
//  Created by Sunil Targe on 2025/8/1.
//

import SwiftUI

public struct VoiceSelectionButton: View {
    public enum Style {
        case plain
        case withDropdown
    }
    
    public var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: "mic.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                    )
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.white)
                if style == .withDropdown {
                    Divider()
                        .foregroundStyle(.white.opacity(0.1))
                        .frame(height: 16)
                    Image(systemName: "chevron.down").imageScale(.small)
                        .foregroundStyle(.white.opacity(0.1))
                }
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    public init(
        color: Color,
        title: String,
        style: Style = .withDropdown,
        action: (() -> Void)? = nil
    ) {
        self.color = color
        self.title = title
        self.style = style
        self.action = action
    }
    
    private let color: Color
    private let title: String
    private let style: Style
    private let action: (() -> Void)?
}

#Preview {
    ZStack {
        Color.black
        VoiceSelectionButton(color: .cyan, title: "Calm Woman") {
            //
        }
    }
    
}
