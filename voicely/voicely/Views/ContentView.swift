//
//  ContentView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/6/25.
//

import SwiftUI
import AVFoundation
import RevenueCat
import RevenueCatUI

struct ContentView: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @StateObject var viewModel = MainViewModel(selectedVoice: Voice.default)
    @FocusState private var isTextFieldFocused: Bool
    @State private var showHistory = false
    @State private var showProfile = false
    @State private var showVoice = false
    @State private var showFilter = false
    @State private var showPlayerView = false
    @State private var showPaywall = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Main input area
                TextField("Start typing here...", text: $viewModel.inputText, axis: .vertical)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal)
                    .cornerRadius(12)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .tint(Color(red: 0.98, green: 0.67, blue: 0.53))
                    .onChange(of: viewModel.inputText) { newValue in
                        if newValue.count > 5000 {
                            viewModel.inputText = String(newValue.prefix(5000))
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isTextFieldFocused = true
                        }
                    }
                Spacer()
                // Player view if audio is generated
                if showPlayerView, let audioURL = viewModel.generatedAudioURL, let localAudioFilename = viewModel.generatedLocalAudioFilename {
                    PlayerView(
                        text: viewModel.inputText,
                        voice: viewModel.selectedVoice,
                        audioURL: audioURL,
                        localAudioFilename: localAudioFilename,
                        onClose: {
                            withAnimation {
                                showPlayerView = false
                                viewModel.generatedAudioURL = nil
                                viewModel.generatedLocalAudioFilename = nil
                            }
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }
                // Bottom action bar
                VStack(spacing: 0) {
                    Divider()
                    HStack(alignment: .center) {
                        Button(action: { 
                            playHapticFeedback()
                            showVoice = true 
                        }) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(viewModel.selectedVoice.color.color)
                                    .frame(width: 24, height: 24)
                                Text(viewModel.selectedVoice.name)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                Divider()
                                    .foregroundStyle(.white.opacity(0.1))
                                    .frame(height: 20)
                                Image(systemName: "chevron.down").imageScale(.small)
                                    .foregroundStyle(.white.opacity(0.1))
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .sheet(isPresented: $showVoice) {
                            VoiceNameScreen(isPresented: $showVoice, selectedVoice: $viewModel.selectedVoice)
                                .onDisappear {
                                    viewModel.updateVoiceSelection()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        RatingPromptManager.shared.requestReviewIfAppropriate()
                                    }
                                }
                        }
                        Button(action: { 
                            playHapticFeedback()
                            showFilter = true 
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "waveform")
                                    .imageScale(.small)
                                    .foregroundStyle(.black)
                            }
                        }
                        .sheet(isPresented: $showFilter) {
                            FilterScreen(
                                isPresented: $showFilter,
                                selectedVoice: $viewModel.selectedVoice
                            )
                            .onDisappear {
                                viewModel.updateVoiceSelection()
                            }
                        }
                        
                        Spacer(minLength: 1)
                        // Generate button
                        Button(action: {
                            playHapticFeedback()
                            if purchaseVM.isPremium {
                                viewModel.generateSpeech(
                                    emotion: viewModel.selectedVoice.emotion,
                                    channel: viewModel.selectedVoice.channel,
                                    languageBoost: viewModel.selectedVoice.language
                                )
                            } else {
                                // Track paywall shown event
                                OnboardingViewModel.shared.trackPaywallShown(source: "generate_button")
                                showPaywall = true
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(width: 24, height: 24)
                                    .padding(.horizontal)
                            } else {
                                HStack(spacing: 6) {
                                    Image(systemName: "sparkles").imageScale(.medium)
                                        .padding(.leading)
                                    Text("Generate")
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 8)
                                        .padding(.trailing)
                                    
                                }
                                .background(viewModel.inputText.count > 0 ? Color.white : Color(.systemGray4))
                                .foregroundColor(viewModel.inputText.count > 0 ? .black : .gray)
                                .cornerRadius(14)
                            }
                        }
                        .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
                        .onChange(of: viewModel.generatedAudioURL) { newValue in
                            if newValue != nil && viewModel.generatedLocalAudioFilename != nil {
                                withAnimation {
                                    showPlayerView = true
                                }
                                isTextFieldFocused = false // Dismiss keyboard
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    // Character count bar
                    HStack {
                        Text("\(viewModel.inputText.count) characters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
                .background(.ultraThinMaterial)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { 
                        playHapticFeedback()
                        showHistory = true 
                    }) {
                        Image("ic_list")
                            .foregroundStyle(.gray)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if viewModel.inputText.count > 3 {
                            Button(action: {
                                playHapticFeedback()
                                viewModel.inputText = ""
                            }) {
                                Text("Clear")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.98, green: 0.67, blue: 0.53))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(red: 0.98, green: 0.67, blue: 0.53).opacity(0.2))
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 0.98, green: 0.67, blue: 0.53).opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                        Button(action: {
                            showProfile = true
                        }) {
                            Image("ic_user")
                                .foregroundStyle(.gray)
                                .padding(.trailing, 6)
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 0) {
                        Menu {
                            Section {
//                                Button("Random story") {
//                                    if let story = Constants.stories.randomElement() {
//                                        viewModel.inputText = story
//                                    }
//                                }
                                Button("Birthday Wish") {
                                    if let wish = Constants.birthdayWishes.randomElement() {
                                        viewModel.inputText = wish
                                    }
                                }
                                Button("Silly joke") {
                                    if let joke = Constants.jokes.randomElement() {
                                        viewModel.inputText = joke
                                    }
                                }
                                Menu("Bedtime Stories") {
                                    Button("English") {
                                        if let englishStories = Constants.nightStories["English"],
                                           let story = englishStories.randomElement() {
                                            viewModel.inputText = story
                                        }
                                    }
                                    Button("हिंदी") {
                                        if let hindiStories = Constants.nightStories["Hindi"],
                                           let story = hindiStories.randomElement() {
                                            viewModel.inputText = story
                                        }
                                    }
                                }
                            } header: {
                                Text("Get Started with")
                            }
                        } label: {
                            HStack {
                                Text(purchaseVM.isPremium ? "Voicely Pro" : "Voicely")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.forward")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .animation(.easeInOut, value: viewModel.inputText.count > 3)
                }
            }
            .background(Color.black.ignoresSafeArea())
            .sheet(isPresented: $showHistory) {
                HistoryScreen(isPresented: $showHistory, history: $viewModel.history)
            }
            .sheet(isPresented: $showProfile) {
                ProfileScreen(isPresented: $showProfile)
            }
            .fullScreenCover(isPresented: $showPaywall) {
                purchaseVM.refreshPurchaseStatus()
            } content: {
                PaywallView()
            }
                }
    }
}

#Preview {
    ContentView().environmentObject(PurchaseViewModel.shared)
}
