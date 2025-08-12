//
//  UsageSelectionView.swift
//  voicely
//
//  Created by Gaurav on 27/07/25.
//

import SwiftUI

struct UsageSelectionView: View {
    @Binding var selectedOptions: Set<UsageOption>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title Section
            VStack(alignment: .leading, spacing: 6) {
                Text("How will you use Voicely?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("Select all the ways you plan to use our app with your child (you can choose multiple)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            // Options Section
            VStack(spacing: 16) {
                ForEach(UsageOption.allCases, id: \.self) { option in
                    OptionCard(
                        option: option,
                        isSelected: selectedOptions.contains(option)
                    )
                    .onTapGesture {
                        playHapticFeedback()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if selectedOptions.contains(option) {
                                selectedOptions.remove(option)
                            } else {
                                selectedOptions.insert(option)
                            }
                        }
                    }
                }
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private func playHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
}

// MARK: - UsageOption Enum
enum UsageOption: String, CaseIterable {
    case bedtimeStories = "Bedtime Stories"
    case educationalStories = "Educational Stories"
    case travelEntertainment = "Travel Entertainment"
    case anytimeListening = "Anytime Listening"

    var iconName: String {
        switch self {
        case .bedtimeStories:
            return "moon.fill"
        case .educationalStories:
            return "book.fill"
        case .travelEntertainment:
            return "airplane"
        case .anytimeListening:
            return "headphones"
        }
    }
}

// MARK: - OptionCard View
struct OptionCard: View {
    let option: UsageOption
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: option.iconName)
                .font(.title2)
                .foregroundColor(isSelected ? .white : .secondary)
                .frame(width: 44, height: 44)
                .offset(y: -4)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                                .fill(isSelected ? Color.indigo : Color.secondary.opacity(0.2))
                                .frame(width: 44, height: 54) // Taller than it is wide
                )

            // Text
            Text(option.rawValue)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? Color.indigo.opacity(0.8) : Color.secondary.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.indigo : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Previews
#Preview("Default State") {
    UsageSelectionView(selectedOptions: .constant([]))
}

#Preview("With Selection") {
    UsageSelectionView(selectedOptions: .constant([.bedtimeStories, .educationalStories]))
}
