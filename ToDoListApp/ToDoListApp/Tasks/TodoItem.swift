import Foundation
import SwiftData

/// Única entidad persistida de la app. Se llama `TodoItem` para no chocar con `Task` de Swift Concurrency.
@Model
final class TodoItem {
    /// Identificador estable. Nombra la notificación de la tarea para poder cancelarla o reprogramarla.
    var id = UUID()
    var title: String
    var notes: String
    /// Fecha y hora de vencimiento. `nil` significa que la tarea no tiene fecha.
    var dueDate: Date?
    /// Se guarda como entero; usar `priority` para leerla y escribirla.
    var priorityRaw: Int
    var isCompleted: Bool
    var createdAt: Date

    var priority: Priority {
        get { Priority(rawValue: priorityRaw) ?? .low }
        set { priorityRaw = newValue.rawValue }
    }

    init(
        title: String,
        notes: String = "",
        dueDate: Date? = nil,
        priority: Priority = .low,
        isCompleted: Bool = false,
        createdAt: Date = .now
    ) {
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.priorityRaw = priority.rawValue
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
