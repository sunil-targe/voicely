//
//  QuestionView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/11/13.
//

import SwiftUI

struct QuestionView: View {
    @State private var selectedOptions: Set<String> = []
    @State private var showMainApp = false
    
    private let options = [
        "Kindness",
        "Courage",
        "Curiosity",
        "Calmness",
        "Gratitude",
        "Creativity"
    ]
    
    private var isNextButtonEnabled: Bool {
        !selectedOptions.isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Dark background
            Color.black
                .ignoresSafeArea()
            
            // Clouds positioned at fixed positions from top
            clouds.padding(.top, 40)
            
            VStack(spacing: 0) {
                AnimatedView(
                    name: "child_head",
                    loop: .loop
                )
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal)
                .offset(y: -50)
                
                // Tag Selection View
                TagSelectionView(
                    title: "What do you want your child to take away from stories?",
                    subtitle: "Select their story preference",
                    options: options,
                    selectedOptions: $selectedOptions
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Next Button
                VStack(spacing: 16) {
                    Button(action: {
                        completeOnboarding()
                    }) {
                        HStack(spacing: 8) {
                            Text("Next")
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 100)
                        .frame(height: 56)
                        .background(
                            Group {
                                if isNextButtonEnabled {
                                    ZStack(alignment: .center) {
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: "7701FF"),
                                                Color(hex: "C189FE")
                                            ]),
                                            center: .center,
                                            startRadius: 10,
                                            endRadius: 250
                                        )
                                        
                                        Image("cta_background_dots")
                                            .scaledToFit()
                                    }
                                } else {
                                    Color.white.opacity(0.1)
                                }
                            }
                        )
                        .cornerRadius(28)
                    }
                    .disabled(!isNextButtonEnabled)
                    
                    // "I will do it later" link
                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text("I will do it later")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            ContentView()
                .environmentObject(PurchaseViewModel.shared)
        }
    }
    
    private func completeOnboarding() {
        // Save the selected options to UserDefaults
        let selectedArray = Array(selectedOptions).sorted()
        UserDefaults.standard.set(selectedArray, forKey: "onboarding_story_preferences")
        
        // Mark onboarding as completed
        AppStorageManager.shared.markOnboardingCompleted()
        
        // Show main app
        showMainApp = true
    }
    
    private var clouds: some View {
        HStack {
            Image("left_cloud")
                .resizable()
                .scaledToFit()
                .frame(height: 153)
                .padding(.leading, 0)
            
            Spacer()
            
            Image("right_cloud")
                .resizable()
                .scaledToFit()
                .frame(height: 134)
                .padding(.trailing, 0)
                .offset(y: -60)
        }
        .padding(.horizontal, 0)
    }
}

#Preview {
    QuestionView()
}
