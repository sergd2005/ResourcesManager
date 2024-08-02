//
//  ResourcesManagerApp.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import SwiftUI
import SwiftData

@main
struct ResourcesManagerApp: App {
    let container = try! ModelContainer(for: Item.self, CraftingRecipe.self, Component.self, Loot.self, migrationPlan: MigrationPlan.self)
    
    var body: some Scene {
        Window("Items", id: "Items") {
            ItemsView()
        }
        .modelContainer(container)
        Window("Loot", id: "Loot") {
            LootView()
        }
        .modelContainer(container)
        Window("Crafting", id: "Crafting") {
            CraftingRecipesView()
        }
        .modelContainer(container)
    }
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}

