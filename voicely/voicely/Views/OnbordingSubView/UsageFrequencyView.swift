//
//  Untitled.swift
//  voicely
//
//  Created by Gaurav on 27/07/25.
//

import SwiftUI

struct UsageFrequencyView: View {
    @Binding var selectedOption: FrequencyOption
    @Environment(\.hideProgressBar) private var hideProgressBar

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Progress bar - only show if not hidden
            if !hideProgressBar {
                ProgressView(value: 0.8)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.indigo))
                    .frame(height: 4)
                    .padding(.horizontal)

                // Step count
                HStack {
                    Spacer()
                    Text("4 of 5")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.trailing)
                }
            }

            // Title
            VStack(alignment: .leading, spacing: 6) {
                Text("How often will you use Voicely?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                // Subtitle
                Text("This helps us recommend the right story plan for you and your child")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                // Calendar Icon
                Image(systemName: "calendar")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            .padding(.horizontal)

            // Frequency options
            VStack(spacing: 16) {
                ForEach(FrequencyOption.allCases, id: \.self) { option in
                    HStack {
                        Image(systemName: selectedOption == option ? "largecircle.fill.circle" : "circle")
                        Text(option.rawValue)
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(26)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedOption == option ? Color.indigo.opacity(0.5) : Color("Secondary").opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(selectedOption == option ? Color.indigo : Color("Secondary"), lineWidth: 2)
                            )
                    )
                    .onTapGesture {
                        selectedOption = option
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()

            // Navigation buttons - only show if not hidden
            if !hideProgressBar {
                HStack(spacing: 20) {
                    Button(action: {
                        // Handle back
                    }) {
                        Text("Back")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(30)
                    }

                    Button(action: {
                        // Handle continue
                    }) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

enum FrequencyOption: String, CaseIterable {
    case everyDay = "Every day"
    case severalTimesAWeek = "Several times a week"
    case onceAWeek = "Once a week"
    case occasionally = "Occasionally"
}

#Preview {
    UsageFrequencyView(selectedOption: .constant(.everyDay))
}

#Preview("With Progress Bar") {
    UsageFrequencyView(selectedOption: .constant(.everyDay))
        .environment(\.hideProgressBar, false)
}
