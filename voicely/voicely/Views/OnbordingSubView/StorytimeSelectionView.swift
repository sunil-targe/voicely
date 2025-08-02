//
//  Untitled.swift
//  voicely
//
//  Created by Gaurav on 27/07/25.
//

import SwiftUI

struct StorytimeSelectionView: View {
    @Binding var selectedTime: StorytimeOption
    @Environment(\.hideProgressBar) private var hideProgressBar

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Progress bar - only show if not hidden
            if !hideProgressBar {
                ProgressView(value: 0.6)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.indigo))
                    .frame(height: 4)
                    .padding(.horizontal)

                // Step count
                HStack {
                    Spacer()
                    Text("3 of 5")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.trailing)
                }
            }

            // Title
            VStack(alignment: .leading, spacing: 6) {
                Text("When do you usually read stories?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("We'll customize your experience based on your typical storytime")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)

            // Grid of options
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(StorytimeOption.allCases, id: \.self) { option in
                    StorytimeCard(option: option, isSelected: selectedTime == option)
                        .onTapGesture {
                            selectedTime = option
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()

            // Buttons - only show if not hidden
            if !hideProgressBar {
                HStack(spacing: 20) {
                    Button(action: {
                        // Handle Back
                    }) {
                        Text("Back")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    Button(action: {
                        // Handle Continue
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

enum StorytimeOption: String, CaseIterable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case bedtime = "Bedtime"

    var iconName: String {
        switch self {
        case .morning: return "sunrise.fill"
        case .afternoon: return "sun.max.fill"
        case .evening: return "sunset.fill"
        case .bedtime: return "moon.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .morning: return .yellow
        case .afternoon: return .orange
        case .evening: return .pink
        case .bedtime: return .blue
        }
    }
}

struct StorytimeCard: View {
    let option: StorytimeOption
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: option.iconName)
                .font(.system(size: 24))
                .foregroundColor(option.iconColor)
                .padding(12)
                .background(option.iconColor.opacity(0.1))
                .clipShape(Circle())

            Text(option.rawValue)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity)
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
    StorytimeSelectionView(selectedTime: .constant(.bedtime))
}

#Preview("With Progress Bar") {
    StorytimeSelectionView(selectedTime: .constant(.bedtime))
        .environment(\.hideProgressBar, false)
}
