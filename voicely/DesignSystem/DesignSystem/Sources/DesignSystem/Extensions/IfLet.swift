//
//  IfLet.swift
//
//
//  Created by Sunil Targe on 22.07.2024.
//

import Foundation
import SwiftUI

extension View {
    
    /// Conditional view builder. If condition is true
    /// the transformer executes, otherwise view returns with
    /// no changes.
    ///
    @ViewBuilder 
    public func condition<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Conditional view builder. If value can be unwrapped
    /// the transformer executes, otherwise view returns with
    /// no changes.
    ///
    @ViewBuilder
    public func conditionIfLet<T, Content: View>(
        _ value: T?,
        transform: (Self, T) -> Content
    ) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
}
