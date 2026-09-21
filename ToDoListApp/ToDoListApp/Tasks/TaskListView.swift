import OSLog
import SwiftData
import SwiftUI

/// Vista principal: tareas pendientes en secciones automáticas, o las completadas en una lista simple.
/// Las acciones viven en la barra inferior para quedar al alcance del pulgar.
struct TaskListView: View {
    private enum Filter: String, CaseIterable {
        case pending = "Pendientes"
        case completed = "Completadas"
    }

    @Environment(\.modelContext) private var modelContext

    private let reminderScheduler = ReminderScheduler()

    @Query(filter: #Predicate<TodoItem> { !$0.isCompleted })
    private var items: [TodoItem]

    @Query(
        filter: #Predicate<TodoItem> { $0.isCompleted },
        sort: \TodoItem.createdAt,
        order: .reverse
    )
    private var completedItems: [TodoItem]

    @State private var filter = Filter.pending
    @State private var isPresentingForm = false
    @State private var editingItem: TodoItem?

    var body: some View {
        NavigationStack {
            Group {
                switch filter {
                case .pending:
                    if items.isEmpty {
                        ContentUnavailableView(
                            "Sin tareas pendientes",
                            systemImage: "checkmark.circle",
                            description: Text("Las tareas nuevas aparecen aquí.")
                        )
                    } else {
                        taskList
                    }
                case .completed:
                    if completedItems.isEmpty {
                        ContentUnavailableView(
                            "Sin tareas completadas",
                            systemImage: "circle",
                            description: Text("Las tareas que completes aparecen aquí.")
                        )
                    } else {
                        completedList
                    }
                }
            }
            .navigationTitle("Tareas")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Menu {
                        Picker("Vista", selection: $filter) {
                            ForEach(Filter.allCases, id: \.self) { filter in
                                Text(filter.rawValue)
                            }
                        }
                    } label: {
                        Text(filter.rawValue)
                        Image(systemName: "chevron.down")
                    }
                    .menuIndicator(.hidden)
                }

                ToolbarSpacer(.flexible, placement: .bottomBar)

                ToolbarItem(placement: .bottomBar) {
                    Button("Nueva tarea", systemImage: "plus") {
                        isPresentingForm = true
                    }
                }
            }
            .sheet(isPresented: $isPresentingForm) {
                TaskFormView()
            }
            .sheet(item: $editingItem) { item in
                TaskFormView(item: item)
            }
        }
    }

    private var taskList: some View {
        let now = Date.now

        return List {
            ForEach(TaskSectioner.sections(from: items, now: now, calendar: .current)) { group in
                Section(group.section.title) {
                    ForEach(group.items) { item in
                        row(for: item, now: now)
                    }
                }
            }
        }
    }

    private var completedList: some View {
        let now = Date.now

        return List {
            ForEach(completedItems) { item in
                row(for: item, now: now)
            }
        }
    }

    private func row(for item: TodoItem, now: Date) -> some View {
        Button {
            editingItem = item
        } label: {
            TaskRowView(
                item: item,
                now: now,
                onComplete: {
                    withAnimation { item.isCompleted = true }
                    syncReminder(for: item)
                },
                onReopen: {
                    withAnimation { item.isCompleted = false }
                    syncReminder(for: item)
                }
            )
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing) {
            Button("Eliminar", systemImage: "trash", role: .destructive) {
                reminderScheduler.cancel(for: item)
                modelContext.delete(item)
            }
        }
    }

    /// Deja la notificación de la tarea al día: completar la cancela y reabrir con fecha futura la programa de nuevo.
    private func syncReminder(for item: TodoItem) {
        Task {
            do {
                try await reminderScheduler.update(for: item)
            } catch {
                Self.logger.error("No se pudo actualizar el recordatorio de \(item.id): \(error)")
            }
        }
    }

    private static let logger = Logger(subsystem: "com.example.ToDoListApp", category: "Reminders")
}

#Preview("Con datos") {
    TaskListView()
        .modelContainer(SampleData.previewContainer())
}

#Preview("Vacío") {
    TaskListView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
