//
//  ContentView.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world! azafar")
        }
        .padding()
        .onAppear {
        }
    }
}

#Preview {
    ContentView()
}
