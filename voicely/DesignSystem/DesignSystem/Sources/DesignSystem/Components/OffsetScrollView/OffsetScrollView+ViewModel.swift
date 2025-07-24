//
//  File.swift
//  
//
//  Created by Sunil Targe on 27.08.2024.
//

import SwiftUI

extension OffsetScrollView {

    public enum EdgeVisibility {
        case none, top, bottom, both
    }
    
    final class ViewModel: ObservableObject {
        
        
        @Published var edgeVisibility: EdgeVisibility = .none
        @Published var visibleContentSize = CGSize.zero
        @Published var contentViewSize = CGSize.zero
        @Published var offset: Double = 0
        
        func updateVisibility(with newOffset: Double) {
            
            guard contentViewSize.height > visibleContentSize.height else {
                edgeVisibility = .both
                return
            }
            
            guard abs(offset) >= 0 else {
                edgeVisibility = .top
                return
            }
            
            if contentViewSize.height - visibleContentSize.height - abs(offset) <= 0 {
                edgeVisibility = .bottom
            } else {
                edgeVisibility = .none
            }
        }
    }
}
