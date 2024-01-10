//
//  RecipesApp.swift
//  Recipes
//
//  Created by Yuan Wang on 5/31/23.
//

import SwiftUI

@main
struct RecipesApp: App {
    @StateObject var storeVM = RecipeStoreViewModel(listsNamed: "Lists")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeVM)
        }
    }
}
