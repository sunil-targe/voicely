//
//  File.swift
//  
//
//  Created by Sunil Targe on 12.07.2024.
//

import Foundation
import SwiftUI

@inline(__always) private func getWidth<T: View>(of view: T) -> Double {
    let hostingController = UIHostingController(rootView: view)
    return hostingController.sizeThatFits(in: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
}

struct WrappingHStack: View {
    
    private struct HeightPreferenceKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat , nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ContentView(width: geometry.size.width, alignment: alignment, spacing: spacing, contentManager: contentManager)
                .anchorPreference(
                    key: HeightPreferenceKey.self,
                    value: .bounds,
                    transform: {
                        geometry[$0].size.height
                    }
                )
        }
        .frame(height: height)
        .onPreferenceChange(HeightPreferenceKey.self, perform: {
            if abs(height - $0) > 1 {
                height = $0
            }
        })
    }
    
    init<Data: RandomAccessCollection, Content: View>(
        _ data: Data,
        id: KeyPath<Data.Element, Data.Element> = \.self,
        alignment: HorizontalAlignment = .leading,
        spacing: (horizontal: Double, vertical: Double),
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.contentManager = ContentManager(
            items: data.map { AnyView(content($0[keyPath: id])) },
            getWidths: {
                data.map {
                    getWidth(of: content($0[keyPath: id]))
                }
            })
    }
    
    // MARK: - Private
    
    @State private var height: CGFloat = 0
    private let contentManager: ContentManager
    private let alignment: HorizontalAlignment
    private let spacing: (horizontal: Double, vertical: Double)
}

#Preview {
    VStack {
        WrappingHStack(
            [
                .highlighted("Unicorn", Image(systemName: "paperplane.fill")),
                Tag.text("My place"),
                Tag.text("Their place"),
                Tag.text("Hotel"),
                Tag.text("Bar"),
                Tag.text("Travel buddy"),
                Tag.text("Online only"),
                .highlighted("3some", Image(systemName: "paperplane.fill")),
                Tag.text("I'll pick you up"),
                Tag.text("Group date")
            ],
            id: \.self,
            alignment: .center,
            spacing: (horizontal: 3, vertical: 3)
        ) { tag in
            TagView(
                fontProvider: .system,
                imageView: tag.image,
                style: tag.isHighlighted ? .highlighted : .standard,
                text: tag.text,
                onTap: nil
            )
        }
    }
    .frame(maxHeight: .infinity)
    .background(Color.black)
}
