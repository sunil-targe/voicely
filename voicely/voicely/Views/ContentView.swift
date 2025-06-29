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
    
    var body: some View {
        NavigationView {
            VStack {
                // Main input area
                TextField("Start typing here...", text: $viewModel.inputText, axis: .vertical)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal)
                    .cornerRadius(12)
                    .font(.title2)
                    .fontWeight(.semibold)
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
                        Button(action: { showVoice = true }) {
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
                        }
                        Button(action: { showFilter = true }) {
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
                        }
                        
                        Spacer(minLength: 1)
                        // Generate button
                        Button(action: {
                            viewModel.generateSpeech(
                                emotion: viewModel.selectedVoice.emotion,
                                channel: viewModel.selectedVoice.channel,
                                languageBoost: viewModel.selectedVoice.language
                            )
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
            .navigationTitle("Voicely")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath").imageScale(.large)
                            .foregroundStyle(.gray)
                            .padding(.leading, 6)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Profile") { showProfile = true }
                        Menu("Get started with") {
                            Button("Random story") {
                                if let story = Constants.stories.randomElement() {
                                    viewModel.inputText = story
                                }
                            }
                            Button("Silly joke") {
                                if let joke = Constants.jokes.randomElement() {
                                    viewModel.inputText = joke
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 0) {
                        Text("Voicely")
                            .font(.headline)
                            .foregroundColor(.white)
                        if viewModel.inputText.count > 10 {
                            Button(action: {
                                withAnimation {
                                    viewModel.inputText = ""
                                }
                            }) {
                                Text("Clear")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .animation(.easeInOut, value: viewModel.inputText.count > 10)
                }
            }
            .sheet(isPresented: $showHistory) {
                HistoryScreen(isPresented: $showHistory, history: viewModel.history)
            }
            .sheet(isPresented: $showProfile) {
                ProfileScreen(isPresented: $showProfile)
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
}

#Preview {
    ContentView()
}
