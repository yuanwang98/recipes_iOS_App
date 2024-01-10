//
//  NextShape.swift
//  Recipes
//
//  Created by Yuan Wang on 6/7/23.
//

import SwiftUI
import CoreGraphics

// This is the icon with a rectangle and a triangle that forms what looks like a chubby arrow. This is used as a button in RecipeView to bring up
// StepByStepView, and it is used in  StepByStepView to toggle between recipe instructions
struct NextShape: Shape {
    func path(in rect: CGRect) -> Path {
        let len = rect.width / 4

        let start = CGPoint(x: rect.minX, y: rect.minY)
        let right = CGPoint(x: rect.minX + len, y: rect.minY)
        let down = CGPoint(x: rect.minX + len, y: rect.maxY)
        let left = CGPoint(x: rect.minX, y: rect.maxY)
        let next = CGPoint(x: rect.minX + len * 2, y: rect.minY)
        let downRight = CGPoint(x: rect.maxX, y: rect.midY)
        let downLeft = CGPoint(x: rect.minX + len * 2, y: rect.maxY)

        
        var p = Path()
        p.move(to: start)
        p.addLine(to: right)
        p.addLine(to: down)
        p.addLine(to: left)
        p.move(to: start)
        
        p.move(to: next)
        p.addLine(to: downRight)
        p.addLine(to: downLeft)
        return p
    }
}

struct NextShape_Previews: PreviewProvider {
    static var previews: some View {
        NextShape()
    }
}
