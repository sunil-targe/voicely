//
//  ViewSizeModifier.swift
//
//
//  Created by Sunil Targe on 29.07.2024.
//

import Foundation
import SwiftUI

struct ViewSizeModifier: ViewModifier {

    private struct SizePreferenceKey: PreferenceKey {
        static var defaultValue = CGSize.zero
        static func reduce(value: inout CGSize , nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
    
    @State var size = CGSize.zero
    
    let onChange: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .anchorPreference(
                    key: SizePreferenceKey.self,
                    value: .bounds,
                    transform: { geometry[$0].size }
                )
        }
        .frame(width: size.width, height: size.height)
        .onPreferenceChange(SizePreferenceKey.self) {
            size = $0
            onChange(size)
        }
    }
}

extension View {
    func viewSize(_ onChange: @escaping (CGSize) -> Void) -> some View {
        ModifiedContent(
            content: self,
            modifier: ViewSizeModifier(onChange: onChange)
        )
    }
}
