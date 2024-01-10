//
//  StepByStepView.swift
//  Recipes
//
//  Created by Yuan Wang on 6/7/23.
//

import SwiftUI

struct StepByStepView: View {
    typealias Recipe = RecipeStore.Recipe
    var recipe: Recipe
    var isDecorated: Bool
    var themeColor: RGBA

    @State private var instructionIndex = 0
    @State private var transitionUp = true
    
    private struct Constants {
        static let progressMarkerWidth: CGFloat = 30
        static let progressMarkerCR: CGFloat = 10
        static let nextShapeLength: CGFloat = 25
        static let animationDuration = 0.5
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                prevButton
                Spacer()
                Text("Step \(instructionIndex + 1): " + recipe.instructions[instructionIndex].content)
                    .padding()
                    .id(recipe.instructions[instructionIndex].id)
                    .transition(.asymmetric(insertion: .move(edge: transitionUp ? .bottom : .top), removal: .opacity))
                Spacer()
                nextButton
            }
            .padding(5)
            .clipped()
            progressBar
            Spacer()
        }
    }
    
    var prevButton: some View {
        Button {
            withAnimation(.linear(duration: Constants.animationDuration)) {
                transitionUp = false
                if instructionIndex > 0 {
                    instructionIndex -= 1
                }
            }
        } label: {
            NextShape()
                .foregroundColor(isDecorated ? Color(rgba: themeColor) : .black)
                .frame(width: Constants.nextShapeLength, height: Constants.nextShapeLength)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
    }
    
    var nextButton: some View {
        Button {
            withAnimation(.linear(duration: Constants.animationDuration)) {
                transitionUp = true
                if instructionIndex < (recipe.instructions.count - 1) {
                    instructionIndex += 1
                }
            }
        } label: {
            NextShape()
                .foregroundColor(isDecorated ? Color(rgba: themeColor) : .black)
                .frame(width: Constants.nextShapeLength, height: Constants.nextShapeLength)
        }
    }
    
    var progressBar: some View {
        GeometryReader { geometry in
            var progressBarOffset: Double {
                (Double(geometry.size.width) - Constants.progressMarkerWidth) / Double(recipe.instructions.count - 1) * Double(instructionIndex)
            }
            ZStack {
                RoundedRectangle(cornerRadius: Constants.progressMarkerCR)
                    .stroke()
                    .frame(height: Constants.progressMarkerWidth / 2)
                RoundedRectangle(cornerRadius: Constants.progressMarkerCR)
                    .fill(isDecorated ? Color(rgba: themeColor) : .black)
                    .frame(width: Constants.progressMarkerWidth)
                    .offset(x: CGFloat(progressBarOffset) - geometry.size.width / 2 + Constants.progressMarkerWidth / 2)
            }
        }
        .frame(maxHeight: Constants.progressMarkerWidth)
        .padding(5)
    }
}

struct StepByStepView_Previews: PreviewProvider {
    static var previews: some View {
        StepByStepView(recipe: RecipeStore.Recipe(), isDecorated: true, themeColor: RGBA(color: .teal))
    }
}
