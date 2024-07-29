/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view modifier for showing sample data in previews.
*/

import SwiftData

struct SampleData {
    static let craftingRecipe = CraftingRecipe(producedItemCount: "10")
   
    static var item: Item {
        let item = Item(name: "StoneAxe")
        item.craftingRecipe = craftingRecipe
        return item
    }
    
//    static var craftingRecipe: CraftingRecipe {
//        let craftingRecipe = CraftingRecipe()
//    }
    static var itemWithoutRecipe = Item(name: "Arrow")
    static var items/*: [Item]*/ = [item, itemWithoutRecipe]
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Item.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        
        if try modelContext.fetch(FetchDescriptor<Item>()).isEmpty {
            SampleData.items.forEach { container.mainContext.insert($0) }
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
