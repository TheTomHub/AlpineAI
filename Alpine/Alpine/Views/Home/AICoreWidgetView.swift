//
//  AICoreWidgetView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

struct AICoreWidgetView: View {
    let mode: AICoreMode
    let level: AICoreLevel

    var body: some View {
        VStack(spacing: 16) {
            // AI Core Visual
            AICoreView(mode: mode, level: level, size: 120)

            // Level Info
            VStack(spacing: 4) {
                Text(level.phaseLabel)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(level.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.2),
                                    .white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AICoreWidgetView(mode: .professional, level: .contextual)
            .padding()
    }
}
