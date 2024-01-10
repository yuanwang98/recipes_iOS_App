//
//  ListRecipesView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/6/23.
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
    
    // the function ensures that the recipes from a RecipeList are in the proper order
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
                    RecipeListItemView(recipe: recipe)
                }
            }
        }
        .animation(.linear, value: storeVM.recipeLists[selectedRecipeListIndex].recipeIds)
        .background(Color(rgba: storeVM.recipeLists[selectedRecipeListIndex].color))
        .scrollContentBackground(storeVM.isDecorated ? .hidden : .visible)
        .navigationDestination(for: Recipe.ID.self) { recipeId in
            if let index = storeVM.recipeStore.recipes.firstIndex(where: { $0.id == recipeId }) {
                RecipeView(recipe: storeVM.recipeStore.recipes[index],
                           isDecorated: storeVM.isDecorated,
                           themeColor: storeVM.recipeLists[selectedRecipeListIndex].color)
            }
        }
        .toolbar {
            sortButton
            randomButton
        }
    }
    
    var sortButton: some View {
        Button {
            storeVM.sortRecipesInList(selectedRecipeListIndex)
        } label: {
            Image(systemName: "arrow.2.squarepath")
        }
    }
    
    var randomButton: some View {
        Button {
            storeVM.randOrderRecipesInList(selectedRecipeListIndex)
        } label: {
            Image(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
        }
    }
}

struct RecipeListRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListRecipesView(selectedRecipeListIndex: 0)
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
    }
}
