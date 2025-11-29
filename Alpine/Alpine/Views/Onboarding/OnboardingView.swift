//
//  OnboardingView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMode: AICoreMode = .student

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Title
                VStack(spacing: 12) {
                    Text("Alpine")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("Your sovereign AI console")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                // Mode Selection
                VStack(spacing: 24) {
                    Text("Who are you?")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)

                    VStack(spacing: 16) {
                        ModeCard(
                            mode: .student,
                            isSelected: selectedMode == .student
                        ) {
                            selectedMode = .student
                        }

                        ModeCard(
                            mode: .professional,
                            isSelected: selectedMode == .professional
                        ) {
                            selectedMode = .professional
                        }
                    }
                }

                Spacer()

                // Continue Button
                Button {
                    withAnimation(.spring()) {
                        appState.completeOnboarding(mode: selectedMode)
                    }
                } label: {
                    Text("Begin")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ModeCard: View {
    let mode: AICoreMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Preview of AI Core
                AICoreView(
                    mode: mode,
                    level: .spark,
                    size: 60
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.rawValue)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(mode.tagline)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title2)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(isSelected ? 0.15 : 0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.white.opacity(0.3) : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 32)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
