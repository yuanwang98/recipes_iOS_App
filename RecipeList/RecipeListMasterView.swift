//
//  ListMasterView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/6/23.
//

import SwiftUI

struct RecipeListMasterView: View {
    @EnvironmentObject var storeVM: RecipeStoreViewModel
    
    var body: some View {
        NavigationStack {
            RecipeListListView()
        }
    }
}

struct RecipeListMasterView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListMasterView()
            .environmentObject(RecipeStoreViewModel(listsNamed: "Lists"))
    }
}
