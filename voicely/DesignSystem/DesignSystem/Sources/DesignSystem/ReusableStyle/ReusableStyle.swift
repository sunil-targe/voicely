//
//  ReusableStyle.swift
//  
//
//  Created by Sunil Targe on 08.07.2024.
//

import Foundation
import SwiftUI

/// Defines namespace for storing reusable style structure for
/// base components.
///
public enum ReusableStyle {
    
    /// Defines style for color.
    public enum Color {
        
        /// Plain color in HEX decimal representation.
        /// Ex.: #A734BD, #FF006A.
        /// Usage: `Color.hex("#FF006A")`
        ///
        case hex(String)
        
        /// Horizontal gradient in HEX decimal representation.
        /// Ex.: #A734BD, #FF006A.
        /// Usage: `Color.horizontal("#A734BD", "#FF006A")`
        ///
        case horizontal(String, String)
        
        /// Vertical gradient in HEX decimal representation.
        /// Ex.: #A734BD, #FF006A.
        /// Usage: `Color.horizontal("#A734BD", "#FF006A")`
        ///
        case vertical(String, String)

        /// Array with SwiftUI.Color representations.
        var colors: [SwiftUI.Color] {
            switch self {
            case .hex(let hexValue):
                return [.init(hex: hexValue)]
            case let .horizontal(fromHexValue, toHexValue):
                return [.hex(fromHexValue), .hex(toHexValue)]
            case let .vertical(fromHexValue, toHexValue):
                return [.hex(fromHexValue), .hex(toHexValue)]
            }
        }
    }
    
    /// Defines view border appearance.
    public struct Border {
        /// Corner radius.
        public let radius: Double
        /// Border width.
        public let width: Double
        /// Border color.
        public let color: Color
        
        public static let noBorder: Self = .init(radius: 0, width: 0, color: .hex("#FFFFFF00"))
        
        /// Corner radius with no border.
        public static func cornerRadius(_ radius: Double) -> Self {
            .init(radius: radius, width: 0, color: .hex("#FFFFFF00"))
        }
    }
    
    /// Defines text font appearance.
    public struct Font {
        /// Font size.
        public let size: Double
        /// Font weight.
        public let weight: SwiftUI.Font.Weight
    }
}
