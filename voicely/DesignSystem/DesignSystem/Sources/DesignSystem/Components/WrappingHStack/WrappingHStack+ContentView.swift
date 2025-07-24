//
//  File.swift
//  
//
//  Created by Sunil Targe on 13.07.2024.
//

import Foundation
import SwiftUI

extension WrappingHStack {
    
    struct ContentView: View {
        
        func startOf(line: Int) -> Int {
            firstItemOfEachLine[line]
        }
        
        func endOf(line: Int) -> Int {
            line == totalLines - 1 ? contentManager.items.count - 1 : firstItemOfEachLine[line + 1] - 1
        }
        
        var body: some View {
            VStack(alignment: alignment, spacing: spacing.vertical) {
                ForEach(0 ..< totalLines, id: \.self) { yIndex in
                    HStack(spacing: spacing.horizontal) {
                        
                        ForEach(startOf(line: yIndex) ... endOf(line: yIndex), id: \.self) { xIndex in
                            contentManager.items[xIndex]
                        }
                    }
                }
            }
        }
        
        init(
            width: CGFloat,
            alignment: HorizontalAlignment,
            spacing: (horizontal: Double, vertical: Double),
            contentManager: ContentManager
        ) {
            self.width = width
            self.alignment = alignment
            self.spacing = spacing
            self.contentManager = contentManager
            self.firstItemOfEachLine = {
                var result = [Int]()
                var currentWidth: Double = width
                for(index, _) in contentManager.items.enumerated() where contentManager.isVisible(index: index) {
                    let itemWidth = contentManager.widths[index]
                    if currentWidth + itemWidth + spacing.horizontal > width {
                        currentWidth = itemWidth
                        result.append(index)
                    } else {
                        currentWidth += itemWidth + spacing.horizontal
                    }
                }
                
                return result
            }()
        }

        // MARK: - Private
        
        private let width: CGFloat
        private let contentManager: ContentManager
        private let firstItemOfEachLine: [Int]
        private let alignment: HorizontalAlignment
        private let spacing: (horizontal: Double, vertical: Double)
        
        private var totalLines: Int { firstItemOfEachLine.count }
    }
}

