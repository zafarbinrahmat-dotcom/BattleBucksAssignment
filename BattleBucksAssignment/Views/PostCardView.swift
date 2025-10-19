//
//  PostCardView.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    @ObservedObject var viewModel: PostViewModel
    var showFavoriteBadge: Bool = false
    var onFavoriteTapped: (() -> Void)? = nil
    var showRemoveOption: Bool = false
    
    @State private var isAnimating = false
    
    private var isFavorite: Bool {
        viewModel.isFavorite(post.id ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            postInfoView
            titleView
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(
            color: Color.black.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 1)
        )
        .scaleEffect(isAnimating ? 1.0 : 0.95)
        .opacity(isAnimating ? 1.0 : 0.8)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            if showFavoriteBadge {
                favoriteBadgeView
            }
            Spacer()
        }
    }
    
    private var favoriteBadgeView: some View {
        HStack(spacing: 6) {
            Image(systemName: "heart.fill")
                .font(.system(size: 12))
                .foregroundColor(.red)
            
            Text("FAVORITE")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.red)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.red.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var favoriteButtonView: some View {
        Button(action: {
            toggleFavorite()
        }) {
            Group {
                if showRemoveOption {
                    Image(systemName: "heart.slash.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                } else {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(isFavorite ? .red : .gray)
                        .scaleEffect(isFavorite ? 1.2 : 1.0)
                }
            }
            .padding(6)
            .background(buttonBackgroundColor)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var postInfoView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("User ID: \(post.userId ?? 0)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Spacer()
            
            favoriteButtonView
        }
    }
    
    private var titleView: some View {
        HStack(spacing: 8) {
            Text(post.title ?? "")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
    }
    
    private var borderColor: Color {
        showFavoriteBadge ? Color.red.opacity(0.3) : Color.clear
    }
    
    private var buttonBackgroundColor: Color {
        if showRemoveOption {
            return Color.red.opacity(0.1)
        } else {
            return isFavorite ? Color.red.opacity(0.1) : Color.gray.opacity(0.1)
        }
    }
    
    
    private func toggleFavorite() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            if let customAction = onFavoriteTapped {
                customAction()
            } else {
                viewModel.toggleFavorite(for: post.id ?? 0)
            }
        }
    }
}


extension PostCardView {
    
    static func forPostList(post: Post, viewModel: PostViewModel) -> PostCardView {
        PostCardView(
            post: post,
            viewModel: viewModel,
            showFavoriteBadge: false,
            showRemoveOption: false
        )
    }
    
    static func forFavorites(post: Post, viewModel: PostViewModel) -> PostCardView {
        PostCardView(
            post: post,
            viewModel: viewModel,
            showFavoriteBadge: true,
            showRemoveOption: true
        )
    }
}

//#Preview {
//    PostCardView()
//}
