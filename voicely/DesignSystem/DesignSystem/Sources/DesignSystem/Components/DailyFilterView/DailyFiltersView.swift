//
//  DailyFiltersView.swift
//
//
//  Created by  Sunil Targe on 2025/6/22.
//

import SwiftUI

public struct DailyFiltersView: View {
    
    public var body: some View {
        ScrollViewReader { scrollReader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(model.items) { item in
                        Button(
                            action: {
                                withAnimation {
                                    model.onSelection?(item.id)
                                }
                            },
                            label: {
                                DailyFilterView(
                                    name: item.name,
                                    badge: item.badge,
                                    icon: item.icon,
                                    style: model.selected?.id == item.id ? .selected : .normal,
                                    fontProvider: .system
                                )
                                .id(item.id)
                            })
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            }
            .conditionIfLet(model.selected) {
                $0.onChange(of: $1) { selectedItem in
                    withAnimation {
                        scrollReader.scrollTo(selectedItem.id, anchor: .center)
                    }
                }
            }
            
        }
        .overlay(
            LinearGradient(
                stops: [
                    .init(color: .black, location: 0.0),
                    .init(color: .clear, location: 0.07),
                    .init(color: .clear, location: 0.93),
                    .init(color: .black, location: 1.0),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .allowsHitTesting(false)
        )
        .disabled(!model.isUserInteractable)
    }
    
    public init(
        model: Model
    ) {
        self.model = model
    }
    
    // MARK: - Private
    
    @ObservedObject private var model: Model
}

#Preview {
    
    let model = DailyFiltersView.Model(
        items: [
            DailyFiltersView.Item(
                id: UUID().uuidString,
                name: "Nearby",
                badge: "",
                icon: nil
            ),
            DailyFiltersView.Item(
                id: UUID().uuidString,
                name: "3Some",
                badge: "",
                icon: nil
            ),
            DailyFiltersView.Item(
                id: UUID().uuidString,
                name: "Hot",
                badge: "",
                icon: Image(systemName: "flame")
            ),
            DailyFiltersView.Item(
                id: UUID().uuidString,
                name: "Verified",
                badge: "15+",
                icon: Image(systemName: "checkmark.seal")
            ),
            DailyFiltersView.Item(
                id: UUID().uuidString,
                name: "New York",
                badge: "99+",
                icon: Image(systemName: "building.2")
            ),
            DailyFiltersView.Item(
                id: UUID().uuidString,
                name: "Miami",
                badge: "1",
                icon: Image(systemName: "beach.umbrella")
            )
        ]
    )
    
    model.onSelection = { itemId in
        model.selected = model.items.first(where: { $0.id == itemId })
    }
    
    return DailyFiltersView(model: model)
    .padding(.horizontal, 31)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(
        Color.black
    )
}
