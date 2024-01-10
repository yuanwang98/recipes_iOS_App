//
//  RecipeListItemView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/9/23.
//

import SwiftUI

struct RecipeListItemView: View {
    typealias Recipe = RecipeStore.Recipe
    var recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
            HStack {
                Text(recipe.cuisine)
                if let rating = recipe.avg_rating {
                    Text("Rating: " + String(rating) + "/5")
                }
                Spacer()
            }
            .font(.caption)
        }
    }
}

struct RecipeListItemView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var recipe = RecipeStore.Recipe()
        @State private var showRecipeEditor = false

        var body: some View {
            RecipeListItemView(recipe: RecipeStore.Recipe())
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
