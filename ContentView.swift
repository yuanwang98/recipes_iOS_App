//
//  ContentView.swift
//  Recipes
//
//  Created by Yuan Wang on 5/31/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    @State private var selection: Tab = .recipe

    enum Tab {
        case recipe
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            RecipeMasterView()
                .tabItem {
                    Label("All Recipes", systemImage: "frying.pan")
                }
                .tag(Tab.recipe)
            
            RecipeListMasterView()
                .tabItem {
                    Label("Lists", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
    }
}
