//
//  StorytimeSelectionView.swift
//  voicely
//
//  Created by Gaurav on 27/07/25.
//

import SwiftUI

struct StorytimeSelectionView: View {
    @Binding var selectedTime: StorytimeOption?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title Section
            VStack(alignment: .leading, spacing: 6) {
                Text("When do you usually read stories?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("We'll customize your experience based on your typical storytime")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)

            // Grid of options
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(StorytimeOption.allCases, id: \.self) { option in
                    StorytimeCard(
                        option: option,
                        isSelected: selectedTime == option
                    )
                    .onTapGesture {
                        playHapticFeedback()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTime = option
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

// MARK: - StorytimeOption Enum
enum StorytimeOption: String, CaseIterable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case bedtime = "Bedtime"

    var iconName: String {
        switch self {
        case .morning:
            return "sunrise.fill"
        case .afternoon:
            return "sun.max.fill"
        case .evening:
            return "sunset.fill"
        case .bedtime:
            return "moon.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .morning:
            return .yellow
        case .afternoon:
            return .orange
        case .evening:
            return .pink
        case .bedtime:
            return .blue
        }
    }
}

// MARK: - StorytimeCard View
struct StorytimeCard: View {
    let option: StorytimeOption
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 12) {
            // Icon
            Image(systemName: option.iconName)
                .font(.title2)
                .foregroundColor(option.iconColor)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(option.iconColor.opacity(0.1))
                )

            // Text
            Text(option.rawValue)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
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
    StorytimeSelectionView(selectedTime: .constant(nil))
}

#Preview("With Selection") {
    StorytimeSelectionView(selectedTime: .constant(.bedtime))
}

