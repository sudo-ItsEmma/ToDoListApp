import Foundation

/// Regla de cuándo una tarea debe tener recordatorio: solo si está pendiente y su fecha de vencimiento aún no llega.
enum ReminderRule {
    /// Fecha en que debe sonar la notificación, o `nil` si la tarea no debe tener recordatorio.
    static func fireDate(dueDate: Date?, isCompleted: Bool, now: Date) -> Date? {
        guard !isCompleted, let dueDate, dueDate > now else { return nil }
        return dueDate
    }
}
