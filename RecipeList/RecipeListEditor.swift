//
//  RecipeListEditor.swift
//  Recipes
//
//  Created by Yuan Wang on 6/11/23.
//

import SwiftUI

struct RecipeListEditor: View {
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    var editListIndex: Int
    @State var recipeIdsToDelete: [UUID] = []
    @State var recipeIdsToAdd: [UUID] = []

    var body: some View {
        VStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $storeVM.recipeLists[editListIndex].name)
                    ColorPicker(selection: $storeVM.recipeLists[editListIndex].colorView) {
                        Text("Pick a color for this list")
                    }
                    .onChange(of: storeVM.recipeLists[editListIndex].colorView) { listColor in
                        storeVM.recipeLists[editListIndex].color = RGBA(color: listColor)
                    }
                }
                Section("Recipes in List") {
                    ForEach(storeVM.recipesInList(index: editListIndex)) { recipe in
                        HStack {
                            Text(recipe.name)
                            Spacer()
                            Image(systemName: "minus")
                                .foregroundColor(recipeIdsToDelete.contains(recipe.id) ? .red : .gray)
                                .onTapGesture {
                                    if let index = recipeIdsToDelete.firstIndex(of: recipe.id) {
                                        recipeIdsToDelete.remove(at: index)
                                    } else {
                                        recipeIdsToDelete.append(recipe.id)
                                    }
                                }
                        }
                    }
                }
                Section("Recipes not in List") {
                    ForEach(storeVM.recipesNotInList(index: editListIndex)) { recipe in
                        HStack {
                            Text(recipe.name)
                            Spacer()
                            Image(systemName: "plus")
                                .foregroundColor(recipeIdsToAdd.contains(recipe.id) ? .green : .gray)
                                .onTapGesture {
                                    if let index = recipeIdsToAdd.firstIndex(of: recipe.id) {
                                        recipeIdsToAdd.remove(at: index)
                                    } else {
                                        recipeIdsToAdd.append(recipe.id)
                                    }
                                }
                        }
                    }
                }
                Button {
                    storeVM.recipeLists[editListIndex].recipeIds = storeVM.recipeLists[editListIndex].recipeIds.filter {
                            !recipeIdsToDelete.contains($0)
                    }
                    storeVM.recipeLists[editListIndex].recipeIds += recipeIdsToAdd
                    recipeIdsToDelete = []
                    recipeIdsToAdd = []
                } label: {
                    Text("Confirm")
                }
            }
            .animation(.linear(duration: 0.25), value: storeVM.recipeLists[editListIndex].recipeIds)
        }
    }
}

struct RecipeListEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State private var editListIndex = 0
        @State private var isPresented = true
        
        var body: some View {
            RecipeListEditor(editListIndex: editListIndex)
                .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
