//
//  TagView+Style.swift
//  
//
//  Created by Sunil Targe on 08.07.2024.
//

import Foundation
import SwiftUI

extension TagView {
    public struct Style {
        
        public let textColor: ReusableStyle.Color
        public let backgroundColor: ReusableStyle.Color
        
        public let cornerRadius: CGFloat
        
        public let borderWidth: CGFloat
        public let borderColor: ReusableStyle.Color
    }
}

extension TagView.Style {
    
    public static let standard: Self = .init(
        textColor: .hex("#FFFFFF"),
        backgroundColor: .hex("#332F3680"),
        cornerRadius: 8,
        borderWidth: 1.5,
        borderColor: .hex("#FFFFFF40")
    )
    
    public static let highlighted: Self = .init(
        textColor: .hex("#FFFFFF"),
        backgroundColor: .hex("#332F3680"),
        cornerRadius: 8,
        borderWidth: 1.5,
        borderColor: .horizontal("#A734BD", "#FF006A")
    )
}
