//
//  ReusableBackground.swift
//  
//
//  Created by Sunil Targe on 08.07.2024.
//

import Foundation
import SwiftUI

struct ReusableBackground: ViewModifier {
    
    let color: ReusableStyle.Color
    
    func body(content: Content) -> some View {
        switch color {
        case let .hex(hexValue):
            content
                .background(Color(hex: hexValue))
        case let .horizontal(fromHexValue, toHexValue):
            content
                .background(
                    LinearGradient(
                        colors: [.hex(fromHexValue), .hex(toHexValue)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        case let .vertical(fromHexValue, toHexValue):
            content
                .background(
                    LinearGradient(
                        colors: [.hex(fromHexValue), .hex(toHexValue)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }
}

extension View {
    func applyReusableBackground(_ color: ReusableStyle.Color) -> some View {
        ModifiedContent(
            content: self,
            modifier: ReusableBackground(color: color)
        )
    }
}
