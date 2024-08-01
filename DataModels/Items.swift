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
    var isTool = false
    
    init(name: String) {
        self.name = name
    }
}

@Model
final class Component: Identifiable, ObservableObject {
    let id = UUID()
    
    var name: String = ""
   
    // TODO: one item can be stored in multiple components - how to build inverse relationship in SwiftData?
    var itemIDS: [UUID] = []
    
    func items(modelContext: ModelContext) -> [Item] {
        let itemsPredicate = #Predicate<Item> { item in
            itemIDS.contains(item.id)
        }
        let descriptor = FetchDescriptor<Item>(predicate: itemsPredicate)
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    var craftingRecipe: CraftingRecipe?
    
    var count: Int = 1
    
    init() {}
}

@Model
final class CraftingRecipe: Identifiable, ObservableObject {
    let id = UUID()
    
    var producedItemCount: String
    
    @Attribute(.unique) var producedItem: String
   
    @Relationship(deleteRule: .cascade, inverse: \Component.craftingRecipe)
    var requiredComponents: [Component] = []
    
    init(producedItem: String = "", producedItemCount: String = "1") {
        self.producedItem = producedItem
        self.producedItemCount = producedItemCount
    }
}
