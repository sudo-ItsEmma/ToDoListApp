import Foundation

/// Prioridad de una tarea. El valor entero define el orden: mayor número, más urgente.
enum Priority: Int, Codable, CaseIterable, Comparable {
    case low = 0
    case medium = 1
    case high = 2

    static func < (lhs: Priority, rhs: Priority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// SF Symbol de la marca en la fila. La prioridad baja no lleva marca.
    var symbolName: String? {
        switch self {
        case .low: nil
        case .medium: "exclamationmark.2"
        case .high: "exclamationmark.3"
        }
    }

    /// Nombre para VoiceOver.
    var spokenName: String {
        switch self {
        case .low: "baja"
        case .medium: "media"
        case .high: "alta"
        }
    }
}
