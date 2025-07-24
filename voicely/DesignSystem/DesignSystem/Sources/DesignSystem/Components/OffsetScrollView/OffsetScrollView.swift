//
//  OffsetScrollView.swift
//
//
//  Created by Sunil Targe on 27.08.2024.
//

import SwiftUI

private struct ContentOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

public struct OffsetScrollView<Content: View>: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    public var body: some View {
        ScrollView {
            content()
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ContentOffsetKey.self,
                                value: geometry.frame(
                                    in: .named(coordinateSpace)
                                ).minY
                            )
                    }
                )
                .overlay(
                    GeometryReader { geometry in
                        Color.clear.onAppear { viewModel.contentViewSize = geometry.size }
                    }
                )
        }
        .coordinateSpace(name: coordinateSpace)
        .onPreferenceChange(ContentOffsetKey.self) { newValue in
            viewModel.offset = newValue
        }
        .overlay(
            GeometryReader { geometry in
                Color.clear.onAppear { viewModel.visibleContentSize = geometry.size }
            }
        )
        .onChange(of: viewModel.offset) { newOffset in
            viewModel.updateVisibility(with: newOffset)
        }
        .onChange(of: viewModel.edgeVisibility) {
            offsetDidChange($0)
        }
    }
    
    public init(
        content: @escaping () -> Content,
        offsetDidChange: @escaping (EdgeVisibility) -> Void
    ) {
        self.content = content
        self.offsetDidChange = offsetDidChange
    }
    
    let coordinateSpace = "offset-scroll-view-coordinate-space"
    let content: () -> Content
    let offsetDidChange: (EdgeVisibility) -> Void
}

#Preview {
    var color = Color.orange
    return OffsetScrollView(
        content: {
            VStack(spacing: 0) {
                ForEach(0 ..< 100) { index in
                    Text("\(index)")
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            color.opacity(Double(index) / 100)
                        )
                }
            }
        },
        offsetDidChange: { edgeVisibility in
            guard edgeVisibility == .bottom else { return }
            color = [Color.green, Color.yellow, Color.blue].randomElement()!
        }
    )
}
