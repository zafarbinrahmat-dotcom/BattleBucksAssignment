//
//  PostViewModel.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import Foundation
import Combine

final class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var filteredPosts: [Post] = []
    @Published var favoritePosts: Set<Int> = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: APIManager
    
    // MARK: - Init
    init(networkService: APIManager = .shared) {
        self.networkService = networkService
        setupSearch()
        print("🔄 PostViewModel initialized")
    }
    
    // MARK: - Fetch Posts
    func fetchPosts() {
        isLoading = true
        errorMessage = nil
        networkService.getRequest(urlString: "https://jsonplaceholder.typicode.com/posts", resonseType: [Post].self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.filteredPosts = posts
                    self.errorMessage = nil
                    
                case .failure(let error):
                    let errorDescription = "Failed to load posts: \(error.localizedDescription)"
                    self.errorMessage = errorDescription
                    self.posts = []
                    self.filteredPosts = []
                }
            }
        }
    }
    
    func toggleFavorite(for postId: Int) {
        if favoritePosts.contains(postId) {
            favoritePosts.remove(postId)
        } else {
            favoritePosts.insert(postId)
        }
    }
    
    func isFavorite(_ postId: Int) -> Bool {
        return favoritePosts.contains(postId)
    }
    
    func getFavoritePosts() -> [Post] {
        let favorites = posts.filter { favoritePosts.contains($0.id ?? 0) }
        return favorites
    }
    
    private func setupSearch() {
        $searchText
            .combineLatest($posts)
            .map { searchText, posts in
                let filtered = searchText.isEmpty
                ? posts
                : posts.filter { $0.title!.localizedCaseInsensitiveContains(searchText) }
                return filtered
            }
            .assign(to: &$filteredPosts)
    }
    
    func refreshPosts() {
        fetchPosts()
    }
}
