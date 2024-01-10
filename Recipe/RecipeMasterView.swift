//
//  RecipeMasterView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/6/23.
//

import SwiftUI

struct RecipeMasterView: View {
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    var body: some View {
        NavigationStack {
            RecipeListView()
        }
    }
}

struct RecipeMasterView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeMasterView()
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
    }
}
