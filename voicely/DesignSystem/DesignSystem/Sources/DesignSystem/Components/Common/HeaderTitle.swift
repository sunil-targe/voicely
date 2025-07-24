//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Sunil Targe on 2025/7/28.
//

import SwiftUI

public struct HeaderTitle: View {
    public var body: some View {
        Button(action: action ?? {}) {
            HStack {
                Text(text)
                    .font(.title3)
                    .fontWeight(.bold)
                if let icon {
                    icon
                }
                Spacer()
                if let actionIcon {
                    actionIcon
                        .foregroundColor(.gray)
                }
            }
            .foregroundColor(color)
        }
    }
    
    public init(
        text: String,
        icon: Image? = nil,
        actionIcon: Image? = nil,
        color: Color,
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.actionIcon = actionIcon
        self.color = color
        self.action = action
    }
    
    private let text: String
    private let icon: Image?
    private let actionIcon: Image?
    private let color: Color
    private let action: (() -> Void)?
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(alignment: .leading) {
            HeaderTitle(text: "Stories", color: .white)
            Divider()
            HeaderTitle(text: "My books", icon: Image(systemName: "books.vertical.fill"), color: .white)
            Divider()
            HeaderTitle(text: "Stories 📖", color: .yellow)
            Divider()
            HeaderTitle(text: "Read all 📖", actionIcon: Image(systemName: "chevron.forward"), color: .green) {
                debugPrint("Read all action")
            }
        }
    }
}
