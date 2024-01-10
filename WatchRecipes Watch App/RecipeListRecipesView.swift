//
//  ListRecipesView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/14/23.
//

import SwiftUI

struct RecipeListRecipesView: View {
    typealias Recipe = RecipeStore.Recipe
    @EnvironmentObject var storeVM: RecipeStoreViewModel

    var selectedRecipeListIndex: Int
    
    var selectedRecipeListIndexBoundsCheck: Int {
        if selectedRecipeListIndex >= storeVM.recipeLists.count {
            return 0
        } else {
            return selectedRecipeListIndex
        }
    }
    
    var selectedRecipeListId: Date {
        return storeVM.recipeLists[selectedRecipeListIndexBoundsCheck].id
    }
    
    var recipesInList: [Recipe] {
        var recipes: [Recipe] = []
        for recipeId in storeVM.recipeLists[selectedRecipeListIndexBoundsCheck].recipeIds {
            recipes += storeVM.recipeStore.recipes.filter {
                $0.id == recipeId
            }
        }
        return recipes
    }
    
    var body: some View {
        List {
            ForEach(recipesInList) { recipe in
                NavigationLink(value: recipe.id) {
                    Text(recipe.name)
                }
            }
        }
        .navigationDestination(for: Recipe.ID.self) { recipeId in
            if let index = storeVM.recipeStore.recipes.firstIndex(where: { $0.id == recipeId }) {
                RecipeView(recipe: storeVM.recipeStore.recipes[index], isDecorated: storeVM.isDecorated, themeColor: storeVM.recipeLists[selectedRecipeListIndex].color)
            }
        }
    }
}

struct RecipeListRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListRecipesView(selectedRecipeListIndex: 0)
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists", preview: true))
    }
}
