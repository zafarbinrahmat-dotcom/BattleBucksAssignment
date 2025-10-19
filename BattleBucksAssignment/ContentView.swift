//
//  ContentView.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        TabView {
            PostListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Posts")
                }
            
            FavouritePostsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
