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
    @State private var selectedAvailableItemID = UUID()
    @State private var selectedItemFromComponentID = UUID()
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    @Environment(\.modelContext) var modelContext
    
    private var selectedAvailableItem: Item? {
        items.filter { $0.id == selectedAvailableItemID }.first
    }
    
    private var selectedComponent: Component? {
        craftingRecipe.requiredComponents.filter { $0.id == selectedComponentID }.first
    }
    
    private var selectedItemFromComponent: Item? {
        items.filter { $0.id == selectedItemFromComponentID }.first
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Crafting Recipe")
                Button {
                    let recipeID = craftingRecipe.id
                    let itemsWithRecipePredicate = #Predicate<Item> { $0.craftingRecipe?.id == recipeID }
                    let descriptor = FetchDescriptor<Item>(predicate: itemsWithRecipePredicate)
                    guard let itemsWithRecipe = try? modelContext.fetch(descriptor) else { return }
                    
                    for item in itemsWithRecipe {
                        item.craftingRecipe = nil
                    }
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
                    HStack {
                        Button {
                            let component = Component()
                            craftingRecipe.requiredComponents.append(component)
                        } label: {
                            Text("Add")
                        }
                        if let selectedComponent {
                            Button {
                                guard let selectedComponentIndex = craftingRecipe.requiredComponents.firstIndex(of: selectedComponent) else { return }
                                craftingRecipe.requiredComponents.remove(at: selectedComponentIndex)
                                modelContext.delete(selectedComponent)
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                    List(craftingRecipe.requiredComponents, selection: $selectedComponentID) {
                        Text(($0.name) + " (\($0.count))")
                    }
                }
                if let selectedComponent {
                    VStack {
                        HStack {
                            Text("Name:")
                            TextField("Required",
                                      text: Bindable(selectedComponent).name)
                        }
                        HStack {
                            Text("Required amount:")
                            TextField("Required",
                                      value: Bindable(selectedComponent).count,
                                      formatter: numberFormatter)
                        }
                        Text("Possible Items")
                        List(selectedComponent.items(modelContext: modelContext), selection: $selectedItemFromComponentID) {
                            Text($0.name)
                        }
                    }
                }
                VStack {
                    if let selectedComponent {
                        if let selectedAvailableItem {
                            Button {
                                selectedComponent.itemIDS.append(selectedAvailableItem.id)
                                if selectedComponent.name.isEmpty {
                                    selectedComponent.name = selectedComponent.items(modelContext: modelContext).first?.name ?? ""
                                }
                                selectedAvailableItemID = UUID()
                            } label: {
                                Text("<-")
                            }
                        }
                        if let selectedItemFromComponent {
                            Button {
                                selectedComponent.itemIDS = selectedComponent.itemIDS.filter { $0 != selectedItemFromComponent.id }
                            } label: {
                                Text("->")
                            }
                        }
                    }
                }
                VStack {
                    Text("Available Items")
                    List(items.filter { item in
                        item.name != craftingRecipe.producedItem &&
                        !craftingRecipe.requiredComponents.flatMap({$0.items(modelContext: modelContext)}).contains(where: { $0 == item })
                    }, selection: $selectedAvailableItemID) {
                        Text($0.name)
                    }
                }
            }
        }
    }
}
