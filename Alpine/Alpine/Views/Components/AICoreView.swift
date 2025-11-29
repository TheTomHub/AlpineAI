//
//  AICoreView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

/// Visual representation of the AI Core with dual-mode styling
struct AICoreView: View {
    let mode: AICoreMode
    let level: AICoreLevel
    let size: CGFloat

    @State private var isAnimating = false
    @State private var rotationDegrees: Double = 0

    var body: some View {
        ZStack {
            switch mode {
            case .student:
                studentModeCore
            case .professional:
                professionalModeCore
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            startAnimation()
        }
    }

    // MARK: - Student Mode (Creature-like)

    private var studentModeCore: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            studentColor.opacity(0.3 * level.glowIntensity),
                            .clear
                        ],
                        center: .center,
                        startRadius: size * 0.3,
                        endRadius: size * 0.6
                    )
                )
                .scaleEffect(isAnimating ? 1.1 : 1.0)

            // Main body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            studentColor,
                            studentColor.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.6, height: size * 0.6)
                .scaleEffect(level.scale)

            // Eyes (if level > 1)
            if level.rawValue >= 2 {
                HStack(spacing: size * 0.15) {
                    eyeView
                    eyeView
                }
                .offset(y: -size * 0.08)
            }

            // Spark particles (higher levels)
            if level.rawValue >= 4 {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(studentColor.opacity(0.6))
                        .frame(width: 4, height: 4)
                        .offset(
                            x: cos(Double(index) * 2 * .pi / 3 + rotationDegrees * .pi / 180) * size * 0.4,
                            y: sin(Double(index) * 2 * .pi / 3 + rotationDegrees * .pi / 180) * size * 0.4
                        )
                }
            }
        }
    }

    private var eyeView: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: size * 0.12, height: size * 0.12)

            Circle()
                .fill(.black)
                .frame(width: size * 0.06, height: size * 0.06)
                .offset(x: isAnimating ? 2 : -2)
        }
    }

    private var studentColor: Color {
        switch level {
        case .dormant:
            return .gray
        case .spark:
            return .orange
        case .awareness:
            return .yellow
        case .patternRecognition:
            return .green
        case .contextual:
            return .blue
        case .predictive:
            return .purple
        }
    }

    // MARK: - Professional Mode (Geometric)

    private var professionalModeCore: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            professionalColor,
                            professionalColor.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: size * 0.8, height: size * 0.8)
                .rotationEffect(.degrees(rotationDegrees))
                .opacity(0.5 + level.glowIntensity)

            // Hexagon core
            RegularPolygon(sides: 6)
                .stroke(professionalColor, lineWidth: 2)
                .frame(width: size * 0.5, height: size * 0.5)
                .rotationEffect(.degrees(-rotationDegrees * 0.5))

            // Inner triangle (level 3+)
            if level.rawValue >= 3 {
                RegularPolygon(sides: 3)
                    .fill(
                        LinearGradient(
                            colors: [
                                professionalColor.opacity(0.3),
                                professionalColor.opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 0.3, height: size * 0.3)
                    .rotationEffect(.degrees(rotationDegrees))
            }

            // Center core
            Circle()
                .fill(professionalColor)
                .frame(width: size * 0.15, height: size * 0.15)
                .scaleEffect(isAnimating ? 1.1 : 0.9)

            // Glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            professionalColor.opacity(0.4 * level.glowIntensity),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )
        }
    }

    private var professionalColor: Color {
        switch level {
        case .dormant:
            return .gray
        case .spark:
            return .cyan
        case .awareness:
            return .blue
        case .patternRecognition:
            return .indigo
        case .contextual:
            return .purple
        case .predictive:
            return .pink
        }
    }

    // MARK: - Animation

    private func startAnimation() {
        // Pulse animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            isAnimating = true
        }

        // Rotation animation
        withAnimation(.linear(duration: 10.0 / level.rotationSpeed).repeatForever(autoreverses: false)) {
            rotationDegrees = 360
        }
    }
}

// MARK: - Regular Polygon Shape

struct RegularPolygon: Shape {
    let sides: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angle = (2 * .pi) / Double(sides)

        var path = Path()

        for i in 0..<sides {
            let x = center.x + radius * cos(angle * Double(i) - .pi / 2)
            let y = center.y + radius * sin(angle * Double(i) - .pi / 2)
            let point = CGPoint(x: x, y: y)

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Preview

#Preview("Student Mode - Level 3") {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 40) {
            AICoreView(mode: .student, level: .patternRecognition, size: 200)
            Text("Student Mode")
                .foregroundStyle(.white)
        }
    }
}

#Preview("Professional Mode - Level 4") {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 40) {
            AICoreView(mode: .professional, level: .contextual, size: 200)
            Text("Professional Mode")
                .foregroundStyle(.white)
        }
    }
}
