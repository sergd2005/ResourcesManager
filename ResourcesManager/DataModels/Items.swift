//
//  Items.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable, ObservableObject {
    var id: String {
        name
    }
    
    @Attribute(.unique) var name: String
    var craftingRecipe: CraftingRecipe?
    
    init(name: String) {
        self.name = name
    }
}

@Model
final class Component: Identifiable, ObservableObject {
    let id = UUID()
    var count: Int = 1
    var item: Item?
    var craftingRecipe: CraftingRecipe?
    
    init() {}
}

@Model
final class CraftingRecipe: ObservableObject {
    var requiredComponents: [Component] = []
    var producedItemCount = "1"
    var producedItem: Item?
    
    init(producedItem: Item? = nil, producedItemCount: String = "") {
        self.producedItem = producedItem
        self.producedItemCount = producedItemCount
    }
}
