//
//  ReusableForeground.swift
//  
//
//  Created by Sunil Targe on 08.07.2024.
//

import Foundation
import SwiftUI

struct ReusableForeground: ViewModifier {
    
    let color: ReusableStyle.Color
    
    func body(content: Content) -> some View {
        
            switch color {
            
            case let .hex(hexValue):
                content.foregroundColor(Color(hex: hexValue))
                
            case let .horizontal(fromHexValue, toHexValue):
                if #available(iOS 17.0, *) {
                    content
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .hex(fromHexValue), .hex(toHexValue)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                } else {
                    content
                        .foregroundColor(Color(hex: fromHexValue))
                }
            
            case let .vertical(fromHexValue, toHexValue):
                if #available(iOS 17.0, *) {
                    content
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .hex(fromHexValue), .hex(toHexValue)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                } else {
                    content
                        .foregroundColor(Color(hex: fromHexValue))
                }
            }
    }
}

extension View {   
    func applyReusableForeground(_ color: ReusableStyle.Color) -> some View {
        ModifiedContent(
            content: self,
            modifier: ReusableForeground(color: color)
        )
    }
}
