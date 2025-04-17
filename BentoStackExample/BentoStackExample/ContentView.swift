//
//  ContentView.swift
//  BentoStackExample
//
//  Created by Wit Owczarek on 17/04/2025.
//

import SwiftUI
import BentoStack

struct ContentView: View {
    @State private var items: [CGSize] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                BentoStack(horizontalSpacing: 100, verticalSpacing: 30) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Rectangle()
                            .fill(Color.blue.opacity(0.8).gradient.secondary)
                            .frame(
                                width: items[index].width,
                                height: items[index].height
                            )
                            .overlay {
                                Text("\(index)")
                                    .foregroundStyle(.primary)
                                    .fontWeight(.semibold)
                            }
                    }
                }
                .padding(.horizontal)
                .onAppear(perform: generateItems)
                .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Randomize", systemImage: "arrow.clockwise") {
                        generateItems()
                    }
                    
                    Button("Add", systemImage: "plus") {
                        addItem()
                    }
                }
                
            }
        }
    }
    
    func addItem() {
        let randomSize = CGSize(width: .random(in: 50..<250), height: .random(in: 50..<250))
        self.items.append(randomSize)
    }
    
    func generateItems() {
        var rects: [CGSize] = []
        for _ in 0..<50 {
            let width: CGFloat = .random(in: 50..<250)
            let height: CGFloat = .random(in: 50..<250)
            rects.append(.init(width: width, height: height))
        }
        self.items = rects
    }
}

#Preview {
    ContentView()
}
