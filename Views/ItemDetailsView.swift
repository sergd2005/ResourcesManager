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
                    let itemID = item.id
                    let componentsWithItemPredicate = #Predicate<Component> { component in
                        component.itemIDS.contains(itemID)
                    }
                    let descriptor = FetchDescriptor<Component>(predicate: componentsWithItemPredicate)
                    guard let componentsWithItem = try? modelContext.fetch(descriptor) else { return }
                    for component in componentsWithItem {
                        component.itemIDS = component.itemIDS.filter { $0 != item.id }
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
                    item.craftingRecipe = CraftingRecipe(producedItem: item.name)
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

