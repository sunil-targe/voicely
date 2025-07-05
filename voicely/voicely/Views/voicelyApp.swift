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
    
    init() {
        Purchases.configure(
            with: Configuration.Builder(withAPIKey: "appl_HvoyfCcPNsFvyReUbXgmoTSbOWx")
                .with(storeKitVersion: .storeKit2)
                .build()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PurchaseViewModel.shared)
        }
    }
}
