# Recipes iOS App
An iOS App and Watch App for storing, viewing and editing recipes. Developed with Swift.

## Key Functionalities
### Recipes
The app allows users to create, view, and edit recipes. A recipe is composed of various associated data, including but not limited to name, ingredients, steps, image, and associated journals/notes.

### Recipe Step-by-Step View
For any recipe in the app, users are able to enter a step-by-step view, in which they are shown one step/instruction at a time, and they can toggle to either the previous or next instruction. They are also shown a progress bar showing how many steps they have completed v.s. yet to complete.

### Recipe Lists
The app allows users to create, view and edit recipe lists. A recipe can be in zero or more lists, and a list can contain zero or more recipes. Recipe Lists allow users to store a set of related recipes together for convenient access.

### iOS Watch App
The iOS Watch App has a similar UI design as the iOS App. It does not support creating and editing of recipes and recipe lists, but it supports all remaining functionalities. It is primarily useful for viewing recipe lists and recipes, as well as entering the step-by-step view for convenient access while users are actively cooking a recipe.

## Tech Stack
Swift, SwiftUI, Codable, PhotosUI, watchOS
