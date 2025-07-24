//
//  Tooltip+ViewModel.swift
//  
//
//  Created by Sunil Targe on 29.08.2024.
//

import SwiftUI

extension Tooltip {
    
    final class ViewModel: ObservableObject {
        
        @Published var contentViewSize: CGSize = .zero
        @Published var tooltipViewSize: CGSize = .zero

        let config: ViewConfig
        let onTap: () -> Void        
        
        var xOffset: Double {
            switch config.horizontalAlignment {
                
            case .leading:
                return (tooltipViewSize.width / 2) - config.cornerRadius - config.arrowSize.width / 2
                
            case .center:
                return 0
                
            case .trailing:
                return -(tooltipViewSize.width / 2) + config.cornerRadius + config.arrowSize.width / 2
            }
        }
        
        var yOffset: Double {
            switch config.verticalAlignment {
            case .top:
                return -(config.arrowSize.height + tooltipViewSize.height / 2 + contentViewSize.height / 2)
            case .bottom:
                return (config.arrowSize.height + tooltipViewSize.height / 2 + contentViewSize.height / 2)
            }
        }
        
        init(
            config: ViewConfig,
            onTap: @escaping () -> Void,
            contentViewSize: CGSize = .zero,
            tooltipViewSize: CGSize = .zero
        ) {
            self.config = config
            self.onTap = onTap
            self.contentViewSize = contentViewSize
            self.tooltipViewSize = tooltipViewSize
        }
    }
}
