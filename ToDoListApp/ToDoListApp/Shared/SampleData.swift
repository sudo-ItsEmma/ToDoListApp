import Foundation
import SwiftData

#if DEBUG
/// Datos de ejemplo solo para Debug. Cubren las 4 secciones, las 3 prioridades, un título largo,
/// un empate de prioridad y hora, y una tarea completada. Se retira cuando exista la pantalla de crear.
enum SampleData {
    static func makeItems(now: Date = .now, calendar: Calendar = .current) -> [TodoItem] {
        let startOfToday = calendar.startOfDay(for: now)
        let endOfToday = startOfToday.addingTimeInterval(24 * 3600 - 60)

        func day(_ offset: Int, hour: Int) -> Date {
            let base = calendar.date(byAdding: .day, value: offset, to: startOfToday) ?? startOfToday
            return base.addingTimeInterval(TimeInterval(hour * 3600))
        }

        return [
            TodoItem(title: "Pagar renta", dueDate: day(-1, hour: 9), priority: .high, createdAt: now.addingTimeInterval(-9000)),
            TodoItem(title: "Llamar al banco", dueDate: now.addingTimeInterval(-2 * 3600), priority: .medium, createdAt: now.addingTimeInterval(-8000)),
            TodoItem(title: "Enviar informe", dueDate: endOfToday, priority: .high, createdAt: now.addingTimeInterval(-7000)),
            TodoItem(title: "Comprar leche", dueDate: endOfToday, priority: .low, createdAt: now.addingTimeInterval(-6000)),
            TodoItem(title: "Regar plantas", dueDate: endOfToday, priority: .low, createdAt: now.addingTimeInterval(-6500)),
            TodoItem(title: "Llamar a Ana", dueDate: day(1, hour: 10), priority: .medium, createdAt: now.addingTimeInterval(-5000)),
            TodoItem(title: "Cita con el dentista", dueDate: day(3, hour: 9), priority: .low, createdAt: now.addingTimeInterval(-4000)),
            TodoItem(title: "Estudiar SwiftData", priority: .medium, createdAt: now.addingTimeInterval(-3000)),
            TodoItem(title: "Ordenar escritorio", priority: .low, createdAt: now.addingTimeInterval(-2000)),
            TodoItem(
                title: "Investigar cómo migrar el esquema de SwiftData cuando cambie el modelo de datos",
                priority: .low,
                createdAt: now.addingTimeInterval(-1500)
            ),
            TodoItem(title: "Tarea completada de ejemplo", priority: .high, isCompleted: true, createdAt: now.addingTimeInterval(-1000)),
        ]
    }

    /// Inserta los datos de ejemplo solo si la base está vacía.
    static func insertIfEmpty(in context: ModelContext) {
        guard let count = try? context.fetchCount(FetchDescriptor<TodoItem>()), count == 0 else { return }
        makeItems().forEach(context.insert)
    }

    /// Contenedor en memoria con datos de ejemplo para los Previews.
    static func previewContainer() -> ModelContainer {
        do {
            let container = try ModelContainer(
                for: TodoItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            insertIfEmpty(in: container.mainContext)
            return container
        } catch {
            fatalError("No se pudo crear el contenedor de Preview: \(error)")
        }
    }
}
#endif
