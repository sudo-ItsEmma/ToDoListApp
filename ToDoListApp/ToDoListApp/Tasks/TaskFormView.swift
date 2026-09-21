import OSLog
import SwiftData
import SwiftUI
import UIKit

/// Hoja modal para crear una tarea o, si recibe una, editarla.
struct TaskFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    private let item: TodoItem?

    /// El usuario denegó las notificaciones: la tarea se guarda, pero no habrá aviso.
    @State private var notificationsDenied = false

    @State private var title: String
    @State private var notes: String
    @State private var hasDueDate: Bool
    @State private var dueDate: Date
    @State private var priority: Priority

    init(item: TodoItem? = nil) {
        self.item = item
        _title = State(initialValue: item?.title ?? "")
        _notes = State(initialValue: item?.notes ?? "")
        _hasDueDate = State(initialValue: item?.dueDate != nil)
        _dueDate = State(initialValue: item?.dueDate ?? .now)
        _priority = State(initialValue: item?.priority ?? .low)
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Título", text: $title)
                    TextField("Notas", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    Toggle("Fecha límite", isOn: $hasDueDate.animation())
                    if hasDueDate {
                        DatePicker("Vence", selection: $dueDate)
                    }
                    if hasDueDate && notificationsDenied {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                "Las notificaciones están desactivadas. Esta tarea no te avisará.",
                                systemImage: "bell.slash"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                            Button("Abrir Ajustes", action: openSettings)
                        }
                    }
                }

                Section {
                    Picker("Prioridad", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.spokenName.capitalized).tag(priority)
                        }
                    }
                }
            }
            .navigationTitle(item == nil ? "Nueva tarea" : "Editar tarea")
            .navigationBarTitleDisplayMode(.inline)
            .task { await refreshNotificationStatus() }
            .onChange(of: scenePhase) { _, phase in
                // Al volver de Ajustes, el permiso pudo haber cambiado.
                if phase == .active {
                    Task { await refreshNotificationStatus() }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: save)
                        .disabled(trimmedTitle.isEmpty)
                }
            }
        }
    }

    private func refreshNotificationStatus() async {
        notificationsDenied = await ReminderScheduler().isAuthorizationDenied()
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            openURL(url)
        }
    }

    private func save() {
        let savedDueDate = hasDueDate ? dueDate : nil

        let savedItem: TodoItem
        if let item {
            item.title = trimmedTitle
            item.notes = notes
            item.dueDate = savedDueDate
            item.priority = priority
            savedItem = item
        } else {
            savedItem = TodoItem(
                title: trimmedTitle,
                notes: notes,
                dueDate: savedDueDate,
                priority: priority
            )
            modelContext.insert(savedItem)
        }

        syncReminder(for: savedItem)
        dismiss()
    }

    /// Pide el permiso la primera vez que se guarda una tarea con fecha y deja su notificación al día.
    private func syncReminder(for item: TodoItem) {
        Task {
            let scheduler = ReminderScheduler()
            do {
                if item.dueDate != nil {
                    try await scheduler.requestAuthorizationIfNeeded()
                }
                try await scheduler.update(for: item)
            } catch {
                Self.logger.error("No se pudo programar el recordatorio de \(item.id): \(error)")
            }
        }
    }

    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ToDoListApp", category: "Reminders")
}

#Preview {
    TaskFormView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
