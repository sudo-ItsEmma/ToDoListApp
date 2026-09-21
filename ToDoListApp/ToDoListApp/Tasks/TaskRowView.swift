import SwiftUI

/// Fila de una tarea. En una pendiente, el círculo la completa; en una completada se muestra marcado y tachada,
/// y el círculo la reabre. El resto de la fila se lee como un solo elemento.
struct TaskRowView: View {
    let item: TodoItem
    let now: Date
    let onComplete: () -> Void
    let onReopen: () -> Void

    /// Se activa al tocar el círculo: muestra el estado contrario un instante antes de mover la tarea de lista.
    @State private var isToggling = false

    private let calendar = Calendar.current

    /// Cómo se ve la fila ahora: el estado real de la tarea, invertido mientras dura el cambio.
    private var showsAsCompleted: Bool {
        item.isCompleted != isToggling
    }

    /// La misma regla que decide si se programa la notificación, para que la campana nunca la contradiga.
    private var hasReminder: Bool {
        ReminderRule.fireDate(dueDate: item.dueDate, isCompleted: item.isCompleted, now: now) != nil
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(
                item.isCompleted ? "Reabrir" : "Completar",
                systemImage: showsAsCompleted ? "checkmark.circle.fill" : "circle"
            ) {
                guard !isToggling else { return }
                withAnimation { isToggling = true }
            }
            .labelStyle(.iconOnly)
            .contentTransition(.symbolEffect(.replace))
            .font(.title3)
            .foregroundStyle(showsAsCompleted ? Color.green : Color.secondary)
            .buttonStyle(.borderless)
            .sensoryFeedback(trigger: isToggling) { _, isToggling -> SensoryFeedback? in
                guard isToggling else { return nil }
                return item.isCompleted ? .selection : .success
            }

            HStack(spacing: 12) {
                Text(item.title)
                    .lineLimit(1)
                    .strikethrough(showsAsCompleted)
                    .foregroundStyle(showsAsCompleted ? Color.secondary : Color.primary)

                Spacer()

                if let dueDate = item.dueDate {
                    HStack(spacing: 4) {
                        if hasReminder {
                            Image(systemName: "bell.fill")
                                .imageScale(.small)
                        }
                        Text(DueDateLabel.text(for: dueDate, now: now, calendar: calendar))
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                PriorityMarkView(priority: item.priority)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityDescription)
        }
        .task(id: isToggling) {
            guard isToggling else { return }
            try? await Task.sleep(for: .milliseconds(450))
            guard !Task.isCancelled else { return }
            if item.isCompleted {
                onReopen()
            } else {
                onComplete()
            }
        }
    }

    /// Ejemplo: "Pagar renta, prioridad alta, vencida, Ayer".
    private var accessibilityDescription: String {
        var parts = [item.title]

        if item.isCompleted {
            parts.append("completada")
        }

        if item.priority != .low {
            parts.append("prioridad \(item.priority.spokenName)")
        }

        if let dueDate = item.dueDate {
            if dueDate < now {
                parts.append("vencida")
            }
            parts.append(DueDateLabel.text(for: dueDate, now: now, calendar: calendar))
            if hasReminder {
                parts.append("con recordatorio")
            }
        }

        return parts.formatted(.list(type: .and, width: .narrow))
    }
}
