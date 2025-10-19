//
//  PostDetailView.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import SwiftUI

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @ObservedObject var viewModel: PostViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isFavorite: Bool
    
    init(post: Post, viewModel: PostViewModel) {
        self.post = post
        self.viewModel = viewModel
        self._isFavorite = State(initialValue: viewModel.isFavorite(post.id ?? 0))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .center) {
                    HStack(spacing: 8) {
                        Text("User ID: ")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(post.userId ?? 0)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    FavoriteToggleButton(
                        isFavorite: $isFavorite,
                        onToggle: {
                            viewModel.toggleFavorite(for: post.id ?? 0)
                        }
                    )
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Title")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text(post.title ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Content")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text(post.body ?? "")
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.isFavorite(post.id ?? 0)) { newValue in
            isFavorite = newValue
        }
    }
}

struct FavoriteToggleButton: View {
    @Binding var isFavorite: Bool
    let onToggle: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                onToggle()
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isAnimating = false
                }
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .scaleEffect(isAnimating ? 1.3 : 1.0)
                
                Text(isFavorite ? "Favorited" : "Add to Favorites")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isFavorite ? .red : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isFavorite ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    PostDetailView()
//}
