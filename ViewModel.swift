//
//  ViewModel.swift
//  Recipes
//
//  Created by Yuan Wang on 6/1/23.
//

import Foundation

extension UserDefaults {
    func recipeLists(forKey key: String) -> [RecipeList] {
        if let jsonData = data(forKey: key),
           let decodedLists = try? JSONDecoder().decode([RecipeList].self, from: jsonData) {
            return decodedLists
        } else {
            return []
        }
    }
    func set(_ recipeLists: [RecipeList], forKey key: String) {
        let data = try? JSONEncoder().encode(recipeLists)
        set(data, forKey: key)
    }
}

class RecipeStoreViewModel: ObservableObject {
    typealias Recipe = RecipeStore.Recipe

    let name: String
    var id: String { name }

    private var userDefaultKey: String { "RecipeLists:" + name }
    
    // using UserDefaults to store RecipeLists
    var recipeLists: [RecipeList] {
        get {
            UserDefaults.standard.recipeLists(forKey: userDefaultKey)
        } set {
            UserDefaults.standard.set(newValue, forKey: userDefaultKey)
            objectWillChange.send()
        }
    }

    // using filesystem to store recipeStore
    @Published var recipeStore = RecipeStore() {
        didSet {
            autosave()
        }
    }
    @Published var isDecorated = true
    @Published var themeColor = RGBA(color: .teal)

    private let autosaveURL: URL = URL.documentsDirectory.appendingPathComponent("Autosaved.recipestore")

    private func autosave() {
        save(to: autosaveURL)
        print("autosaved to \(autosaveURL)")
    }

    private func save(to url: URL) {
        do {
            let data = try recipeStore.json()
            try data.write(to: url)
        } catch let error {
            print("RecipeStoreViewModel: error while saving \(error.localizedDescription)")
        }
    }

    init(listsNamed name: String) {
        self.name = name
        if let data = try? Data(contentsOf: autosaveURL),
           let autosavedRecipeStore = try? RecipeStore(json: data) {
            recipeStore = autosavedRecipeStore
        }
    }
    
    // special init for RecipeListRecipesView preview of Watch App
    init(listsNamed name: String, preview: Bool) {
        self.name = name
        if let data = try? Data(contentsOf: autosaveURL),
           let autosavedRecipeStore = try? RecipeStore(json: data) {
            recipeStore = autosavedRecipeStore
        }
        if preview == true {
            self.insertRecipeList(RecipeList())
        }
    }
    
    func recipesInList(index: Int) -> [Recipe] {
        if index >= recipeLists.count {
            return []
        }
        let recipeIds = recipeLists[index].recipeIds
        if recipeIds.count > 0 {
            return recipeIds.map {
                recipeStore.recipeWithId($0) ?? Recipe()
            }
        } else {
            return []
        }
    }

    func recipesNotInList(index: Int) -> [Recipe] {
        if index >= recipeLists.count {
            return recipeStore.recipes
        }
        let recipeIds = recipeLists[index].recipeIds
        let allRecipeIds = recipeStore.recipes.map { $0.id }
        let recipeIdsComplement = allRecipeIds.filter { !recipeIds.contains($0) }
        return recipeIdsComplement.map {
            recipeStore.recipeWithId($0)!
        }
    }

    // MARK: - Intent(s)
    func insertRecipe(_ recipe: Recipe) {
        recipeStore.recipes.append(recipe)
    }
    
    func insertRecipeList(_ recipeList: RecipeList) {
        recipeLists.append(recipeList)
    }
    
    // when a recipe gets deleted, the this function is used to update the lists
    func removeDeletedRecipesFromLists() {
        for i in 0..<recipeLists.count {
            recipeLists[i].recipeIds = recipeLists[i].recipeIds.filter {
                recipeStore.recipes.map { $0.id }.contains($0)
            }
        }
    }
    
    func sortRecipes() {
        recipeStore.recipes = recipeStore.recipes.sorted()
    }

    func randOrderRecipes() {
        recipeStore.recipes = recipeStore.recipes.shuffled()
    }
    
    func sortRecipesInList(_ listIndex: Int) {
        if listIndex < recipeLists.count && listIndex >= 0 {
            recipeLists[listIndex].recipeIds = recipeLists[listIndex].recipeIds.sorted() {
                recipeStore.recipeWithId($0)!.name < recipeStore.recipeWithId($1)!.name
            }
        }
    }

    func randOrderRecipesInList(_ listIndex: Int) {
        if listIndex < recipeLists.count && listIndex >= 0 {
            recipeLists[listIndex].recipeIds = recipeLists[listIndex].recipeIds.shuffled()
        }
    }

}

extension RecipeStore.Recipe {
    var timeHrMin: String {
        String(self.timeHr) + " Hr " + String(self.timeMin) + " Min"
    }
}

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        return dateFormatter.string(from: self)
    }
}

extension UUID: Comparable {
    public static func < (lhs: UUID, rhs: UUID) -> Bool {
        return lhs.uuidString == rhs.uuidString
    }
}
