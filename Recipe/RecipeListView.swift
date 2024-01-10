//
//  RecipeListView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/5/23.
//

import SwiftUI

struct RecipeListView: View {
    typealias Recipe = RecipeStore.Recipe
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    @State private var showRecipeEditor = false
    @State private var editRecipeIndex = 0
    @State private var deleteIndexSet: IndexSet?
    @State private var showColorEditor = false

    var body: some View {
        recipesView
        .animation(.linear, value: storeVM.recipeStore.recipes)
        .background(Color(rgba: storeVM.themeColor))
        .scrollContentBackground(storeVM.isDecorated ? .hidden : .visible)
        .navigationDestination(for: Recipe.ID.self) { recipeId in
            if let index = storeVM.recipeStore.recipes.firstIndex(where: { $0.id == recipeId }) {
                RecipeView(recipe: storeVM.recipeStore.recipes[index], isDecorated: storeVM.isDecorated, themeColor: storeVM.themeColor)
            }
        }
        .sheet(isPresented: $showRecipeEditor) {
            RecipeEditor(editRecipeIndex: editRecipeIndex)
        }
        .sheet(isPresented: $showColorEditor) {
            ColorEditor(themeColor: $storeVM.themeColor, isDecorated: $storeVM.isDecorated)
        }
        .toolbar {
            sortButton
            randomButton
            showColorEditorButton
            insertRecipeButton
        }
    }
    
    var recipesView: some View {
        List {
            ForEach(storeVM.recipeStore.recipes) { recipe in
                NavigationLink(value: recipe.id) {
                    RecipeListItemView(recipe: recipe)
                }
                .swipeActions(edge: .leading) {
                    editButton(recipe)
                }
            }
            .onDelete() { indexSet in
                withAnimation {
                    storeVM.recipeStore.recipes.remove(atOffsets: indexSet)
                    storeVM.removeDeletedRecipesFromLists()
                }
            }
        }
    }
    
    var sortButton: some View {
        Button {
            storeVM.sortRecipes()
        } label: {
            Image(systemName: "arrow.2.squarepath")
        }
    }
    
    var randomButton: some View {
        Button {
            storeVM.randOrderRecipes()
        } label: {
            Image(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
        }
    }
    
    var showColorEditorButton: some View {
        Button {
            showColorEditor = true
        } label: {
            if storeVM.isDecorated {
                Image(systemName: "paintpalette.fill")
            } else {
                Image(systemName: "paintpalette")
            }
        }
    }
    
    var insertRecipeButton: some View {
        Button {
            storeVM.insertRecipe(Recipe())
            editRecipeIndex = storeVM.recipeStore.recipes.count - 1
            showRecipeEditor = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
    @ViewBuilder
    private func editButton(_ recipe: Recipe) -> some View {
        Button() {
            if let index = storeVM.recipeStore.recipes.firstIndex(where: { $0.id == recipe.id }) {
                editRecipeIndex = index
                showRecipeEditor = true
            }
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
    }
}
