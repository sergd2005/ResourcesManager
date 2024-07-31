//
//  CraftingRecipesView.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/28/24.
//

import SwiftUI
import SwiftData

struct CraftingRecipesView: View {
    @State private var selectedCraftingRecipes = Set<UUID>()
    @State private var allItemsViewModel = AllItemsViewModel(craftingRecipes: [])
    @Query private var craftingRecipes: [CraftingRecipe]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    allItemsViewModel = AllItemsViewModel(craftingRecipes: craftingRecipes.filter { selectedCraftingRecipes.contains($0.id) })
                } label: {
                    Text("Refresh")
                }
                List(craftingRecipes, selection: $selectedCraftingRecipes) { recipe in
                    Text(recipe.producedItem + " (\(recipe.requiredComponents.count))")
                }
                .onChange(of: selectedCraftingRecipes) {
                    allItemsViewModel = AllItemsViewModel(craftingRecipes: craftingRecipes.filter { selectedCraftingRecipes.contains($0.id) })
                }
            }
            if !selectedCraftingRecipes.isEmpty {
                AllItemsView(viewModel: allItemsViewModel)
            }
        }
    }
}

final class ItemCount: Identifiable, ObservableObject {
    let id = UUID()
    let item: Item
    var count: Int
    
    init(item: Item, count: Int) {
        self.item = item
        self.count = count
    }
}

final class AllItemsViewModel: ObservableObject {
    let craftingRecipes: [CraftingRecipe]
    
    init(craftingRecipes: [CraftingRecipe]) {
        self.craftingRecipes = craftingRecipes
    }
    
    var allItems: [ItemCount] {
        var itemsCountArray = [ItemCount]()
        processedRecipes.removeAll()
        for craftingRecipe in craftingRecipes {
            getAllItems(craftingRecipe: craftingRecipe, items: &itemsCountArray)
        }
        for craftingRecipe in craftingRecipes {
            itemsCountArray = itemsCountArray.filter { $0.item.name != craftingRecipe.producedItem }
        }
        var itemsMap = [UUID: ItemCount]()
        for itemCount in itemsCountArray {
            var count = itemsMap[itemCount.item.id, default: ItemCount(item: itemCount.item, count: 1)]
            count.count = count.count + itemCount.count
            itemsMap[itemCount.item.id] = count
        }
        return itemsMap.map { (key: UUID, value: ItemCount) in
            value
        }
    }
    
    private var processedRecipes = Set<CraftingRecipe>()
    
    private func getAllItems(craftingRecipe: CraftingRecipe, items: inout [ItemCount], recipeCount: Int = 1) {
        guard !processedRecipes.contains(craftingRecipe) else { return }
        
        processedRecipes.insert(craftingRecipe)
        for component in craftingRecipe.requiredComponents {
            for item in component.items {
                if item.isTool {
                    items.append(ItemCount(item: item, count: 1))
                } else {
                    if let craftingRecipe = item.craftingRecipe {
                        let ratio = Float(component.count)/Float(Int(craftingRecipe.producedItemCount) ?? 1)
                        let recipesCount = Int(ratio.rounded(.up))
                        getAllItems(craftingRecipe: craftingRecipe, items: &items, recipeCount: recipesCount)
                    } else {
                        items.append(ItemCount(item: item, count: recipeCount * component.count))
                    }
                }
            }
        }
    }
}

struct AllItemsView: View {
    @ObservedObject var viewModel: AllItemsViewModel
    
    var body: some View {
        List(viewModel.allItems/*, selection: $selectedCraftingRecipes*/) {
            Text($0.item.name + " (\($0.count))")
        }
    }
}

#Preview("CraftingRecipesView") {
    CraftingRecipesView()
    .frame(width: 1000, height: 500)
    .modelContainer(previewContainer)
}
