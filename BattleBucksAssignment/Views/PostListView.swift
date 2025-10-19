//
//  PostListView.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import Foundation
import SwiftUI

struct PostListView: View {
    @ObservedObject var viewModel: PostViewModel
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchFieldView(searchText: $viewModel.searchText)
                
                Group {
                    if viewModel.isLoading {
                        LoadingView()
                    } else if viewModel.posts.isEmpty && viewModel.errorMessage != nil {
                        ErrorView(
                            errorMessage: viewModel.errorMessage,
                            onRetry: { viewModel.fetchPosts() }
                        )
                    } else if viewModel.filteredPosts.isEmpty && !viewModel.searchText.isEmpty {
                        EmptySearchView()
                    } else {
                        PostListContentView(
                            posts: viewModel.filteredPosts,
                            viewModel: viewModel,
                            onRefresh: { viewModel.refreshPosts() }
                        )
                    }
                }
            }
            .navigationTitle("Posts")
            .alert("Error", isPresented: $showingError) {
                Button("Retry") { viewModel.fetchPosts() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
            .onChange(of: viewModel.errorMessage) { error in
                showingError = error != nil
            }
        }
        .onAppear {
            if viewModel.posts.isEmpty {
                viewModel.fetchPosts()
            }
        }
    }
}

// MARK: - Subviews

private struct SearchFieldView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            
            TextField("Search posts by title...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

private struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            VStack(spacing: 8) {
                Text("Loading Posts")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Fetching data from JSONPlaceholder API")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ErrorView: View {
    let errorMessage: String?
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("Failed to Load Posts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(errorMessage ?? "Unknown error occurred")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(.horizontal)
            
            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("No Posts Found")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Try adjusting your search terms")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct PostListContentView: View {
    let posts: [Post]
    let viewModel: PostViewModel
    let onRefresh: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(posts) { post in
                    NavigationLink(destination: PostDetailView(post: post, viewModel: viewModel)) {
                        PostCardView.forPostList(post: post, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .refreshable {
            onRefresh()
        }
    }
}
