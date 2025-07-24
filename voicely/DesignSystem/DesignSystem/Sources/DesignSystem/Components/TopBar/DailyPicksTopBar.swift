//
//  DailyPicksTopBar.swift
//  
//
//  Created by Sunil Targe on 2024/7/22.
//

import Foundation
import SwiftUI

public struct DailyPicksTopBar<LeftContent, RightContent> : View where LeftContent: View, RightContent: View {
    
    @State var leftAreaSize: CGSize = .zero
    @State var rightWidth: Double = 0
    
    public var body: some View {
        
        ZStack {
            DailyFiltersView(
                model: filterModel
            )
            .padding(.leading, leftAreaSize.width - 4)
            .padding(.trailing, rightWidth - 4)

            leftArea()
                .padding(.leading, 10)
                .viewSize { size in
                    leftAreaSize = size
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            rightArea()
                .padding(.trailing, 10)
                .viewSize { size in
                    rightWidth = size.width
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
    }
    
    public init(
        @ViewBuilder leftArea: @escaping () -> LeftContent,
        @ViewBuilder rightArea: @escaping () -> RightContent,
        filterModel: DailyFiltersView.Model
    ) {
        self.leftArea = leftArea
        self.rightArea = rightArea
        self.filterModel = filterModel
    }
    
    private let leftArea: () -> LeftContent
    private let rightArea: () -> RightContent
    private let filterModel: DailyFiltersView.Model
}

#if DEBUG

#Preview {
    DailyPicksTopBar(
        leftArea: {
            TopBarButton(
                image: .init(systemName: "person.crop.circle"),
                indicator: nil,
                action: { debugPrint("action clicked") }
            )
        },
        rightArea: {
            HStack {
                TopBarButton(
                    image: .init(systemName: "paperplane"),
                    indicator: nil,
                    action: { debugPrint("action clicked") }
                )
                TopBarButton(
                    image: .init(systemName: "mappin.circle"),
                    indicator: nil,
                    action: { debugPrint("action clicked") }
                )
            }
        },
        filterModel: .mock()
    )
    .frame(alignment: .top)
    .background(Color.black)
    .foregroundColor(.white)
}

#endif
