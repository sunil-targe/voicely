//
//  DailyFiltersView+Model.swift
//
//
//  Created by Sunil Targe on 2025/6/22.
//

import Foundation
import SwiftUI

extension DailyFiltersView {
    
    public final class Model: ObservableObject {
        
        @Published public var isUserInteractable = true
        @Published public var items = [Item]()
        @Published public var selected: Item?
        
        public var onSelection: ((Item.ID) -> Void)?
        
        public init(items: [Item]) {
            self.items = items
        }

        public func select(_ id: Item.ID) {
            selected = items.first(where: { $0.id == id })
        }
        
        public func reloadAll(_ items: [Item], selectedId: Item.ID?) {
            self.items = items
            selected = items.first(where: { $0.id == selectedId })
        }
    }
    
    public struct Item: Identifiable, Equatable {
        public let id: String
        public let name: String
        public var badge: String
        public let icon: Image?
        
        public init(
            id: String,
            name: String,
            badge: String,
            icon: Image? = nil
        ) {
            self.id = id
            self.name = name
            self.badge = badge
            self.icon = icon
        }
    }
}

#if DEBUG
extension DailyFiltersView.Model {
    static func mock() -> Self {
        let items = [
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
        let model = Self(
            items: items
        )
        model.onSelection = { [weak model] id in
            model?.select(id)
        }
        return model
    }
}
#endif
