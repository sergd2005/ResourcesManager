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
    @Relationship(inverse: \Component.items) var components = [Component]()
    
    var craftingRecipe: CraftingRecipe?
    var isTool = false
    
    init(name: String) {
        self.name = name
    }
}

@Model
final class Component: Identifiable, ObservableObject {
    let id = UUID()
    
    @Attribute(.unique) var name: String = ""
    // TODO: one item can be stored in multiple components - how to build inverse relationship in SwiftData?
    @Relationship var items: [Item] = []
    @Relationship(inverse: \CraftingRecipe.requiredComponents) var craftingRecipe: CraftingRecipe?
    
    var count: Int = 1
    
    init() {}
}

@Model
final class CraftingRecipe: Identifiable, ObservableObject {
    let id = UUID()
    
    var producedItemCount: String
    
    @Attribute(.unique) var producedItem: String
    @Relationship var requiredComponents: [Component] = []
    
    init(producedItem: String = "", producedItemCount: String = "1") {
        self.producedItem = producedItem
        self.producedItemCount = producedItemCount
    }
}
