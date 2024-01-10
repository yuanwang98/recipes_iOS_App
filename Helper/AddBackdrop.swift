//
//  AddBackdrop.swift
//  Recipes
//
//  Created by Yuan Wang on 6/10/23.
//

import SwiftUI

struct AddBackdrop: ViewModifier {
    init(isDecorated: Bool, themeColor: RGBA) {
        self.isDecorated = isDecorated
        self.themeColor = Color(rgba: themeColor)
    }
    
    var isDecorated: Bool
    var themeColor: Color
    
    func body(content: Content) -> some View {
        ZStack{
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            if isDecorated {
                content
                    .padding(Constants.padding)
                    .background(
                        base.fill(themeColor)
                            .opacity(Constants.opacity)
                    )
            } else {
                content
            }
        }
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
        static let padding: CGFloat = 5
        static let opacity: Double = 0.25
    }
}

extension View {
    func addBackdrop(isDecorated: Bool, themeColor: RGBA) -> some View {
        modifier(AddBackdrop(isDecorated: isDecorated, themeColor: themeColor))
    }
}
