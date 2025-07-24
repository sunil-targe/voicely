//
//  Tag.swift
//  
//
//  Created by Sunil Targe on 09.07.2024.
//

import SwiftUI

public struct Tag: Identifiable {
    let text: String
    let image: Image?
    let isHighlighted: Bool
    let action: (() -> Void)?
    
    public var id: String {
        "\(text):\(image == nil ? "no-image" : "image")"
    }
    
    public init(
        text: String,
        image: Image?,
        isHighlighted: Bool,
        action: (() -> Void)?
    ) {
        self.text = text
        self.image = image
        self.isHighlighted = isHighlighted
        self.action = action
    }
    
    public static func text(_ text: String, action: (() -> Void)? = nil) -> Tag {
        .init(
            text: text,
            image: nil,
            isHighlighted: false,
            action: action
        )
    }
    
    public static func highlighted(_ text: String, _ image: Image?, action: (() -> Void)? = nil) -> Tag {
        .init(
            text: text,
            image: image,
            isHighlighted: true,
            action: action
        )
    }
}

extension Tag: Equatable, Hashable {
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}
