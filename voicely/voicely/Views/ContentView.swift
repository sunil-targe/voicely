//
//  ContentView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/7/26.
//

import SwiftUI
import DesignSystem

struct ContentView: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @State private var showProfile = false
    @State private var selectedStory: Story?
    @State private var showVoiceName = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            showVoiceName = true
                        }) {
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Voice")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Image(systemName: "mic.fill")
                                            .foregroundStyle(.gray)
                                    }
                                    Text(mainVM.selectedVoice.name)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .foregroundStyle(.gray)
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical)
                        }
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(15)
                        Spacer()
                    }
                    .padding()
                    VStack(spacing: 6) {
                        NavigationLink {
                            AllStoriesView(stories: Story.allStories)
                        } label: {
                            HStack {
                                Text("Stories 📖")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                HStack {
                                    Text("More")
                                    Image(systemName: "chevron.forward")
                                }
                                .font(.callout)
                                .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Story.allStories) { story in
                                    StoryCard(story: story)
                                        .onTapGesture {
                                            selectedStory = story
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    

                    // Action Buttons Grid
                    VStack(spacing: 6) {
                        HeaderTitle(
                            text: "Import your own story",
                            icon: Image(systemName: "plus.circle.fill"),
                            color: .white
                        )
                        .padding(.top, 30)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 10) {
                            NavigationLink(
                                destination: MainView()
                                    .environmentObject(purchaseVM)
                                    .environmentObject(mainVM)
                            ) {
                                ActionButton(icon: "textformat", title: "Write text")
                            }
                            
                            NavigationLink(destination: AnyView(ScanTextView())) {
                                ActionButton(icon: "viewfinder", title: "Scan text")
                            }
                            
                            NavigationLink(destination: AnyView(PasteLinkView())) {
                                ActionButton(icon: "globe", title: "Paste a link")
                            }
                            
                            NavigationLink(destination: AnyView(UploadFileView())) {
                                ActionButton(icon: "doc.fill", title: "Upload a file")
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
            }
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showProfile = true
                    }) {
                        Image("ic_user")
                            .foregroundStyle(.gray)
                            .padding(.trailing, 6)
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileScreen(isPresented: $showProfile)
            }
            .sheet(isPresented: $showVoiceName) {
                VoiceNameScreen(isPresented: $showVoiceName, selectedVoice: $mainVM.selectedVoice)
                    .onDisappear {
                        mainVM.updateVoiceSelection()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            RatingPromptManager.shared.requestReviewIfAppropriate()
                        }
                    }
            }
            .fullScreenCover(item: $selectedStory) { story in
                BookPageView(story: story)
            }
        }
        .tint(.gray)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct StoryCard: View {
    let story: Story
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                // Story Image with 2:3 aspect ratio
                Image(story.thumbnailImageName)
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(.horizontal, 6)
                    .frame(width: 120)
                    .clipped()
                    .cornerRadius(8)
                Spacer()
            }
            VStack {
                // Story Title at bottom
                Text(story.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 4)
                    .offset(y: 4)
            }
            .padding(.vertical)
        }
        .frame(width: 120, height: 200)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
        .environmentObject(PurchaseViewModel.shared)
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
}

// Destination Views for NavigationLinks
struct WriteTextView: View {
    var body: some View {
        VStack {
            Text("Write Text")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScanTextView: View {
    var body: some View {
        VStack {
            Text("Scan Text")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PasteLinkView: View {
    var body: some View {
        VStack {
            Text("Paste Link")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UploadFileView: View {
    var body: some View {
        VStack {
            Text("Upload File")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
