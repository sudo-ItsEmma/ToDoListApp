import Foundation

/// Texto corto de la fecha de vencimiento que se muestra en la fila.
enum DueDateLabel {
    static func text(for date: Date, now: Date, calendar: Calendar) -> String {
        if calendar.isDate(date, inSameDayAs: now) {
            date.formatted(date: .omitted, time: .shortened)
        } else if calendar.isDate(date, inSameDayAs: yesterday(of: now, calendar: calendar)) {
            String(localized: "Ayer")
        } else if calendar.isDate(date, inSameDayAs: tomorrow(of: now, calendar: calendar)) {
            String(localized: "Mañana")
        } else {
            date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
        }
    }

    private static func yesterday(of date: Date, calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: -1, to: date) ?? date
    }

    private static func tomorrow(of date: Date, calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: 1, to: date) ?? date
    }
}
