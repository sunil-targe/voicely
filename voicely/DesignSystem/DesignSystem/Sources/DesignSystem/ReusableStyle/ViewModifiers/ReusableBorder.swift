//
//  ReusableBorder.swift
//  
//
//  Created by Sunil Targe on 22.07.2024.
//

import Foundation
import SwiftUI

struct ReusableBorder: ViewModifier {
    
    let border: ReusableStyle.Border
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: border.radius))
            .overlay(
                RoundedRectangle(cornerRadius: border.radius)
                    .strokeBorder(
                        .linearGradient(colors: border.color.colors, startPoint: .leading, endPoint: .trailing),
                        lineWidth: border.width
                    )
            )
    }
}

extension View {
    /// Extension function for applying `ReusableStyle.Border` for any view.
    /// 
    func applyReusableBorder(_ border: ReusableStyle.Border) -> some View {
        ModifiedContent(
            content: self,
            modifier: ReusableBorder(border: border)
        )
    }
}

