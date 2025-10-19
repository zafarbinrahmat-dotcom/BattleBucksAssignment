Posts App - SwiftUI

A clean and modern iOS app that lets you browse posts, search through them, and save your favorites. Built with SwiftUI to show off what the framework can do.

What It Does

Browse Posts: See all posts in a nice card layout
Search: Find posts by title as you type
Save Favorites: Tap the heart icon to save posts you like
View Details: Tap any post to read the full content
Favorites Tab: See all your saved posts in one place
Pull to Refresh: Pull down to get the latest posts

Getting Started

What You'll Need

Xcode 26.0.1
iOS 26.0
Quick Setup

Get the Code
git clone https://github.com/your-username/posts-app-swiftui.git

How the Code is Organized
I've structured the code to be easy to understand and maintain:
Models         # Data structures
Services       # API and networking
ViewModels      # Business logic
Views          # All the UI screens

Key Files You Should Know About

PostListView.swift: Main screen with all posts
FavouritePostsView.swift: Your saved posts
PostDetailView.swift: Full post view
PostCardView.swift: Reusable post card (used in PostListView and FavouritePostsView)
PostViewModel.swift: Brain of the app - manages data and state

How It Works Under the Hood

The Tech Stuff
SwiftUI: For all the user interface
MVVM Pattern: Keeps code organized

