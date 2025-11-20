//
//  voicelyApp.swift
//  voicely
//
//  Created by Sunil Targe on 2025/6/25.
//

import SwiftUI
import RevenueCat
import Amplitude
import FirebaseCore

@main
struct voicelyApp: App {
    
    @StateObject private var purchaseVM = PurchaseViewModel.shared
    @StateObject private var mainVM = MainViewModel(selectedVoice: Voice.default)
    @StateObject private var mediaPlayerManager = MediaPlayerManager.shared
    @StateObject private var favoritesManager = FavoritesManager()

    init() {
        FirebaseApp.configure()
        Purchases.configure(
            with: Configuration.Builder(withAPIKey: "appl_HvoyfCcPNsFvyReUbXgmoTSbOWx")
                .with(storeKitVersion: .storeKit2)
                .build()
        )
        Amplitude.instance().initializeApiKey("8eff21a771f52d4deab93b7da58d6a89")
    }
    
    var body: some Scene {
        WindowGroup {
            if AppStorageManager.shared.isOnboardingCompleted() {
                MainTabView()
                    .environmentObject(purchaseVM)
                    .environmentObject(mainVM)
                    .environmentObject(mediaPlayerManager)
                    .environmentObject(favoritesManager)
            } else {
                OnboardingFlowView()
                    .environmentObject(purchaseVM)
                    .environmentObject(mainVM)
                    .environmentObject(mediaPlayerManager)
                    .environmentObject(favoritesManager)
            }
        }
    }
}
