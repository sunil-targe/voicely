//
//  File.swift
//  
//
//  Created by Sunil Targe on 13.07.2024.
//

import Foundation
import SwiftUI

extension WrappingHStack {
    final class ContentManager {
        let items: [AnyView]
        let getWidths: () -> [Double]
        lazy var widths: [Double] = {
            getWidths()
        }()
        
        init(items: [AnyView], getWidths: @escaping () -> [Double]) {
            self.items = items
            self.getWidths = getWidths
        }
        
        func isVisible(index: Int) -> Bool {
            widths[index] > 0
        }
    }
}
