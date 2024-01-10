//
//  RecipeView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/1/23.
//

import SwiftUI

struct RecipeView: View {
    typealias Recipe = RecipeStore.Recipe
    
    private struct Constants {
        static let nextShapeLength: CGFloat = 60
        static let nextShapeDefaultColor: Color = .black
    }
    
    var recipe: Recipe
    var isDecorated: Bool
    var themeColor: RGBA
    
    @State private var showStepByStep = false
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(recipe.name)
                        .padding(10)
                        .font(.largeTitle)
                        .addBackdrop(isDecorated: isDecorated, themeColor: themeColor)
                    Spacer()
                    Button {
                        if recipe.instructions.count > 0 {
                            showStepByStep = true
                        }
                    } label: {
                        ZStack {
                            NextShape()
                                .foregroundColor(isDecorated ? Color(rgba: themeColor) : Constants.nextShapeDefaultColor)
                        }
                            .frame(width: Constants.nextShapeLength, height: Constants.nextShapeLength)
                    }
                }
                if let recipeImage = recipe.image,
                   let uiImage = UIImage(data: recipeImage) {
                    HStack {
                        Spacer()
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                        Spacer()
                    }
                }
                Text(recipe.note)
                    .monospaced()
                smallInfoBox
                largeInfoBox
                    .addBackdrop(isDecorated: isDecorated, themeColor: themeColor)
                ingredientsView
                instructionsView
                    .addBackdrop(isDecorated: isDecorated, themeColor: themeColor)
                postsView
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showStepByStep) {
            StepByStepView(recipe: recipe, isDecorated: isDecorated, themeColor: themeColor)
        }
    }
    
    var smallInfoBox: some View {
        HStack {
            Text(recipe.cuisine)
                .padding(5)
                .addBackdrop(isDecorated: isDecorated, themeColor: themeColor)
            Divider()
                .frame(height: 20)
            Text(String(recipe.posts.count) + (recipe.posts.count <= 1 ? " post": " posts"))
            Divider()
                .frame(height: 20)
            if let rating = recipe.avg_rating {
                Text("Rating: " + String(rating) + " / 5")
            } else {
                Text("Rating: N/A")
            }
        }
        .padding(5)
    }
    
    var largeInfoBox: some View {
        HStack {
            Text("Time to Cook:\t\n" + recipe.timeHrMin)
            Divider()
                .frame(height: 40)
            Text("Servings Yield:\n" + String(recipe.yield))
        }
        .padding(15)
    }
    
    var ingredientsView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Ingredients")
                    .font(.title)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 1)
            ForEach(recipe.ingredients) { ingredient in
                Text("- " + ingredient.content)
            }
        }
        .padding(.bottom, 30)
    }
    
    var instructionsView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Instructions")
                    .font(.title)
                Spacer()
            }
            .padding(.top, 20)
            ForEach(recipe.instructions.indices, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text("Step " + String(index + 1))
                        .bold()
                    Text(recipe.instructions[index].content)
                }
                .padding(.top, 5)
            }
        }
        .padding([.leading, .bottom], 15)
    }
    
    var postsView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Posts")
                    .font(.title)
                Spacer()
            }
            ForEach(recipe.posts, id: \.self) { post in
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Rating: " + String(post.rating.rawValue) + " / 5")
                        Spacer()
                        Text(post.date.toString)
                    }
                    HStack {
                        Text(post.text)
                            .padding(.bottom, 15)
                        Spacer()
                    }
                }
            }
            .padding(.top, 5)
        }
        .padding(.top, 30)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: RecipeStore.builtinRecipes[0], isDecorated: true, themeColor: RGBA(color: .teal))
    }
}
