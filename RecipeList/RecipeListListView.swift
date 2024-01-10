//
//  ListListView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/6/23.
//

import SwiftUI

struct RecipeListListView: View {
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    @State private var showListEditor = false
    @State private var editListIndex = 0
    @State private var showColorEditor = false

    var body: some View {
        recipeListView
        .background(Color(rgba: storeVM.themeColor))
        .scrollContentBackground(storeVM.isDecorated ? .hidden : .visible)
        .navigationDestination(for: RecipeList.ID.self) { listId in
            if let index = storeVM.recipeLists.firstIndex(where: { $0.id == listId }) {
                RecipeListRecipesView(selectedRecipeListIndex: index)
            }
        }
        .sheet(isPresented: $showListEditor) {
            RecipeListEditor(editListIndex: editListIndex)
        }
        .sheet(isPresented: $showColorEditor) {
            ColorEditor(themeColor: $storeVM.themeColor, isDecorated: $storeVM.isDecorated)
        }
        .toolbar {
            showColorEditorButton
            addRecipeListButton
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
    
    var addRecipeListButton: some View {
        Button {
            storeVM.insertRecipeList(RecipeList())
            editListIndex = storeVM.recipeLists.count - 1
            showListEditor = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
    @ViewBuilder
    private func editButton(_ recipeList: RecipeList) -> some View {
        Button() {
            if let index = storeVM.recipeLists.firstIndex(where: { $0.id == recipeList.id }) {
                print("index: \(index)")
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
