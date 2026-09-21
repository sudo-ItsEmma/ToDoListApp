import Foundation
import Testing
@testable import ToDoListApp

@MainActor
struct ReminderRuleTests {
    private let now = Date(timeIntervalSince1970: 1_000_000)

    @Test func pendingTaskWithFutureDateFiresAtDueDate() {
        let due = now.addingTimeInterval(3_600)
        #expect(ReminderRule.fireDate(dueDate: due, isCompleted: false, now: now) == due)
    }

    @Test func taskWithoutDateHasNoReminder() {
        #expect(ReminderRule.fireDate(dueDate: nil, isCompleted: false, now: now) == nil)
    }

    @Test func completedTaskHasNoReminder() {
        let due = now.addingTimeInterval(3_600)
        #expect(ReminderRule.fireDate(dueDate: due, isCompleted: true, now: now) == nil)
    }

    @Test func pastDateHasNoReminder() {
        let due = now.addingTimeInterval(-3_600)
        #expect(ReminderRule.fireDate(dueDate: due, isCompleted: false, now: now) == nil)
    }

    @Test func dateEqualToNowHasNoReminder() {
        #expect(ReminderRule.fireDate(dueDate: now, isCompleted: false, now: now) == nil)
    }
}
