//
//  FontProvider.swift
//  
//
//  Created by Sunil Targe on 08.07.2024.
//

import Foundation
import SwiftUI
import UIKit

/// Defines mechanism for injecting fonts inside of DesignSystem and
/// avoid nesting fonts outside main bundle.
///
public class FontProvider {
    
    public init(_ builder: @escaping (CGFloat, Font.Weight) -> SwiftUI.Font) {
        self.fontBuilder = builder
    }
    
    func font(size: CGFloat, weight: Font.Weight = .regular) -> SwiftUI.Font {
        fontBuilder(size, weight)
    }
    
    // MARK: - Private
    
    private var fontBuilder: (CGFloat, Font.Weight) -> Font
}

public extension FontProvider {
    
    /// Provider that uses system font.
    /// 
    static let system = FontProvider {
        .system(size: $0, weight: $1)
    }
}
