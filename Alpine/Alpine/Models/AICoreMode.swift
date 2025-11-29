//
//  AICoreMode.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

/// Represents the operational mode of the AI Core
enum AICoreMode: String, Codable, CaseIterable {
    case student = "Student"
    case professional = "Professional"

    var description: String {
        switch self {
        case .student:
            return "Student Mode – Your learning companion"
        case .professional:
            return "Professional Mode – Your productivity intelligence"
        }
    }

    var tagline: String {
        switch self {
        case .student:
            return "Playful, evolving AI creature"
        case .professional:
            return "Abstract geometric intelligence"
        }
    }
}
