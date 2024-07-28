//
//  ContentView.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/27/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selectedItemID = ""


    @State private var selectedItemName = ""
    @State private var selectedItemCount = 0
    @State private var newItemName = ""
    @State private var newItemCount = 1
    @State private var selectedItemProducedItemCount = ""
    
//    @Binding private var selectedCraftingRecipe: CraftingRecipe? {
//        selectedItem?.craftingRecipe
//    }
    
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
//                    selectedCraftingRecipe = selectedItem.craftingRecipe
//                    selectedItemProducedItemCount = String(selectedItem.craftingRecipe.producedItemCount)
                }
            }
//            if let selectedItem = selectedItem?.craftingRecipe {
//                CraftingRecipeView(craftingRecipe: $craftingRecipe)
//            }
//            if let selectedItem {
//                @Bindable var selectedItemBinding = selectedItem
//                TextField("Title", text: $selectedItemBinding.name)
////                CraftingRecipeView(craftingRecipe: $selectedItemBinding.craftingRecipe)
//            }
            if let selectedItem
               /* */{
                @Bindable var selectedItemBinding = selectedItem
//                @Bindable var craftingRecipeBinding = craftingRecipe
                ItemDetailsView(item: selectedItem)
            }
            
            CraftingRecipesView()
        }
    }
}

//final class CraftingRecipeViewModel: ObservableObject {
//    var selectedItemName: String
//    
//    init(selectedItemName: String) {
//        self.selectedItemName = selectedItemName
//    }
//}

struct ItemDetailsView: View {
    @ObservedObject var item: Item
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            Form {
                TextField("Item Name",
                          text: $item.name,
                          prompt: Text("Required"))
                
            }
            Button {
                modelContext.delete(item)
            } label: {
                Text("Delete")
            }
           
            if let craftingRecipe = item.craftingRecipe
               /*let binding = Binding<CraftingRecipe>($item.craftingRecipe) */{
                HStack {
                    Text("Crafting Recipe")
                    Button {
                        item.craftingRecipe = nil
                        modelContext.delete(craftingRecipe)
                    } label: {
                        Text("Delete")
                    }
                }
                
                CraftingRecipeView(craftingRecipe:                 Binding(
                    get: { item.craftingRecipe ?? CraftingRecipe() },
                    set: { item.craftingRecipe = $0 }
))
            } else {
                Button {
                    item.craftingRecipe = CraftingRecipe(producedItem: item)
                } label: {
                    Text("Add")
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct CraftingRecipesView: View {
    @Query private var craftingRecipes: [CraftingRecipe]
    var body: some View {
        VStack {
            List(craftingRecipes/*, selection: $selectedItemID*/) { recipe in
                Text(recipe.producedItem?.name ?? "No Item")
            }
        }
    }
}

struct CraftingRecipeView: View {
    @Query private var items: [Item]
    @Binding var craftingRecipe: CraftingRecipe
    @State private var selectedComponentID = ""
    @State private var selectedAvailableResourceID = ""
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        if let producedItem = craftingRecipe.producedItem {
            VStack {
                Form {
                    TextField("Produced amount",
                              text: Bindable(craftingRecipe).producedItemCount,
                              prompt: Text("Required"))
                }
                HStack {
                    List(craftingRecipe.requiredComponents, selection: $selectedComponentID) {
                        Text($0.item?.name ?? "")
                    }
                    VStack {
                        Button {
                            
                        } label: {
                            Text("<-")
                        }
                        Button {
                            
                        } label: {
                            Text("->")
                        }
                    }
                    List(items.filter({ $0 != producedItem}), selection: $selectedAvailableResourceID) {
                        Text($0.name)
                    }
                }
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

#Preview("App") {
    ContentView()
    .modelContainer(previewContainer)
}


#Preview("ItemDetailsView") {
    ItemDetailsView(item: SampleData.itemWithoutRecipe)
    .modelContainer(previewContainer)
}
