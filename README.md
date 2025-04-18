# BentoStack
![Screenshot 2025-04-18 at 12 32 20](https://github.com/user-attachments/assets/9a22ce81-333a-4520-a96c-4bc1109d8a7b)
## Overview
BentoStack is a SwiftUI library for creating flexible, grid-based layouts inspired by Japanese bento boxes. Unlike traditional grids, it handles elements of varying sizes, ensuring space-efficient, gapless, and visually appealing layouts.

https://github.com/user-attachments/assets/1f41f9dc-9a01-41b3-9002-7a72b44c22fb

## Installation

### Swift Package Manager

Add it directly in Xcode:

    1. Navigate to File > Swift Packages > Add Package Dependency.

    2. Enter the package URL: https://github.com/SwiftTyper/BentoStack.git.
    
    3. Follow the prompts to complete the setup.
    
### Usage

Import the package and use BStack in your SwiftUI views:
```swift
import BentoStack

struct ContentView: View {
    var body: some View {
        BStack {
            //content
        }
    }
}
```
## Why?
This library was born from an approach I explored while developing the [Bentoit](https://github.com/SwiftTyper/WWDC_2025) app.
