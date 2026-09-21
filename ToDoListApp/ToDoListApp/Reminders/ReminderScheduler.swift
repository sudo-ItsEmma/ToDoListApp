import Foundation
import UserNotifications

/// Único lugar que programa y cancela las notificaciones de las tareas (ADR-004).
/// La notificación de cada tarea se identifica con el `id` de la tarea, así que programar de nuevo la reemplaza.
struct ReminderScheduler {
    private let center = UNUserNotificationCenter.current()

    /// `true` si el usuario denegó el permiso de notificaciones. iOS no vuelve a preguntar: solo se activa desde Ajustes.
    func isAuthorizationDenied() async -> Bool {
        await center.notificationSettings().authorizationStatus == .denied
    }

    /// Pide el permiso de notificaciones solo si el usuario aún no ha respondido. Si ya respondió, no hace nada.
    func requestAuthorizationIfNeeded() async throws {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .notDetermined else { return }
        _ = try await center.requestAuthorization(options: [.alert, .sound])
    }

    /// Deja la notificación de la tarea al día: la programa o reprograma si le corresponde recordatorio,
    /// y la cancela si no (sin fecha, fecha pasada o tarea completada).
    func update(for item: TodoItem, now: Date = .now) async throws {
        guard let fireDate = ReminderRule.fireDate(
            dueDate: item.dueDate,
            isCompleted: item.isCompleted,
            now: now
        ) else {
            cancel(for: item)
            return
        }

        let content = UNMutableNotificationContent()
        content.title = item.title
        if !item.notes.isEmpty {
            content.body = item.notes
        }
        content.sound = .default

        // Suena al inicio del minuto que muestra la fila, aunque la fecha guardada tenga segundos.
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: fireDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    /// Cancela la notificación de la tarea, si tenía una pendiente.
    func cancel(for item: TodoItem) {
        center.removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
}
