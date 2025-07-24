//
//  TagsView.swift
//
//
//  Created by Sunil Targe on 11.07.2024.
//

import Foundation
import SwiftUI

struct TagsView: View {
    
    var body: some View {
        WrappingHStack(
            tags,
            alignment: .leading,
            spacing: (
                horizontal: 3,
                vertical: 3
            )
        ) { tag in
            TagView(
                fontProvider: fontProvider,
                imageView: tag.image,
                style: tag.isHighlighted ? highlightedStyle : standardStyle,
                text: tag.text,
                onTap: tag.action
            )
        }
    }
    
    init(
        fontProvider: FontProvider,
        standardStyle: TagView.Style,
        highlightedStyle: TagView.Style,
        tags: [Tag]
    ) {
        self.fontProvider = fontProvider
        self.standardStyle = standardStyle
        self.highlightedStyle = highlightedStyle
        self.tags = tags
    }
    
    // MARK: - Private
    
    private let fontProvider: FontProvider
    private let standardStyle: TagView.Style
    private let highlightedStyle: TagView.Style
    private let tags: [Tag]
}

#Preview {
    TagsView(
        fontProvider: .system,
        standardStyle: .standard,
        highlightedStyle: .highlighted,
        tags: [
            .highlighted("Unicorn", Image(systemName: "paperplane.fill")),
            .text("My place"),
            .text("Their place"),
            .text("Hotel"),
            .text("Travel buddy"),
            .text("Online only"),
            .text("Bar"),
            .text("I'll pick you up"),
            .text("Group date"),
        ]
    )
    .padding()
    .background(Color.black)
}
