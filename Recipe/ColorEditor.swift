//
//  ColorEditor.swift
//  Recipes
//
//  Created by Yuan Wang on 6/10/23.
//

import SwiftUI

struct ColorEditor: View {
    @Binding var themeColor: RGBA
    @Binding var isDecorated: Bool
    @State var color: Color

    init(themeColor: Binding<RGBA>, isDecorated: Binding<Bool>) {
        self._themeColor = themeColor
        self._isDecorated = isDecorated
        color = Color(rgba: themeColor.wrappedValue)
    }
    
    var body: some View {
        Form {
            Section() {
                Toggle(isOn: $isDecorated) {
                    Text("Use color")
                }
                ColorPicker(selection: $color) {
                    Text("Pick a color for All Recipes")
                }
                .onChange(of: color) { color in
                    themeColor = RGBA(color: color)
                }
            }
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State private var themeColor = RGBA(color: .teal)
        @State private var isDecorated = true

        var body: some View {
            ColorEditor(themeColor: $themeColor, isDecorated: $isDecorated)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
