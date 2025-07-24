//
//  ReusableFont.swift
//
//
//  Created by Sunil Targe on 01.08.2024.
//

import Foundation
import SwiftUI

struct ReusableFont: ViewModifier {
    
    let font: ReusableStyle.Font
    let fontProvider: FontProvider
    
    func body(content: Content) -> some View {
        content
            .font(fontProvider.font(size: font.size, weight: font.weight))
    }
}

extension View {
    /// Extension function for applying `ReusableStyle.Font` for any view.
    ///
    func applyReusableFont(_ font: ReusableStyle.Font, provider: FontProvider) -> some View {
        ModifiedContent(
            content: self,
            modifier: ReusableFont(font: font, fontProvider: provider)
        )
    }
}

