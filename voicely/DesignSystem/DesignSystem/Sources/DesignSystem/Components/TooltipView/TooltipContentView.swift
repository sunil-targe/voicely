//
//  TooltipContentView.swift
//
//
//  Created by Sunil Targe on 25.08.2024.
//

import Foundation
import SwiftUI

struct TooltipContentView<ContentView: View>: View {
    
    let content: ContentView
    let background: Color
    
    let arrowSize: CGSize
    let verticalAlignment: Tooltip.VerticalAlignment
    let horizontalAlignment: Tooltip.HorizontalAlignment
    
    @State private var contentSize = CGSize.zero
    
    var body: some View {

        ZStack {

            content
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(background)
                .applyReusableBorder(.cornerRadius(cornerRadius))
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                contentSize = geometry.size
                            }
                    }
                )

            ArrowShape()
                .frame(width: arrowSize.width, height: arrowSize.height)
                .rotationEffect(arrowRotationAngle)
                .foregroundColor(background)
                .offset(
                    x: arrowOffsetX,
                    y: arrowOffsetY
                )
            
        }
    }
    
    init(
        content: ContentView,
        verticalAlignment: Tooltip.VerticalAlignment = .top,
        horizontalAlignment: Tooltip.HorizontalAlignment = .center,
        background: Color,
        arrowSize: CGSize = .init(width: 13, height: 8),
        cornerRadius: Double = 10
    ) {
        self.content = content
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.background = background
        self.arrowSize = arrowSize
        self.cornerRadius = cornerRadius
    }
    
    private let cornerRadius: Double
    
    private var arrowOffsetX: Double {
        switch horizontalAlignment {
        case .leading:
            return -(contentSize.width - arrowSize.width) / 2 + (cornerRadius)
        case .center:
            return 0
        case .trailing:
            return (contentSize.width - arrowSize.width) / 2 - (cornerRadius)
        }
    }
    
    private var arrowOffsetY: Double {
        switch verticalAlignment {
        case .top:
            return -(contentSize.height + arrowSize.height) / 2 + 1
        case .bottom:
            return ((contentSize.height + arrowSize.height) / 2 - 1)
        }
    }
    
    private var arrowRotationAngle: Angle {
        switch verticalAlignment {
        case .top:
            return .zero
        case .bottom:
            return .degrees(180)
        }
    }
}

#Preview {
    
    VStack(spacing: 32) {
        
        TooltipContentView(
            content: Text("Hello, World!")
                .foregroundColor(Color.black),
            verticalAlignment: .top,
            horizontalAlignment: .leading,
            background: .yellow
        )
        TooltipContentView(
            content: Text("Hello, World!")
                .foregroundColor(Color.black),
            verticalAlignment: .top,
            horizontalAlignment: .center,
            background: .yellow
        )
        TooltipContentView(
            content: Text("Hello, World!")
                .foregroundColor(Color.black),
            verticalAlignment: .top,
            horizontalAlignment: .trailing,
            background: .yellow
        )
        
        TooltipContentView(
            content: Text("Hello, World!")
                .foregroundColor(Color.black),
            verticalAlignment: .bottom,
            horizontalAlignment: .leading,
            background: .yellow
        )
        TooltipContentView(
            content: Text("Hello, World!")
                .foregroundColor(Color.black),
            verticalAlignment: .bottom,
            horizontalAlignment: .center,
            background: .yellow
        )
        TooltipContentView(
            content: Text("Hello, World!")
                .foregroundColor(Color.black),
            verticalAlignment: .bottom,
            horizontalAlignment: .trailing,
            background: .yellow
        )

    }
    
}

extension TooltipContentView {
    
    private struct ArrowShape: Shape {

        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addLines([
                CGPoint(x: 0, y: rect.height),
                CGPoint(x: rect.width / 2, y: 0),
                CGPoint(x: rect.width, y: rect.height),
            ])
            return path
        }
    }
}
