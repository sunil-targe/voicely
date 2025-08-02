//
//  Untitled.swift
//  voicely
//
//  Created by Gaurav on 27/07/25.
//

import SwiftUI

struct UsageSelectionView: View {
    @Binding var selectedOption: UsageOption
    @Environment(\.hideProgressBar) private var hideProgressBar

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Progress bar - only show if not hidden
            if !hideProgressBar {
                ProgressView(value: 0.4)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.indigo))
                    .frame(height: 4)
                    .padding(.horizontal)
                
                // Step number
                HStack {
                    Spacer()
                    Text("2 of 5")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.horizontal)
                }
            }

            // Title
            VStack(alignment: .leading, spacing: 6) {
                Text("How will you use Voicely?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("Select the main way you plan to use our app with your child")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            
            
            // Options
            VStack(spacing: 16) {
                ForEach(UsageOption.allCases, id: \.self) { option in
                    OptionCard(option: option, isSelected: selectedOption == option)
                        .onTapGesture {
                            selectedOption = option
                        }
                }
            }
            .padding(.top, 20)

            Spacer()

            // Buttons - only show if not hidden
            if !hideProgressBar {
                HStack(spacing: 20) {
                    Button(action: {
                        // Handle back
                    }) {
                        Text("Back")
                            .foregroundColor(.indigo)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.indigo, lineWidth: 1)
                            )
                    }

                    Button(action: {
                        // Handle continue
                    }) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

enum UsageOption: String, CaseIterable {
    case bedtimeStories = "Bedtime Stories"
    case educationalStories = "Educational Stories"
    case travelEntertainment = "Travel Entertainment"
    case anytimeListening = "Anytime Listening"

    var iconName: String {
        switch self {
        case .bedtimeStories: return "moon.fill"
        case .educationalStories: return "book.fill"
        case .travelEntertainment: return "airplane"
        case .anytimeListening: return "headphones"
        }
    }
}

struct OptionCard: View {
    let option: UsageOption
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: option.iconName)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(12)
                .background(isSelected ? Color.indigo : Color("Secondary"))
                .clipShape(Circle())

            Text(option.rawValue)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.semibold)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? Color.indigo.opacity(0.5) : Color("Secondary").opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.indigo : Color("Secondary"), lineWidth: 2)
                )
        )
    }
}


#Preview {
    UsageSelectionView(selectedOption: .constant(.bedtimeStories))
}

#Preview("With Progress Bar") {
    UsageSelectionView(selectedOption: .constant(.bedtimeStories))
        .environment(\.hideProgressBar, false)
}
