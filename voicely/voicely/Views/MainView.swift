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
import DesignSystem

struct MainView: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var showHistory = false
    @State private var showVoice = false
    @State private var showFilter = false
    @State private var showPlayerView = false
    @State private var showPaywall = false
    
    var body: some View {
            VStack(spacing: 0) {
                // Main input area
                TextField("Start typing here...", text: $mainVM.inputText, axis: .vertical)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal)
                    .cornerRadius(12)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .tint(Color(red: 0.98, green: 0.67, blue: 0.53))
                    .onChange(of: mainVM.inputText) { newValue in
                        if newValue.count > 5000 {
                            mainVM.inputText = String(newValue.prefix(5000))
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isTextFieldFocused = true
                        }
                    }
                Spacer()
                // Player view if audio is generated
                if showPlayerView, let audioURL = mainVM.generatedAudioURL, let localAudioFilename = mainVM.generatedLocalAudioFilename {
                    VoicelyPlayer.PlayerView(
                        text: mainVM.inputText,
                        voice: mainVM.selectedVoice,
                        audioURL: audioURL,
                        localAudioFilename: localAudioFilename,
                        onClose: {
                            withAnimation {
                                showPlayerView = false
                                mainVM.generatedAudioURL = nil
                                mainVM.generatedLocalAudioFilename = nil
                            }
                        },
                        style: .TextToSpeech
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }
                // Bottom action bar
                VStack(spacing: 0) {
                    Divider()
                    HStack(alignment: .center) {
                        // Voice selection button
                        VoiceSelectionButton(
                            color: mainVM.selectedVoice.color.color,
                            title: mainVM.selectedVoice.name
                        ) {
                            playHapticFeedback()
                            showVoice = true
                        }
                        .sheet(isPresented: $showVoice) {
                            VoiceNameScreen(isPresented: $showVoice, selectedVoice: $mainVM.selectedVoice)
                                .onDisappear {
                                    mainVM.updateVoiceSelection()
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
                                selectedVoice: $mainVM.selectedVoice
                            )
                            .onDisappear {
                                mainVM.updateVoiceSelection()
                            }
                        }
                        
                        Spacer(minLength: 1)
                        // Generate button
                        Button(action: {
                            playHapticFeedback()
                            if purchaseVM.isPremium {
                                mainVM.generateSpeech(
                                    emotion: mainVM.selectedVoice.emotion,
                                    channel: mainVM.selectedVoice.channel,
                                    languageBoost: mainVM.selectedVoice.language
                                )
                            } else {
                                // Track paywall shown event
                                OnboardingViewModel.shared.trackPaywallShown(source: "generate_button")
                                showPaywall = true
                            }
                        }) {
                            if mainVM.isLoading {
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
                                .background(mainVM.inputText.count > 0 ? Color.white : Color(.systemGray4))
                                .foregroundColor(mainVM.inputText.count > 0 ? .black : .gray)
                                .cornerRadius(14)
                            }
                        }
                        .disabled(mainVM.inputText.isEmpty || mainVM.isLoading)
                        .onChange(of: mainVM.generatedAudioURL) { newValue in
                            if newValue != nil && mainVM.generatedLocalAudioFilename != nil {
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
                        Text("\(mainVM.inputText.count) characters")
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if mainVM.inputText.count > 3 {
                            Button(action: {
                                playHapticFeedback()
                                mainVM.inputText = ""
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
                            playHapticFeedback()
                            showHistory = true
                        }) {
                            Image("ic_list")
                                .foregroundStyle(.gray)
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
                                        mainVM.inputText = wish
                                    }
                                }
                                Button("Silly joke") {
                                    if let joke = Constants.jokes.randomElement() {
                                        mainVM.inputText = joke
                                    }
                                }
                                Menu("Bedtime Stories") {
                                    Button("English") {
                                        if let englishStories = Constants.nightStories["English"],
                                           let story = englishStories.randomElement() {
                                            mainVM.inputText = story
                                        }
                                    }
                                    Button("हिंदी") {
                                        if let hindiStories = Constants.nightStories["Hindi"],
                                           let story = hindiStories.randomElement() {
                                            mainVM.inputText = story
                                        }
                                    }
                                }
                            } header: {
                                Text("Get Started with")
                            }
                        } label: {
                            HStack {
                                Text("Get Started with")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.forward")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .animation(.easeInOut, value: mainVM.inputText.count > 3)
                }
            }
            .background(Color.black.ignoresSafeArea())
            .sheet(isPresented: $showHistory) {
                HistoryScreen(isPresented: $showHistory, history: $mainVM.history)
            }
            .fullScreenCover(isPresented: $showPaywall) {
                purchaseVM.refreshPurchaseStatus()
            } content: {
                PaywallView()
            }
    }
}

#Preview {
    MainView()
        .environmentObject(PurchaseViewModel.shared)
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
}
