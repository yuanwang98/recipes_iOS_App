//
//  Cuisines.swift
//  Recipes
//
//  Created by Yuan Wang on 6/3/23.
//

import Foundation


struct RecipeList: Codable, Hashable, Identifiable {
    var name: String
    var color: RGBA
    var id = Date()
    var recipeIds: Array<UUID> = []
    
    init() {
        name = "List Name"
        color = RGBA(color: .teal)
    }
    
    init(name: String, color: RGBA) {
        self.name = name
        self.color = color
    }
}
