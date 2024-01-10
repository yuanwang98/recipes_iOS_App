//
//  ModelData.swift
//  Recipes
//
//  Created by Yuan Wang on 5/31/23.
//

import Foundation

struct RecipeStore: Codable {
    var recipes: Array<Recipe> = builtinRecipes
    
    func json() throws -> Data {
        let encoded = try JSONEncoder().encode(self)
        print("RecipeStore = \(String(data: encoded, encoding: .utf8) ?? "nil")")
        return encoded
    }

    init(json: Data) throws {
        self = try JSONDecoder().decode(RecipeStore.self, from: json)
    }
    
    init() {
        
    }
    
    func recipeWithId(_ recipeId: UUID) -> Recipe? {
        if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
            return recipes[index]
        }
        return nil
    }
    
    struct Recipe: Identifiable, Codable, Comparable {
        static func < (lhs: RecipeStore.Recipe, rhs: RecipeStore.Recipe) -> Bool {
            return lhs.name < rhs.name
        }
        
        static func == (lhs: RecipeStore.Recipe, rhs: RecipeStore.Recipe) -> Bool {
            return lhs.id == rhs.id
        }
        
        var name: String
        var image: Data? = nil
        var note: String
        var createdDate: Date
        var updatedDate: Date? = nil
        var timeMinute: Int
        var yield: Int
        var cuisine: String // user customizable
        var ingredients: Array<IdString>
        var instructions: Array<IdString>
        var posts: Array<Post>
        var id = UUID()
        
        init(name: String, note: String, createdDate: Date, timeMinute: Int, yield: Int, cuisine: String, ingredients: Array<IdString>, instructions: Array<IdString>, posts: Array<Post>) {
            self.name = name
            self.note = note
            self.createdDate = createdDate
            self.timeMinute = timeMinute
            self.yield = yield
            self.cuisine = cuisine
            self.ingredients = ingredients
            self.instructions = instructions
            self.posts = posts
        }
        
        init() {
            name = "Name"
            note = "Note"
            createdDate = Date()
            timeMinute = 1
            yield = 1
            cuisine = "Cuisine"
            ingredients = [IdString("Ingredient")]
            instructions = [IdString("Instruction 1"), IdString("Instruction 2")]
            posts = []
        }

        var avg_rating: Int? {
            posts.map {
                $0.rating.rawValue
            }.arr_avg()
        }
        
        var timeHr: Int {
            timeMinute / 60
        }
        var timeMin: Int {
            timeMinute % 60
        }
    }
    
    struct IdString: Identifiable, Codable {
        var content: String
        var id = UUID()
        
        init(_ content: String) {
            self.content = content
        }
    }
    
    struct Post: Hashable, Codable {
        let date: Date
        var text: String
        var rating: Rating
        
        init() {
            date = Date()
            text = "Post Text"
            rating = .three
        }
        
        init(date: Date, text: String, rating: Rating) {
            self.date = date
            self.text = text
            self.rating = rating
        }
    }
    
    enum Rating: Int, Codable, CaseIterable, Identifiable {
        case one = 1, two, three, four, five
        var id: Self { self }
    }
    
    static var builtinRecipes: Array<Recipe> {[
        Recipe(name: "Mapo Tofu",
               note: "This is a simple recipe.",
               createdDate: Date(timeIntervalSinceReferenceDate: 123456789.0),
               timeMinute: 60,
               yield: 2,
               cuisine: "Chinese",
               ingredients: [
                IdString("500g of Tofu"),
                IdString("200g of Pork")
               ],
               instructions: [
                IdString("Cut the Tofu."),
                IdString("Blanch the Tofu."),
                IdString("Cook the Pork."),
                IdString("Add in the Tofu.")
               ],
               posts: [
                Post(date: Date(timeIntervalSinceReferenceDate: 123456789.0), text: "Could use more seasoning.", rating: .three),
                Post(date: Date(timeIntervalSinceReferenceDate: 223456789.0), text: "It was tasty!", rating: .four)
               ]),
        Recipe(name: "Bolognese Pasta",
               note: "This is a easy, satisfying recipe.",
               createdDate: Date(timeIntervalSinceReferenceDate: 293456789.0),
               timeMinute: 120,
               yield: 5,
               cuisine: "Italian",
               ingredients: [
                IdString("300g of Beef"),
                IdString("50g of Pasta")
               ],
               instructions: [
                IdString("Make Bolognese sauce."),
                IdString("Cook pasta.")
               ],
               posts: [])
    ]}
}

extension Array<Int> {
    func arr_avg() -> Int? {
        if self.isEmpty {
            return nil
        }
        var sum = 0
        for i in 0 ..< self.count {
            sum += self[i]
        }
        return sum / self.count
    }
}
