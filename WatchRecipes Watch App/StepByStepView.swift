//
//  StepByStepView.swift
//  WatchRecipes Watch App
//
//  Created by Yuan Wang on 6/11/23.
//

import SwiftUI

struct StepByStepView: View {
    typealias Recipe = RecipeStore.Recipe
    var recipe: Recipe
    var isDecorated: Bool
    var themeColor: RGBA

    @State private var instructionIndex = 0
    
    private struct Constants {
        static let progressMarkerWidth: CGFloat = 30
        static let nextShapeLength: CGFloat = 15
    }
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                Text("Step \(instructionIndex + 1): " + recipe.instructions[instructionIndex].content)
                    .padding()
            }
            HStack {
                prevButton
                Spacer()
                nextButton
            }
            .padding(5)
            .clipped()
            progressBar
                .animation(.linear(duration: 0.5), value: instructionIndex)
            Spacer()
        }
    }
    
    var prevButton: some View {
        Button {
            if instructionIndex > 0 {
                instructionIndex -= 1
            }
        } label: {
            NextShape()
                .foregroundColor(isDecorated ? Color(rgba: themeColor) : .black)
                .frame(width: Constants.nextShapeLength, height: Constants.nextShapeLength)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: Constants.nextShapeLength * 2, height: Constants.nextShapeLength * 2)
    }
    
    var nextButton: some View {
        Button {
            if instructionIndex < (recipe.instructions.count - 1) {
                instructionIndex += 1
            }
        } label: {
            NextShape()
                .foregroundColor(isDecorated ? Color(rgba: themeColor) : .black)
                .frame(width: Constants.nextShapeLength, height: Constants.nextShapeLength)
        }
        .frame(width: Constants.nextShapeLength * 2, height: Constants.nextShapeLength * 2)
    }
    
    var progressBar: some View {
        GeometryReader { geometry in
            var progressBarOffset: Double {
                (Double(geometry.size.width) - Constants.progressMarkerWidth) / Double(recipe.instructions.count - 1) * Double(instructionIndex)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .frame(height: Constants.progressMarkerWidth / 2)
                RoundedRectangle(cornerRadius: 10)
                    .fill(isDecorated ? Color(rgba: themeColor) : .black)
                    .frame(width: Constants.progressMarkerWidth)
                    .offset(x: CGFloat(progressBarOffset) - geometry.size.width / 2 + Constants.progressMarkerWidth / 2)
            }
        }
        .frame(maxHeight: 30)
        .padding(5)
    }
}

struct StepByStepView_Previews: PreviewProvider {
    static var previews: some View {
        StepByStepView(recipe: RecipeStore.Recipe(), isDecorated: true, themeColor: RGBA(color: .teal))
    }
}
