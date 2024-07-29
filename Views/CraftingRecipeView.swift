//
//  CraftingRecipeView.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/28/24.
//

import SwiftUI
import SwiftData

struct CraftingRecipeView: View {
    @Query private var items: [Item]
    
    @ObservedObject var craftingRecipe: CraftingRecipe
    
    @State private var selectedComponentID = UUID()
    @State private var selectedAvailableItemID = ""
    @State private var requiredAmount = ""
    
    @Environment(\.modelContext) var modelContext
    
    
    private var selectedAvailableItem: Item? {
        items.filter { $0.id == selectedAvailableItemID }.first
    }
    
    private var selectedComponent: Component? {
        craftingRecipe.requiredComponents.filter { $0.id == selectedComponentID }.first
    }
    
    var body: some View {
        if let producedItem = craftingRecipe.producedItem {
            VStack {
                HStack {
                    Text("Crafting Recipe")
                    Button {
                        modelContext.delete(craftingRecipe)
                    } label: {
                        Text("Delete Recipe")
                    }
                }
                Form {
                    TextField("Produced amount",
                              text: $craftingRecipe.producedItemCount,
                              prompt: Text("Required"))
                }
                HStack {
                    VStack {
                        Text("Components")
                        List(craftingRecipe.requiredComponents, selection: $selectedComponentID) {
                            Text(($0.item?.name ?? "") + " (\($0.count))")
                        }
                    }
                    VStack {
                        if let selectedAvailableItem {
                            TextField("Required amount",
                                      text: $requiredAmount)
                            Button {
                                guard let requiredAmountInt = Int(requiredAmount) else { return }
                                let component = Component()
                                component.count = requiredAmountInt
                                component.item = selectedAvailableItem
                                craftingRecipe.requiredComponents.append(component)
                                requiredAmount = ""
                                selectedAvailableItemID = ""
                            } label: {
                                Text("<-")
                            }
                        }
                        if let selectedComponent {
                            Button {
                                craftingRecipe.requiredComponents = craftingRecipe.requiredComponents.filter({$0 != selectedComponent})
                            } label: {
                                Text("->")
                            }
                        }
                    }
                    VStack {
                        Text("Available Items")
                        List(items.filter { item in item != producedItem && !craftingRecipe.requiredComponents.map({$0.item}).contains(where: { componentItem in componentItem == item})}, selection: $selectedAvailableItemID) {
                            Text($0.name)
                        }
                    }
                }
            }
        }
    }
}
