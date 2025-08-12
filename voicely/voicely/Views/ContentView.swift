//
//  ContentView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/7/26.
//

import SwiftUI
import DesignSystem
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var purchaseVM: PurchaseViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @State private var showProfile = false
    @State private var selectedStory: Story?
    @State private var showVoiceName = false
    @State private var showUploadOptions = false
    @State private var showDocumentPicker = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var extractedText = ""
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showMainView = false
    @State private var showCameraPermissionAlert = false
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .denied, .restricted:
            showCameraPermissionAlert = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showCamera = true
                    } else {
                        self.showCameraPermissionAlert = true
                    }
                }
            }
        @unknown default:
            showCameraPermissionAlert = true
        }
    }
    
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
                                        Text("Choose your voice")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Image(systemName: "beats.headphones")
                                    }
                                    HStack(spacing: 6) {
                                        Image(systemName: "mic.circle.fill")
                                        Text(mainVM.selectedVoice.name)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Capsule().fill(.indigo))
                                    
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
                                // Add Story Card
                                NavigationLink(
                                    destination: MainView()
                                        .environmentObject(purchaseVM)
                                        .environmentObject(mainVM)
                                ) {
                                    AddStoryCard()
                                }
                                
                                // Story Cards
                                ForEach(Array(Story.allStories.prefix(3))) { story in
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
                        ) {
                            showUploadOptions = true
                        }
                        .padding(.top, 30)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 10) {

                            Button(action: {
                                showUploadOptions = true
                            }) {
                                ActionButton(icon: "doc.fill", title: "Upload file")
                            }
                            
                            Button(action: {
                                checkCameraPermission()
                            }) {
                                ActionButton(icon: "viewfinder", title: "Scan text")
                            }
                            
                            NavigationLink(
                                destination: PasteLinkView()
                                    .environmentObject(mainVM)
                            ) {
                                ActionButton(icon: "link", title: "Paste link")
                            }
                            
                       
                        }
                    }
                    .padding(.horizontal, 20)
    
                    Spacer()
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("Voicely")
            .navigationBarTitleDisplayMode(.automatic)
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
            .sheet(isPresented: $showUploadOptions) {
                UploadOptionsSheet(
                    showDocumentPicker: $showDocumentPicker,
                    showImagePicker: $showImagePicker
                )
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker(
                    extractedText: $extractedText,
                    isProcessing: $isProcessing,
                    showAlert: $showAlert,
                    alertMessage: $alertMessage,
                    showMainView: $showMainView
                )
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(
                    extractedText: $extractedText,
                    isProcessing: $isProcessing,
                    showAlert: $showAlert,
                    alertMessage: $alertMessage,
                    showMainView: $showMainView
                )
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(
                    extractedText: $extractedText,
                    isProcessing: $isProcessing,
                    showAlert: $showAlert,
                    alertMessage: $alertMessage,
                    showMainView: $showMainView,
                    showPermissionAlert: $showCameraPermissionAlert
                )
            }
            .fullScreenCover(isPresented: $showMainView) {
                NavigationView {
                    MainView()
                        .onAppear {
                            mainVM.inputText = extractedText
                        }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
            .alert("Camera Permission Required", isPresented: $showCameraPermissionAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
            } message: {
                Text("Camera access is required to capture images for text extraction. Please enable camera access in Settings.")
            }
            .overlay {
                if isProcessing {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        
                        Text("Extracting text from image...")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.8))
                    .ignoresSafeArea()
                }
            }

        }
        .tint(.gray)
    }
}

struct AddStoryCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // Plus Icon
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 40))
            
            // "Add Story" Text
            Text("Write a Story")
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Spacer()
        }
        .foregroundColor(.white.opacity(0.7))
        .frame(width: 120, height: 170)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
//        )
    }
}

#Preview {
    ContentView()
        .environmentObject(PurchaseViewModel.shared)
        .environmentObject(MainViewModel(selectedVoice: Voice.default))
}
