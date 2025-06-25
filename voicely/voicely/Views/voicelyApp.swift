//
//  voicelyApp.swift
//  voicely
//
//  Created by Sunil Targe on 2025/6/25.
//

import SwiftUI
import RevenueCat
import Amplitude

@main
struct voicelyApp: App {
    
    @StateObject private var purchaseVM = PurchaseViewModel.shared

    init() {
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
                ContentView()
                    .environmentObject(purchaseVM)
            } else {
                OnboardingView()
                    .environmentObject(purchaseVM)
            }
        }
    }
}
