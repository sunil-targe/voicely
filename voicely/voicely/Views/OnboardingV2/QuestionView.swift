//
//  QuestionView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/11/13.
//

import SwiftUI

struct QuestionView: View {
    let title: String
    let subtitle: String
    let options: [String]
    let onNext: ([String]) -> Void
    let onSkip: () -> Void
    
    @State private var selectedOptions: Set<String> = []
    
    private var isNextButtonEnabled: Bool {
        !selectedOptions.isEmpty
    }
    
    init(
        title: String,
        subtitle: String,
        options: [String],
        onNext: @escaping ([String]) -> Void,
        onSkip: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self.onNext = onNext
        self.onSkip = onSkip
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Dark background
            Color.black
                .ignoresSafeArea()
            
            cloudBackground
            
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
                    title: title,
                    subtitle: subtitle,
                    options: options,
                    selectedOptions: $selectedOptions
                )
                .padding(.horizontal, 24)
                .offset(y: -100)
                
                Spacer()
                
                // Next Button
                VStack(spacing: 16) {
                    Button(action: {
                        let selectedArray = Array(selectedOptions).sorted()
                        onNext(selectedArray)
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
                        onSkip()
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
    }
    
    private var cloudBackground: some View {
        GeometryReader { geometry in
            Image("que_background_blue")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .clipped()
                .ignoresSafeArea(edges: .top)
                .offset(y: -190)
        }
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

// MARK: - Onboarding Flow Container

struct OnboardingFlowView: View {
    @State private var currentQuestion = 0
    @State private var showMainApp = false
    @State private var answers: [String: [String]] = [:]
    
    private let questions: [(title: String, subtitle: String, options: [String], key: String)] = [
        (
            title: "What do you want your child to take away from stories?",
            subtitle: "Select their story preference",
            options: ["Kindness", "Courage", "Curiosity", "Calmness", "Gratitude", "Creativity"],
            key: "story_preferences"
        ),
        (
            title: "Which stories make your child's eyes light up?",
            subtitle: "Select their story preference",
            options: ["Animals", "Space", "Fairytales", "Nature", "Magic Worlds", "None"],
            key: "story_types"
        )
    ]
    
    private func completeOnboarding() {
        // Save all answers to UserDefaults
        for (key, values) in answers {
            UserDefaults.standard.set(values, forKey: "onboarding_\(key)")
        }
        
        // Mark onboarding as completed
        AppStorageManager.shared.markOnboardingCompleted()
        
        // Show main app
        showMainApp = true
    }
    
    var body: some View {
        ZStack {
            if currentQuestion < questions.count {
                QuestionView(
                    title: questions[currentQuestion].title,
                    subtitle: questions[currentQuestion].subtitle,
                    options: questions[currentQuestion].options,
                    onNext: { selectedOptions in
                        answers[questions[currentQuestion].key] = selectedOptions
                        if currentQuestion < questions.count - 1 {
                            currentQuestion += 1
                        } else {
                            completeOnboarding()
                        }
                    },
                    onSkip: {
                        completeOnboarding()
                    }
                )
            } else {
                Color.black
                    .ignoresSafeArea()
                    .onAppear {
                        completeOnboarding()
                    }
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            ContentView()
                .environmentObject(PurchaseViewModel.shared)
        }
    }
}

#Preview {
    QuestionView(
        title: "What do you want your child to take away from stories?",
        subtitle: "Select their story preference",
        options: ["Kindness", "Courage", "Curiosity", "Calmness", "Gratitude", "Creativity"],
        onNext: { _ in },
        onSkip: { }
    )
}
