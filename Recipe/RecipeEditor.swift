//
//  RecipeEditor.swift
//  Recipes
//
//  Created by Yuan Wang on 6/6/23.
//
//  Citing https://swiftsenpai.com/development/swiftui-photos-picker/ as a helpful source that I used to develop the code for implementing the photospicker functionality in this script
//  Used EnvironmentObject instead of binding to particular recipe due to a weird bug that I wasn't able to resolve. The TextField cursor keeps jumping to the end immediately after an edit is made.

import SwiftUI
import PhotosUI

struct RecipeEditor: View {
    typealias IdString = RecipeStore.IdString
    typealias Recipe = RecipeStore.Recipe
    typealias Post = RecipeStore.Post
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    var editRecipeIndex: Int
    @State private var showPostEditor = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $storeVM.recipeStore.recipes[editRecipeIndex].name)
            }
            Section(header: Text("Image")){
                HStack{
                    Spacer()
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                // Retrive selected photo in the form of Data
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    storeVM.recipeStore.recipes[editRecipeIndex].image = data
                                }
                            }
                        }
                    Spacer()
                }
                if let recipeImage = storeVM.recipeStore.recipes[editRecipeIndex].image,
                   let uiImage = UIImage(data: recipeImage) {
                    HStack {
                        Spacer()
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .onLongPressGesture {
                                showDeleteAlert = true
                            }
                            .popover(isPresented: $showDeleteAlert) {
                                VStack {
                                    Text("Delete this image?")
                                    HStack {
                                        Button("Delete", role: .destructive) {
                                            storeVM.recipeStore.recipes[editRecipeIndex].image = nil
                                        }
                                        Button("Cancel", role: .cancel) { }
                                    }
                                }
                            }
                        Spacer()
                    }
                }
            }
            Section(header: Text("Note")) {
                TextField("Note", text: $storeVM.recipeStore.recipes[editRecipeIndex].note)
            }
            Section(header: Text("Cuisine")) {
                TextField("Cuisine", text: $storeVM.recipeStore.recipes[editRecipeIndex].cuisine)
            }
            Picker(selection: $storeVM.recipeStore.recipes[editRecipeIndex].timeMinute,
                   label: Text("Minutes to cook"))
            {
                ForEach(1...360, id: \.self) { min in
                    Text("\(min)").tag(min)
                }
            }
            Stepper(value: $storeVM.recipeStore.recipes[editRecipeIndex].yield, in: 1...20,
                    step: 1) {
                Text("Servings Yield: \(storeVM.recipeStore.recipes[editRecipeIndex].yield)")
            }
            Section(header: Text("Ingredients")) {
                ForEach($storeVM.recipeStore.recipes[editRecipeIndex].ingredients,
                        editActions: [.delete, .move]) { ingredient in
                    TextField("Ingredient", text: ingredient.content)
                }
                Button {
                    storeVM.recipeStore.recipes[editRecipeIndex].ingredients.append(IdString("Ingredient"))
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            Section(header: Text("Instructions")) {
                ForEach($storeVM.recipeStore.recipes[editRecipeIndex].instructions,
                        editActions: [.delete, .move]) { instruction in
                    TextField("Instruction", text: instruction.content)
                }
                Button {
                    storeVM.recipeStore.recipes[editRecipeIndex].instructions.append(IdString("Instruction"))
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            Section(header: Text("Posts")) {
                ForEach($storeVM.recipeStore.recipes[editRecipeIndex].posts, id:\.self, editActions: .delete) { post in
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("Rating: " + String(post.wrappedValue.rating.rawValue) + " / 5")
                            Spacer()
                            Text(post.wrappedValue.date.toString)
                        }
                        HStack {
                            Text(post.wrappedValue.text)
                                .padding(.bottom, 15)
                            Spacer()
                        }
                    }
                }
                Button {
                    storeVM.recipeStore.recipes[editRecipeIndex].posts.append(Post())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showPostEditor = true
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showPostEditor) {
            PostEditor(post: $storeVM.recipeStore.recipes[editRecipeIndex].posts.last!)
        }
    }
}

struct RecipeEditor_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            RecipeEditor(editRecipeIndex: 0)
        }
    }
    
    static var previews: some View {
        Preview()
            .environmentObject(RecipeStoreViewModel(listsNamed: "lists"))
    }
}
