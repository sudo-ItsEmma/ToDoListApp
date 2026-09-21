import UserNotifications

/// Hace que iOS muestre la notificación aunque la app esté abierta; por defecto solo la muestra en segundo plano.
/// `UNUserNotificationCenter` guarda su delegado sin retenerlo, así que se conserva en `shared`.
@MainActor
final class ReminderNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = ReminderNotificationDelegate()

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
