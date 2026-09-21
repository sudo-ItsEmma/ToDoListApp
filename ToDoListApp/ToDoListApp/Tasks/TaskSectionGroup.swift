import Foundation

/// Una sección con sus tareas ya ordenadas.
struct TaskSectionGroup: Identifiable {
    let section: TaskSection
    let items: [TodoItem]

    var id: TaskSection { section }
}
