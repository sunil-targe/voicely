//
//  DropdownButton_Style.swift
//
//
//  Created by Sunil Targe on 2024/8/20.
//

import SwiftUI

public struct DropdownButtonStyle {
    public let background: ReusableStyle.Color
    public let foreground: ReusableStyle.Color
    public let cornerRadius: CGFloat
    public let height: CGFloat
   
    public let itemsBackground: ReusableStyle.Color
    public let itemsForeground: ReusableStyle.Color
    public let selectedItemBackground: ReusableStyle.Color
    public let itemsStrokColor: Color
    public let itemsCornerRadius: CGFloat
    public let itemsShadowColor: Color
    
    public let fontProvider: FontProvider
    
    public init(
        background: ReusableStyle.Color,
        foreground: ReusableStyle.Color,
        cornerRadius: CGFloat,
        height: CGFloat,
       
        itemsBackground: ReusableStyle.Color,
        itemsForeground: ReusableStyle.Color,
        selectedItemBackground: ReusableStyle.Color,
        itemsStrokColor: Color,
        itemsCornerRadius: CGFloat,
        itemsShadowColor: Color,
        
        fontProvider: FontProvider
    ) {
        self.background = background
        self.foreground = foreground
        self.cornerRadius = cornerRadius
        self.height = height

        self.itemsBackground = itemsBackground
        self.itemsForeground = itemsForeground
        self.selectedItemBackground = selectedItemBackground
        self.itemsStrokColor = itemsStrokColor
        self.itemsCornerRadius = itemsCornerRadius
        self.itemsShadowColor = itemsShadowColor
        
        self.fontProvider = fontProvider
    }
}

extension DropdownButtonStyle {
    
    public static let standard: Self = .init(
        background: .hex("000000"),
        foreground: .hex("FFFFFF"),
        cornerRadius: 16,
        height: 32,
        itemsBackground: .hex("111012"),
        itemsForeground: .hex("9A999B"),
        selectedItemBackground: .hex("242126"),
        itemsStrokColor: .hex("242126"),
        itemsCornerRadius: 12,
        itemsShadowColor: .hex("000000").opacity(0.25),
        fontProvider: .system
    )
}
