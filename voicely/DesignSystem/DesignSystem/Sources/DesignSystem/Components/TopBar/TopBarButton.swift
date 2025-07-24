//
//  TopBarButton.swift
//
//
//  Created by Sunil Targe on 2024/7/22.
//

import SwiftUI

public struct TopBarButton: View {
    
    public var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                    
                    if let indicator {
                        indicator
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .offset(x: 7, y: 9)
                    }
                }
            }
        )
    }
    
    public init(
        image: Image,
        indicator: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.indicator = indicator
        self.action = action
    }
    
    private let image: Image
    private var indicator: Image?
    private let action: () -> Void
}

#Preview {
    VStack {
        TopBarButton(
            image: .init(systemName: "person.crop.circle"),
            indicator: nil,
            action: {}
        )
    }
    .foregroundColor(Color.white)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
}
