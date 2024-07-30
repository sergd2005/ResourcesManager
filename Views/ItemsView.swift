//
//  ContentView.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import SwiftUI
import SwiftData

struct ItemsView: View {
    
    @State private var selectedItemID = UUID()
    @State private var selectedItemName = ""
    @State private var selectedItemCount = 0
    @State private var newItemName = ""
    @State private var newItemCount = 1
    @State private var selectedItemProducedItemCount = ""
    
    @Environment(\.modelContext) var modelContext
    
    private var selectedItem: Item? {
        items.filter { $0.id == selectedItemID }.first
    }
    
    @Query private var items: [Item]
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    TextField("New Item Name", text: $newItemName)
                    Button {
                        guard !newItemName.isEmpty else { return }
                        let newItem = Item(name: newItemName)
                        modelContext.insert(newItem)
                        newItemName = ""
                    } label: {
                        Text("Add")
                    }
                }
                List(items, selection: $selectedItemID) {
                    Text($0.name)
                }
                .onChange(of: selectedItemID) {
                    guard let selectedItem else { return }
                    selectedItemName = selectedItem.name
                }
            }
            if let selectedItem {
                ItemDetailsView(item: selectedItem)
            }
        }
    }
}

//#Preview("Crafting Recipe") {
//    let item = Item(name: "Stone Axe")
//    @State var craftingRecipe = CraftingRecipe(producedItem: item)
//    
//    return CraftingRecipeView(craftingRecipe: $craftingRecipe)
//    .modelContainer(previewContainer)
//}

#Preview("ItemsView") {
    ItemsView()
    .frame(width: 1000, height: 500)
    .modelContainer(previewContainer)
}
