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
    
    @Query private var craftingRecipes: [CraftingRecipe]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            List(craftingRecipes, selection: $selectedCraftingRecipes) { recipe in
                Text(recipe.producedItem?.name ?? "No Item")
            }
        }
    }
}

#Preview("CraftingRecipesView") {
    CraftingRecipesView()
    .frame(width: 1000, height: 500)
    .modelContainer(previewContainer)
}
