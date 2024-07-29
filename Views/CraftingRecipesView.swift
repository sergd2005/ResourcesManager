//
//  CraftingRecipesView.swift
//  ResourcesManager
//
//  Created by Sergii D on 7/28/24.
//


import SwiftUI
import SwiftData

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
