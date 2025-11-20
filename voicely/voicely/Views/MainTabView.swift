//
//  MainTabView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/11/13.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // First Tab - ContentView
            ContentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Second Tab - Empty
            EmptyTabView(title: "My Stories")
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("My Stories")
                }
                .tag(1)
            
            // Third Tab - Empty
            EmptyTabView(title: "Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}

// MARK: - Empty Tab View

struct EmptyTabView: View {
    let title: String
    
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.title)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    MainTabView()
        .environmentObject(PurchaseViewModel.shared)
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
        .environmentObject(MediaPlayerManager.shared)
        .environmentObject(FavoritesManager())
}

