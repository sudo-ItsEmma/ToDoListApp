import Foundation
import Testing
@testable import ToDoListApp

@MainActor
struct TaskSectionerTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .gmt
        return calendar
    }()

    /// Sábado 20 de septiembre de 2026, 15:00 UTC.
    private var now: Date { date(day: 20, hour: 15) }

    private func date(day: Int, hour: Int, minute: Int = 0) -> Date {
        let components = DateComponents(year: 2026, month: 9, day: day, hour: hour, minute: minute)
        return calendar.date(from: components) ?? .distantPast
    }

    private func item(
        _ title: String,
        due: Date? = nil,
        priority: Priority = .low,
        completed: Bool = false,
        created: Date = Date(timeIntervalSince1970: 0)
    ) -> TodoItem {
        TodoItem(title: title, dueDate: due, priority: priority, isCompleted: completed, createdAt: created)
    }

    private func sections(_ items: [TodoItem]) -> [TaskSectionGroup] {
        TaskSectioner.sections(from: items, now: now, calendar: calendar)
    }

    private func titles(of section: TaskSection, in groups: [TaskSectionGroup]) -> [String] {
        groups.first { $0.section == section }?.items.map(\.title) ?? []
    }

    // MARK: - Secciones

    @Test func placesOneTaskInEachSection() {
        let groups = sections([
            item("sin fecha"),
            item("próxima", due: date(day: 22, hour: 9)),
            item("hoy", due: date(day: 20, hour: 18)),
            item("vencida", due: date(day: 19, hour: 9)),
        ])

        #expect(groups.map(\.section) == [.overdue, .today, .upcoming, .noDate])
        #expect(titles(of: .overdue, in: groups) == ["vencida"])
        #expect(titles(of: .today, in: groups) == ["hoy"])
        #expect(titles(of: .upcoming, in: groups) == ["próxima"])
        #expect(titles(of: .noDate, in: groups) == ["sin fecha"])
    }

    @Test func dueDateEqualToNowIsToday() {
        let groups = sections([item("justo ahora", due: now)])
        #expect(groups.map(\.section) == [.today])
    }

    @Test func earlierTodayIsOverdue() {
        let groups = sections([item("hace una hora", due: date(day: 20, hour: 14))])
        #expect(groups.map(\.section) == [.overdue])
    }

    @Test func oneMinuteBeforeMidnightIsTodayAndMidnightIsUpcoming() {
        let groups = sections([
            item("23:59", due: date(day: 20, hour: 23, minute: 59)),
            item("00:00", due: date(day: 21, hour: 0)),
        ])

        #expect(titles(of: .today, in: groups) == ["23:59"])
        #expect(titles(of: .upcoming, in: groups) == ["00:00"])
    }

    @Test func omitsEmptySections() {
        let groups = sections([item("solo sin fecha")])
        #expect(groups.map(\.section) == [.noDate])
    }

    @Test func emptyInputProducesNoSections() {
        #expect(sections([]).isEmpty)
    }

    @Test func excludesCompletedTasks() {
        let groups = sections([
            item("completada", due: date(day: 19, hour: 9), completed: true),
            item("pendiente"),
        ])

        #expect(groups.map(\.section) == [.noDate])
        #expect(titles(of: .noDate, in: groups) == ["pendiente"])
    }

    // MARK: - Orden dentro de la sección

    @Test func ordersByPriorityHighFirst() {
        let due = date(day: 20, hour: 18)
        let groups = sections([
            item("baja", due: due, priority: .low),
            item("alta", due: due, priority: .high),
            item("media", due: due, priority: .medium),
        ])

        #expect(titles(of: .today, in: groups) == ["alta", "media", "baja"])
    }

    @Test func ordersByDueDateWhenPriorityMatches() {
        let groups = sections([
            item("tarde", due: date(day: 20, hour: 20)),
            item("temprano", due: date(day: 20, hour: 16)),
        ])

        #expect(titles(of: .today, in: groups) == ["temprano", "tarde"])
    }

    @Test func ordersByCreationDateWhenPriorityAndDueDateMatch() {
        let due = date(day: 20, hour: 18)
        let groups = sections([
            item("creada después", due: due, created: date(day: 18, hour: 10)),
            item("creada antes", due: due, created: date(day: 17, hour: 10)),
        ])

        #expect(titles(of: .today, in: groups) == ["creada antes", "creada después"])
    }

    @Test func priorityBeatsDueDate() {
        let groups = sections([
            item("baja temprano", due: date(day: 20, hour: 16), priority: .low),
            item("alta tarde", due: date(day: 20, hour: 22), priority: .high),
        ])

        #expect(titles(of: .today, in: groups) == ["alta tarde", "baja temprano"])
    }

    @Test func noDateTasksOrderByPriorityThenCreation() {
        let groups = sections([
            item("baja vieja", priority: .low, created: date(day: 1, hour: 0)),
            item("alta nueva", priority: .high, created: date(day: 10, hour: 0)),
            item("baja nueva", priority: .low, created: date(day: 5, hour: 0)),
        ])

        #expect(titles(of: .noDate, in: groups) == ["alta nueva", "baja vieja", "baja nueva"])
    }
}
