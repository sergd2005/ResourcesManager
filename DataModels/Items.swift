//
//  Items.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import Foundation
import SwiftData

enum V1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0,0,1)
    
    static var models: [any PersistentModel.Type] {
        [Loot.self, Item.self, Component.self, CraftingRecipe.self]
    }

    @Model
    final class Loot: ObservableObject {
        let id = UUID()
        
        var itemIDS: [UUID] = []
        var count = [UUID:Int]()
        
        func items(modelContext: ModelContext) -> [Item] {
            let itemsPredicate = #Predicate<Item> { item in
                itemIDS.contains(item.id)
            }
            let descriptor = FetchDescriptor<Item>(predicate: itemsPredicate)
            return (try? modelContext.fetch(descriptor)) ?? []
        }
        
        init() {}
    }
    
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
}

enum V2: VersionedSchema {
    static var versionIdentifier = Schema.Version(0,0,2)
    
    static var models: [any PersistentModel.Type] {
        [Loot.self, Item.self, Component.self, CraftingRecipe.self]
    }

    @Model
    final class Loot: ObservableObject {
        let id = UUID()
    
        var name: String
        var item: UUID
        var new_count: Int
    
        init(name: String ,item: UUID, count: Int) {
            self.name = name
            self.item = item
            self.new_count = count
        }
    }

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
}

enum V3: VersionedSchema {
    static var versionIdentifier = Schema.Version(0,0,3)
    
    static var models: [any PersistentModel.Type] {
        [Loot.self, Item.self, Component.self, CraftingRecipe.self]
    }

    @Model
    final class Loot: ObservableObject {
        let id = UUID()
    
        var name: String
        var item: UUID
        var count: Int
    
        init(name: String ,item: UUID, count: Int) {
            self.name = name
            self.item = item
            self.count = count
        }
    }

    @Model
    final class Item: Identifiable, ObservableObject {
        let id = UUID()
       
        @Attribute(.unique) var name: String
        
        var craftingRecipe: CraftingRecipe?
        var isTool = false
        var isLooted = false
        
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
}

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [V1.self, V2.self, V3.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2, migrateV2toV3]
    }

    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: V1.self,
        toVersion: V2.self,
        willMigrate:  { context in
            let loot = try? context.fetch(FetchDescriptor<V1.Loot>())
            loot?.forEach {
                context.delete($0)
            }
            try? context.save()
        },
        didMigrate: nil)
    
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: V2.self,
        toVersion: V3.self,
        willMigrate: nil,
        didMigrate: nil)
}

typealias Loot = V3.Loot
typealias Item = V3.Item
typealias Component = V3.Component
typealias CraftingRecipe = V3.CraftingRecipe
