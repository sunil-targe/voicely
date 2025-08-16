//
//  BookPageView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/7/28.
//

import SwiftUI
import RevenueCat
import RevenueCatUI
import DesignSystem
import AVFoundation

struct BookPageView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @StateObject private var storyVM = StoryViewModel()
    @StateObject private var mediaPlayerManager = MediaPlayerManager.shared
    @State private var showPlayerView = false
    @State private var currentSavedStory: SavedStory?
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showVoiceSelection = false
    @State private var showConfirmationAlert = false
    @State private var showPaywall = false
    @State private var showSoundscapes = false
    @State private var selectedSoundscape: SoundscapesView.SoundscapeType = .mute
    
    let story: Story

    var body: some View {
            VStack(spacing: 0) {
                // header
                HStack(alignment: .top) {
                    // Title
                    Text(story.name)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                    Spacer(minLength: 6)
                    Button(action: {
                        playHapticFeedback()
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.trailing, 6)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal)
                
                // Story view
                ZStack(alignment: .bottom) {
                    switch story.storyViewName {
                    case "BraveLittleRabbitView":
                        BraveLittleRabbitView()
                    case "BearFamilyHibernationView":
                        BearFamilyHibernationView()
                    case "DragonCouldntBreatheFireView":
                        DragonCouldntBreatheFireView()
                    case "DreamOfFlyingView":
                        DreamOfFlyingView()
                    case "ForestFriendsStormView":
                        ForestFriendsStormView()
                    case "LostKittenJourneyView":
                        LostKittenJourneyView()
                    case "MermaidOceanLessonView":
                        MermaidOceanLessonView()
                    case "SecretGardenDiscoveryView":
                        SecretGardenDiscoveryView()
                    case "ToysNighttimeAdventureView":
                        ToysNighttimeAdventureView()
                    case "YoungWizardLessonView":
                        YoungWizardLessonView()
                    default:
                        Text("Story not found")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    
                    // bottom shadow
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.black.opacity(0.3)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 20)
                    .allowsHitTesting(false)
                }
                
                // Player view
                if showPlayerView, let savedStory = currentSavedStory {
                    VoicelyPlayer.PlayerView(
                        text: savedStory.story.name,
                        voice: savedStory.voice,
                        audioURL: storyVM.getLocalAudioURL(for: savedStory) ?? savedStory.audioURL,
                        localAudioFilename: savedStory.localAudioFilename,
                        onClose: {
                            withAnimation {
                                showPlayerView = false
                            }
                        },
                        style: .ReadBook
                    )
                } else {
                    VStack(spacing: 16) {
                        Divider()
                        HStack {
                            // Voice Selection Button
                            Button(action: {
                                playHapticFeedback()
                                showVoiceSelection = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "mic.circle.fill")
                                        .font(.title2)
                                    Text(mainVM.selectedVoice.name)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.leading)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(.indigo))
                            }
                            
                            // Read/Generate Button
                            Button(action: {
                                playHapticFeedback()
                                handleListenButtonAction()
                            }) {
                                HStack(spacing: 8) {
                                    if storyVM.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(width: 20, height: 20)
                                    } else {
                                        Image(systemName: "headphones.circle.fill")
                                            .font(.title2)
                                    }
                                    Text("Listen")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.orange)
                                .cornerRadius(25)
                            }
                            .disabled(storyVM.isLoading)
                        }
                    }.background(Color(.secondarySystemBackground))
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        playHapticFeedback()
                        showSoundscapes = true
                    }) {
                        Image(systemName: "waveform")
                            .imageScale(.medium)
                            .foregroundStyle(mediaPlayerManager.currentSoundscape != .mute ? .orange : .gray)
                            .scaleEffect(mediaPlayerManager.currentSoundscape != .mute ? 1.15 : 1.0)
                            .opacity(mediaPlayerManager.currentSoundscape != .mute ? 0.9 : 1.0)
                            .animation(
                                mediaPlayerManager.currentSoundscape != .mute ? 
                                .easeInOut(duration: 0.3)
                                .repeatForever(autoreverses: true) :
                                .easeOut(duration: 0.1),
                                value: mediaPlayerManager.currentSoundscape
                            )
                            .padding(.leading, 6)
                    }
                }
            }
            .onAppear {
                loadSavedStory()
                // Sync the current soundscape with the selected one
                selectedSoundscape = mediaPlayerManager.currentSoundscape
            }
            .onChange(of: storyVM.generatedAudioURL) { newValue in
                if newValue != nil && storyVM.generatedLocalAudioFilename != nil {
                    loadSavedStory()
                    withAnimation {
                        showPlayerView = true
                    }
                }
            }
            .onChange(of: storyVM.errorMessage) { error in
                if let error = error {
                    errorMessage = error
                    showErrorAlert = true
                }
            }
            .sheet(isPresented: $showVoiceSelection) {
                VoiceNameScreen(isPresented: $showVoiceSelection, selectedVoice: $mainVM.selectedVoice)
                    .onDisappear {
                        mainVM.updateVoiceSelection()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            RatingPromptManager.shared.requestReviewIfAppropriate()
                        }
                    }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {
                    storyVM.errorMessage = nil
                }
            } message: {
                Text(errorMessage)
            }
            .alert("Listen with new voice?", isPresented: $showConfirmationAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Listen again") {
                    if let savedStory = storyVM.getSavedStory(for: story) {
                        currentSavedStory = savedStory
                        withAnimation {
                            showPlayerView = true
                        }
                    }
                }
                Button("Go for new voice") {
                    generateStoryVoice()
                }
            } message: {
                Text("Story was previously generated with a different voice. Do you want to listen it again with the new voice?")
            }
            .sheet(isPresented: $showSoundscapes) {
                SoundscapesView(selectedSoundscape: $selectedSoundscape)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $showPaywall) {
                purchaseVM.refreshPurchaseStatus()
            } content: {
                PaywallView()
            }
    }
    
    private func handleListenButtonAction() { //
        guard purchaseVM.isPremium else {
            showPaywall = true
            return
        }
        
        // If there's a saved story and the selected voice matches the saved story's voice
        if let savedStory = storyVM.getSavedStory(for: story),
           mainVM.selectedVoice.voice_id == savedStory.voice.voice_id {
            // Show the player with existing saved story
            currentSavedStory = savedStory
            withAnimation {
                showPlayerView = true
            }
        } else if let savedStory = storyVM.getSavedStory(for: story),
                  mainVM.selectedVoice.voice_id != savedStory.voice.voice_id {
            // Show confirmation alert for different voice
            showConfirmationAlert = true
        } else {
            // No saved story exists, generate without confirmation
            generateStoryVoice()
        }
    }
    
    private func generateStoryVoice() {
        // Check if user has premium access (you might want to add this check)
        storyVM.generateStoryVoice(for: story, with: mainVM.selectedVoice)
    }
    
    private func loadSavedStory() {
        print("BookPageView: Loading saved story for \(story.name)")
        if let savedStory = storyVM.getSavedStory(for: story) {
            print("BookPageView: Found saved story, showing player")
            currentSavedStory = savedStory
            showPlayerView = true
        } else {
            print("BookPageView: No saved story found, showing read button")
        }
    }
    
    private func playHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
}

#Preview {
    BookPageView(story: Story.allStories[0])
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
}
