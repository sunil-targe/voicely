//
//  UsageFrequencyView.swift
//  voicely
//
//  Created by Gaurav on 27/07/25.
//

import SwiftUI

struct UsageFrequencyView: View {
    @Binding var selectedOption: FrequencyOption?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title Section
            VStack(alignment: .leading, spacing: 6) {
                Text("How often will you use Voicely?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("This helps us recommend the right story plan for you and your child")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                // Calendar Icon
                Image(systemName: "calendar")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)

            // Frequency options
            VStack(spacing: 16) {
                ForEach(FrequencyOption.allCases, id: \.self) { option in
                    FrequencyCard(
                        option: option,
                        isSelected: selectedOption == option
                    )
                    .onTapGesture {
                        playHapticFeedback()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedOption = option
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()
        }
        .padding(.top)
    }
    
    private func playHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
}

// MARK: - FrequencyOption Enum
enum FrequencyOption: String, CaseIterable {
    case everyDay = "Every day"
    case severalTimesAWeek = "Several times a week"
    case onceAWeek = "Once a week"
    case occasionally = "Occasionally"
}

// MARK: - FrequencyCard View
struct FrequencyCard: View {
    let option: FrequencyOption
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Selection Indicator
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .font(.title2)
                .foregroundColor(isSelected ? .white : .primary)
            
            // Text
            Text(option.rawValue)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
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
    UsageFrequencyView(selectedOption: .constant(nil))
}

#Preview("With Selection") {
    UsageFrequencyView(selectedOption: .constant(.everyDay))
}
