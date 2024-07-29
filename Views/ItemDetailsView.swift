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
            
            Button {
                let componentsWithItemsPredicate = #Predicate<Component> { component in component.item != nil }
                let descriptor = FetchDescriptor<Component>(predicate: componentsWithItemsPredicate)
                guard let componentsWithItems = try? modelContext.fetch(descriptor) else { return }
                let componentsWithCurrentItem = componentsWithItems.filter { $0.item == item }
                for component in componentsWithCurrentItem {
                    let filteredComponents = component.craftingRecipe?.requiredComponents.filter({$0 != component}) ?? []
                    component.craftingRecipe?.requiredComponents = filteredComponents
                }
                for component in componentsWithCurrentItem {
                    modelContext.delete(component)
                }
                modelContext.delete(item)
            } label: {
                Text("Delete Item")
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

