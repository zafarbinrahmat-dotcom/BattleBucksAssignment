//
//  FavouritePostView.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import SwiftUI

struct FavouritePostsView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.getFavoritePosts().isEmpty {
                    EmptyFavoritesView()
                } else {
                    FavoritePostsContentView(
                        favoritePosts: viewModel.getFavoritePosts(),
                        viewModel: viewModel
                    )
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


private struct FavoritePostsContentView: View {
    let favoritePosts: [Post]
    let viewModel: PostViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(favoritePosts) { post in
                    NavigationLink(destination: PostDetailView(post: post, viewModel: viewModel)) {
                        PostCardView.forFavorites(post: post, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}


private struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 12) {
                Text("No Favorite Posts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Posts you mark as favorite will appear here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                    Text("Tap the heart icon on any post")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.blue)
                    Text("Go to the Posts tab to browse")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}


//#Preview {
//    FavouritePostsView()
//}
