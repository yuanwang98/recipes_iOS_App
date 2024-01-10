//
//  RecipeListView.swift
//  WatchRecipes Watch App
//
//  Created by Yuan Wang on 6/11/23.
//

import SwiftUI

struct RecipeListView: View {
    typealias Recipe = RecipeStore.Recipe
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    var body: some View {
        List {
            ForEach($storeVM.recipeStore.recipes) { recipe in
                NavigationLink(value: recipe.id) {
                    Text(recipe.name.wrappedValue)
                }
            }
        }
        .animation(.linear, value: storeVM.recipeStore.recipes)
        .navigationDestination(for: Recipe.ID.self) { recipeId in
            if let index = storeVM.recipeStore.recipes.firstIndex(where: { $0.id == recipeId }) {
                RecipeView(recipe: storeVM.recipeStore.recipes[index], isDecorated: storeVM.isDecorated, themeColor: storeVM.themeColor)
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
    }
}
