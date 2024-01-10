//
//  PostEditor.swift
//  Recipes
//
//  Created by Yuan Wang on 6/6/23.
//

import SwiftUI

struct PostEditor: View {
    typealias Post = RecipeStore.Post
    typealias Rating = RecipeStore.Rating
    @Binding var post: Post

    var body: some View {
        VStack(alignment: .trailing) {
            Text($post.wrappedValue.date.toString)
                .padding(.bottom, 40)
            HStack {
                Text("Rating")
                Spacer()
            }
            .padding(.bottom, -20)
            Picker("Auto-Join Hotspot", selection: $post.rating) {
                ForEach(Rating.allCases) { rating in
                    Text(String(rating.rawValue))
                }
            }
            .pickerStyle(.wheel)
            HStack {
                TextField("Write Post", text: $post.text)
                    .padding(.bottom, 15)
                Spacer()
            }
        }
        .padding()
    }
}

struct PostEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State private var post = RecipeStore.Post()
        
        var body: some View {
            PostEditor(post: $post)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
