import Foundation
import Testing
@testable import ToDoListApp

@MainActor
struct DueDateLabelTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .gmt
        return calendar
    }()

    private func date(day: Int, hour: Int) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 9, day: day, hour: hour)) ?? .distantPast
    }

    @Test func yesterdayReadsAsAyer() {
        let text = DueDateLabel.text(for: date(day: 19, hour: 9), now: date(day: 20, hour: 15), calendar: calendar)
        #expect(text == String(localized: "Ayer"))
    }

    @Test func tomorrowReadsAsMañana() {
        let text = DueDateLabel.text(for: date(day: 21, hour: 9), now: date(day: 20, hour: 15), calendar: calendar)
        #expect(text == String(localized: "Mañana"))
    }

    @Test func todayShowsTimeOnly() {
        let due = date(day: 20, hour: 18)
        let text = DueDateLabel.text(for: due, now: date(day: 20, hour: 15), calendar: calendar)
        #expect(text == due.formatted(date: .omitted, time: .shortened))
    }
}
