//
//  ListListView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/14/23.
//

import SwiftUI

struct RecipeListListView: View {
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    @State private var showListEditor = false
    @State private var editListIndex = 0
    
    var body: some View {
        recipeListView
        .navigationDestination(for: RecipeList.ID.self) { listId in
            if let index = storeVM.recipeLists.firstIndex(where: { $0.id == listId }) {
                RecipeListRecipesView(selectedRecipeListIndex: index)
            }
        }
        .sheet(isPresented: $showListEditor) {
            RecipeListEditor(editListIndex: editListIndex)
        }
        .toolbar {
            Button {
                storeVM.insertRecipeList(RecipeList())
                editListIndex = storeVM.recipeLists.count - 1
                showListEditor = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    var recipeListView: some View {
        List {
            ForEach(storeVM.recipeLists) { recipeList in
                NavigationLink(value: recipeList.id) {
                    Text(recipeList.name)
                }
                .swipeActions(edge: .leading) {
                    editButton(recipeList)
                }
            }
            .onDelete() { indexSet in
                withAnimation {
                    storeVM.recipeLists.remove(atOffsets: indexSet)
                }
            }
        }
    }
    
    @ViewBuilder
    private func editButton(_ recipeList: RecipeList) -> some View {
        Button() {
            if let index = storeVM.recipeLists.firstIndex(where: { $0.id == recipeList.id }) {
                editListIndex = index
                showListEditor = true
            }
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
}

struct RecipeListListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListListView()
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
    }
}
