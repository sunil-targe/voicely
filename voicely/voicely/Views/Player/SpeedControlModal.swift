import SwiftUI

struct SpeedControlModal: View {
    @Binding var currentSpeed: Double
    @Binding var isPresented: Bool
    let onSpeedChanged: (Double) -> Void
    let originalDuration: Double // Original duration in seconds
    
    private let speedOptions: [Double] = [0.5, 0.8, 1.0, 1.2, 1.5, 2.0, 3.0, 3.5, 4.0]
    private let minSpeed: Double = 0.5
    private let maxSpeed: Double = 4.0
    private let speedStep: Double = 0.1
    
    // Computed property for adjusted duration
    private var adjustedDuration: Double {
        return originalDuration / currentSpeed
    }
    
    // Computed property for duration string
    private var durationString: String {
        let hours = Int(adjustedDuration) / 3600
        let minutes = (Int(adjustedDuration) % 3600) / 60
        let seconds = Int(adjustedDuration) % 60
        
        if hours > 0 {
            return String(format: "~%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "~%02d:%02d", minutes, seconds)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Playback Speed")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        playHapticFeedback()
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 8)
                
                // Duration info
                HStack {
                    Text("Duration: \(durationString)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // Main content with custom slider on the right
                HStack(alignment: .top, spacing: 20) {
                    // Left side - Main controls
                    VStack(spacing: 24) {
                        // Speed adjustment buttons and display
                        HStack(spacing: 40) {
                            // Decrease speed button
                            Button(action: {
                                playHapticFeedback()
                                decreaseSpeed()
                            }) {
                                Image(systemName: "minus")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(Color.gray.opacity(0.3)))
                            }
                            .disabled(currentSpeed <= minSpeed)
                            
                            // Current speed display
                            Text(String(format: "%.1fx", currentSpeed))
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .frame(minWidth: 120)
                            
                            // Increase speed button
                            Button(action: {
                                playHapticFeedback()
                                increaseSpeed()
                            }) {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(Color.gray.opacity(0.3)))
                            }
                            .disabled(currentSpeed >= maxSpeed)
                        }
                        
                        // Quick select speed options in rows of 3
                        VStack(spacing: 12) {
                            // First row: 0.5x, 0.8x, 1.0x
                            HStack(spacing: 12) {
                                ForEach(Array(speedOptions.prefix(3)), id: \.self) { speed in
                                    SpeedButton(
                                        speed: speed,
                                        isSelected: currentSpeed == speed,
                                        action: { selectSpeed(speed) }
                                    )
                                }
                            }
                            
                            // Second row: 1.2x, 1.5x, 2.0x
                            HStack(spacing: 12) {
                                ForEach(Array(speedOptions.dropFirst(3).prefix(3)), id: \.self) { speed in
                                    SpeedButton(
                                        speed: speed,
                                        isSelected: currentSpeed == speed,
                                        action: { selectSpeed(speed) }
                                    )
                                }
                            }
                            
                            // Third row: 3.0x, 3.5x, 4.0x
                            HStack(spacing: 12) {
                                ForEach(Array(speedOptions.dropFirst(6)), id: \.self) { speed in
                                    SpeedButton(
                                        speed: speed,
                                        isSelected: currentSpeed == speed,
                                        action: { selectSpeed(speed) }
                                    )
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Right side - Custom vertical slider
                    VStack {
                        CustomVerticalSlider(
                            value: $currentSpeed,
                            range: minSpeed...maxSpeed,
                            step: speedStep,
                            onValueChanged: { newValue in
                                onSpeedChanged(newValue)
                            }
                        )
                    }
                    .padding(.trailing, 20)
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
    
    private func decreaseSpeed() {
        let newSpeed = max(currentSpeed - speedStep, minSpeed)
        updateSpeed(newSpeed)
    }
    
    private func increaseSpeed() {
        let newSpeed = min(currentSpeed + speedStep, maxSpeed)
        updateSpeed(newSpeed)
    }
    
    private func selectSpeed(_ speed: Double) {
        updateSpeed(speed)
    }
    
    private func updateSpeed(_ newSpeed: Double) {
        currentSpeed = newSpeed
        onSpeedChanged(newSpeed)
    }
}

struct SpeedButton: View {
    let speed: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            playHapticFeedback()
            action()
        }) {
            Text(String(format: "%.1fx", speed))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 60, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
        }
    }
}

struct CustomVerticalSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let onValueChanged: (Double) -> Void
    
    @State private var isDragging = false
    @State private var lastHapticValue: Double = 0
    
    private let sliderHeight: CGFloat = 200
    private let thumbSize: CGFloat = 24
    private let trackWidth: CGFloat = 6
    
    var body: some View {
        VStack(spacing: 12) {
            // Top label (4.0x)
            Text(String(format: "%.1fx", range.upperBound))
                .font(.caption2)
                .foregroundColor(.gray)
                .fontWeight(.medium)
            
            // Slider track
            ZStack(alignment: .top) {
                // Background track (gray) - full height
                RoundedRectangle(cornerRadius: trackWidth/2)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: trackWidth, height: sliderHeight)
                
                // Active track (blue) - from bottom to current position
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: trackWidth/2)
                        .fill(Color.blue)
                        .frame(width: trackWidth, height: activeTrackHeight)
                }
                .frame(height: sliderHeight)
                
                // Thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(y: thumbOffset)
                    .scaleEffect(isDragging ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isDragging)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if !isDragging {
                                    isDragging = true
                                }
                                
                                // Calculate new value based on drag position
                                // Bottom of slider = 0.5x, Top of slider = 4.0x
                                let dragY = gesture.location.y
                                let normalizedY = max(0, min(sliderHeight, dragY))
                                let progress = 1 - (normalizedY / sliderHeight) // 0 at bottom, 1 at top
                                let newValue = range.lowerBound + progress * (range.upperBound - range.lowerBound)
                                
                                // Apply step and clamp
                                let steppedValue = round(newValue / step) * step
                                let clampedValue = max(range.lowerBound, min(range.upperBound, steppedValue))
                                
                                // Update value if changed
                                if abs(clampedValue - value) > 0.05 { // Threshold to avoid constant updates
                                    value = clampedValue
                                    onValueChanged(clampedValue)
                                    
                                    // Haptic feedback for significant changes
                                    if abs(clampedValue - lastHapticValue) >= 0.1 {
                                        playHapticFeedback()
                                        lastHapticValue = clampedValue
                                    }
                                }
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
            }
            
            // Bottom label (0.5x)
            Text(String(format: "%.1fx", range.lowerBound))
                .font(.caption2)
                .foregroundColor(.gray)
                .fontWeight(.medium)
        }
    }
    
    private var activeTrackHeight: CGFloat {
        // Calculate progress from 0.5x to 4.0x
        let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return sliderHeight * progress
    }
    
    private var thumbOffset: CGFloat {
        // Calculate thumb position from 0.5x to 4.0x
        let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return sliderHeight * (1 - progress) - thumbSize/2
    }
}
