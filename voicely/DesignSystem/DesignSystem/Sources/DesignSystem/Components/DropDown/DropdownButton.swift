//
//  DropdownButton.swift
//
//
//  Created by Sunil Targe on 2024/8/19.
//

import SwiftUI

public struct DropdownButton<SelectionValue: Equatable>: View {
    
    public struct Item: Equatable {
        public let title: String
        public let value: SelectionValue
        
        public init(
            title: String,
            value: SelectionValue
        ) {
            self.title = title
            self.value = value
        }
    }
    
    public var body: some View {
        VStack(spacing: 5) {
            Button {
                withAnimation {
                    isDropdownVisible.toggle()
                }
                onTap?()
            } label: {
                HStack(spacing: 6) {
                    if let icon {
                        icon.resizable()
                            .scaledToFit()
                            .frame(
                                width: style.height / 2,
                                height: style.height / 2
                            )
                    }
                    TitleView.font(style.fontProvider.font(size: 14, weight: .medium))
                    Image(systemName: isDropdownVisible ? "chevron.up" : "chevron.down")
                        .padding(.leading, 6)
                }
                .frame(height: style.height)
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        standardWidth = geometry.size.width + 32 // additional width is based on horizontal padding
                    }
                })
            }
            .buttonStyle(
                .ctaButtonStyle(
                    style: isDropdownVisible ? .selectedBordered : .unSelectedBordered,
                    fontProvider: .system
                )
            )
            .condition(isDropdownVisible) {
                $0.overlay(ItemsView)
            }
        }
    }
    
    private var TitleView: some View {
        Text(selectedItem?.title ?? title ?? "Select an Item")
    }
    
    private var ItemsView: some View {
        VStack(alignment: .leading) {
            ForEach(items, id: \.title) { item in
                Button {
                    withAnimation {
                        selectedItem = item
                        isDropdownVisible = false
                        action(item)
                    }
                } label: {
                    HStack {
                        if let checkmarkIcon {
                            checkmarkIcon
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: style.height / 2,
                                    height: style.height / 2
                                )
                                .padding(.leading, 8)
                                .opacity(selectedItem == item ? 1 : 0)
                        }
                        Text(item.title)
                            .padding(.trailing)
                            .font(style.fontProvider.font(size: 14, weight: .medium))
                            .applyReusableForeground(
                                style.itemsForeground
                            )
                    }
                    .frame(
                        width: standardWidth,
                        height: style.height,
                        alignment: .leading
                    )
                    .applyReusableBackground(
                        selectedItem == item ? style.selectedItemBackground : style.itemsBackground
                    )
                }
            }
        }
        .applyReusableBackground(
            style.itemsBackground
        )
        .cornerRadius(
            style.itemsCornerRadius
        )
        .shadow(color: style.itemsShadowColor, radius: 12, x: 0, y: 4)
        .overlay(
            RoundedRectangle(
                cornerRadius: style.itemsCornerRadius
            )
            .stroke(
                style.itemsStrokColor,
                lineWidth: 1
            )
        )
        .offset(y: dropdownPositionY)
    }
    
    public init(
        items: [Item],
        icon: Image?,
        checkmarkIcon: Image?,
        title: String? = nil,
        style: DropdownButtonStyle = .standard,
        defaultSelectedItem: Item? = nil,
        onTap: (() -> Void)? = nil,
        action: @escaping (Item?) -> Void
    ) {
        self.items = items
        self.icon = icon
        self.checkmarkIcon = checkmarkIcon
        self.title = title
        self.style = style
        self.selectedItem = defaultSelectedItem
        self.onTap = onTap
        self.action = action
        
        let itemCount = items.count
        let itemHeight = style.height
        let halfTotalHeight = (CGFloat(itemCount) * itemHeight) / 2
        let additionalHeight = CGFloat(itemHeight + 4)
        self.dropdownPositionY = halfTotalHeight + additionalHeight
    }
    
    @State private var isDropdownVisible = false
    @State private var selectedItem: Item? = nil
    @State private var standardWidth: CGFloat = 0
    
    private let items: [Item]
    private let icon: Image?
    private let checkmarkIcon: Image?
    private let title: String?
    private let style: DropdownButtonStyle
    private let onTap: (() -> Void)?
    private let action: (Item?) -> Void
    private var dropdownPositionY: CGFloat = 0
}

#Preview {
    VStack {
        HStack {
            Text("test")
            DropdownButton<Int>(
                items: [
                    .init(title: "100 miles", value: 100),
                    .init(title: "200 miles", value: 200),
                    .init(title: "300 miles", value: 300),
                    .init(title: "500 miles", value: 500)
                ],
                icon: .init(systemName: "location.fill"),
                checkmarkIcon: .init(systemName: "checkmark"),
                defaultSelectedItem: .init(title: "100 miles", value: 100),
                action: { _ in }
            )
        }
        .zIndex(1)
        VStack {
            Text("hellooooooooooo worldddddddddd")
            Text("hellooooooooooo worldddddddddd")
            Text("hellooooooooooo worldddddddddd")
            Text("hellooooooooooo worldddddddddd")
            Text("hellooooooooooo worldddddddddd")
            Text("hellooooooooooo worldddddddddd")
        }
    }
}
