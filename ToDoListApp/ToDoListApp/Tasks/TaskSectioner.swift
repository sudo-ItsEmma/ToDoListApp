import Foundation

/// Reglas de agrupación y orden de la vista de pendientes.
/// Es lógica pura: recibe `now` y `calendar` para poder probarla sin depender del reloj.
enum TaskSectioner {
    /// Agrupa las tareas pendientes en secciones y las ordena. Omite las secciones vacías
    /// y las tareas completadas.
    static func sections(from items: [TodoItem], now: Date, calendar: Calendar) -> [TaskSectionGroup] {
        let pending = items.filter { !$0.isCompleted }
        let bySection = Dictionary(grouping: pending) { section(for: $0, now: now, calendar: calendar) }

        return TaskSection.allCases.compactMap { section in
            guard let sectionItems = bySection[section] else { return nil }
            return TaskSectionGroup(section: section, items: sectionItems.sorted { isOrderedBefore($0, $1) })
        }
    }

    /// Una tarea cuya fecha es exactamente `now` cuenta como "Hoy", no como vencida.
    static func section(for item: TodoItem, now: Date, calendar: Calendar) -> TaskSection {
        guard let dueDate = item.dueDate else { return .noDate }

        if dueDate < now {
            return .overdue
        } else if calendar.isDate(dueDate, inSameDayAs: now) {
            return .today
        } else {
            return .upcoming
        }
    }

    /// Prioridad (alta primero), luego vencimiento (más próximo primero), luego creación.
    private static func isOrderedBefore(_ lhs: TodoItem, _ rhs: TodoItem) -> Bool {
        if lhs.priority != rhs.priority {
            return lhs.priority > rhs.priority
        }

        switch (lhs.dueDate, rhs.dueDate) {
        case let (lhsDate?, rhsDate?) where lhsDate != rhsDate:
            return lhsDate < rhsDate
        case (_?, nil):
            return true
        case (nil, _?):
            return false
        default:
            return lhs.createdAt < rhs.createdAt
        }
    }
}
