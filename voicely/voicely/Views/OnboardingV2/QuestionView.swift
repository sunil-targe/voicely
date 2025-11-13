//
//  QuestionView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/11/13.
//

import SwiftUI

struct QuestionView: View {
    @State private var selectedOptions: Set<String> = []
    
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
        ZStack {
            // Dark background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
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
                        let selectedArray = Array(selectedOptions).sorted()
                        print("Selected options: \(selectedArray)")
                    }) {
                        HStack(spacing: 8) {
                            Text("Next")
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Group {
                                if isNextButtonEnabled {
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#A734BD"),
                                            Color(hex: "#FF006A")
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    Color.gray.opacity(0.3)
                                }
                            }
                        )
                        .cornerRadius(28)
                    }
                    .disabled(!isNextButtonEnabled)
                    
                    // "I will do it later" link
                    Button(action: {
                        // Handle later action
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
}

#Preview {
    QuestionView()
}
