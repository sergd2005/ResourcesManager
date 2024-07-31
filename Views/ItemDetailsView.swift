//
//  ItemDetailsView.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/28/24.
//

import SwiftUI
import SwiftData

struct ItemDetailsView: View {
    @ObservedObject var item: Item
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            Text("Item Details")
            
            Form {
                TextField("Item Name",
                          text: $item.name,
                          prompt: Text("Required"))
                
            }
            
            HStack {
                Toggle(isOn: $item.isTool) {
                    Text("Is Tool")
                }
                Button {
                    let componentsWithItemPredicate = #Predicate<Component> { component in
                        !component.items.isEmpty
                    }
                    let descriptor = FetchDescriptor<Component>(predicate: componentsWithItemPredicate)
                    guard let componentsWithItems = try? modelContext.fetch(descriptor) else { return }
                    let componentsWithCurrentItem = componentsWithItems.filter { $0.items.contains(where: {$0 == item})}
                    for component in componentsWithCurrentItem {
                        component.items = component.items.filter({$0 != item})
                    }
                    modelContext.delete(item)
                } label: {
                    Text("Delete Item")
                }
            }
            
            if let craftingRecipe = item.craftingRecipe {
                CraftingRecipeView(craftingRecipe:craftingRecipe)
            } else {
                Button {
                    item.craftingRecipe = CraftingRecipe(producedItem: item)
                } label: {
                    Text("Add Crafting Recipe")
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview("ItemDetailsView") {
    ItemDetailsView(item: SampleData.itemWithoutRecipe)
    .modelContainer(previewContainer)
}

