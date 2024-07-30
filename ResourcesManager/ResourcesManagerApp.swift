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
    var body: some Scene {
        Window("Items", id: "Items") {
            ItemsView()
        }
        .modelContainer(for: Item.self)
        Window("Crafting", id: "Crafting") {
            CraftingRecipesView()
        }
        .modelContainer(for: Item.self)
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

