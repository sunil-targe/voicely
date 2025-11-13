//
//  TagSelectionView.swift
//  voicely
//
//  Created by Sunil Targe on 2025/11/13.
//

import SwiftUI

struct TagSelectionView: View {
    let title: String
    let subtitle: String
    let options: [String]
    @Binding var selectedOptions: Set<String>
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            // Title and subtitle
            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            // Tags
            FlowLayout(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    TagButton(
                        title: option,
                        isSelected: selectedOptions.contains(option)
                    ) {
                        if selectedOptions.contains(option) {
                            selectedOptions.remove(option)
                        } else {
                            selectedOptions.insert(option)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Tag Button

private struct TagButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule().fill(isSelected ? Color(hex: "AC61FF").opacity(0.1) : .clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ? Color(hex: "AC61FF") : .white.opacity(0.24),
                            lineWidth: 1
                        )
                )
                .cornerRadius(20)
        }
    }
}

// MARK: - Flow Layout Helper

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                     y: bounds.minY + result.frames[index].minY),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            var maxWidthUsed: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    // Move to next line
                    currentY += lineHeight + spacing
                    currentX = 0
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
                maxWidthUsed = max(maxWidthUsed, currentX - spacing)
            }
            
            self.size = CGSize(width: maxWidthUsed, height: currentY + lineHeight)
        }
    }
}

#Preview {
    TagSelectionView(
        title: "What do you want your child to take away from stories?",
        subtitle: "Select their story preference",
        options: ["Kindness", "Courage", "Curiosity", "Calmness", "Gratitude", "Creativity"],
        selectedOptions: .constant(["Curiosity", "Calmness"])
    )
    .padding()
    .background(Color.black)
}

