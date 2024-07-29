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
    let id = UUID()
   
    @Attribute(.unique) var name: String
    var craftingRecipe: CraftingRecipe?
    
    init(name: String) {
        self.name = name
    }
}

@Model
final class Component: Identifiable, ObservableObject {
    let id = UUID()
    var name: String = ""
    var count: Int = 1
    var items: [Item] = []
    var craftingRecipe: CraftingRecipe?
    
    init() {}
}

@Model
final class CraftingRecipe: ObservableObject {
    var requiredComponents: [Component] = []
    var producedItemCount: String
    var producedItem: Item?
    
    init(producedItem: Item? = nil, producedItemCount: String = "1") {
        self.producedItem = producedItem
        self.producedItemCount = producedItemCount
    }
}
