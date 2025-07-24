//
//  Tooltip.swift
//  
//
//  Created by Sunil Targe on 26.08.2024.
//

import Foundation

public enum Tooltip {
    
    /// Defines vertical alignment of arrow relative to content view.
    ///
    public enum VerticalAlignment {
        
        /// The arrow view will be placed on top of content view.
        ///
        /// ⬆
        /// ----------------
        /// | Tooltip text |
        /// ----------------
        case top
        
        /// The arrow view will be placed on bottom of content view.
        ///
        /// ----------------
        /// | Tooltip text |
        /// ----------------
        /// ⬇
        ///
        case bottom
        
        /// Toggles the `VerticalAlignment` variable's value.
        func inverted() -> Self {
            switch self {
            case .top:
                return .bottom
            case .bottom:
                return .top
            }
        }
    }
    
    /// Defines horizontal alignment of arrow relative to content view.
    ///
    public enum HorizontalAlignment {
        
        /// A guide that marks the leading edge of the view.
        ///
        /// ⬆
        /// ----------------
        /// | Tooltip text |
        /// ----------------
        case leading
        
        /// A guide that marks the horizontal center of the view.
        ///
        ///        ⬆
        /// ----------------
        /// | Tooltip text |
        /// ----------------
        case center
        
        /// A guide that marks the trailing edge of the view.
        ///
        ///               ⬆
        /// ----------------
        /// | Tooltip text |
        /// ----------------
        case trailing
    }

    
}
