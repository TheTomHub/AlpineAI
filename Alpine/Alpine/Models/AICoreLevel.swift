//
//  AICoreLevel.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation
import SwiftUI

/// Represents the evolution stages of the AI Core
enum AICoreLevel: Int, Codable, CaseIterable {
    case dormant = 0
    case spark = 1
    case awareness = 2
    case patternRecognition = 3
    case contextual = 4
    case predictive = 5

    var name: String {
        switch self {
        case .dormant:
            return "Dormant"
        case .spark:
            return "Spark"
        case .awareness:
            return "Awareness"
        case .patternRecognition:
            return "Pattern Recognition"
        case .contextual:
            return "Contextual"
        case .predictive:
            return "Predictive"
        }
    }

    var description: String {
        switch self {
        case .dormant:
            return "Initializing…"
        case .spark:
            return "Learning your basics"
        case .awareness:
            return "Observing your patterns"
        case .patternRecognition:
            return "Understanding connections"
        case .contextual:
            return "Anticipating your needs"
        case .predictive:
            return "Optimizing for you"
        }
    }

    var phaseLabel: String {
        "Phase \(rawValue) – \(name)"
    }

    // Visual properties for rendering
    var glowIntensity: Double {
        Double(rawValue) * 0.15
    }

    var scale: CGFloat {
        1.0 + CGFloat(rawValue) * 0.05
    }

    var rotationSpeed: Double {
        1.0 + Double(rawValue) * 0.2
    }
}
