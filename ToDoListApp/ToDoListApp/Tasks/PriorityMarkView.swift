import SwiftUI

/// Marca de prioridad de la fila. La prioridad baja no dibuja nada.
/// La forma del ícono distingue el nivel además del color.
struct PriorityMarkView: View {
    let priority: Priority

    var body: some View {
        if let symbolName = priority.symbolName {
            Image(systemName: symbolName)
                .foregroundStyle(priority == .high ? .red : .orange)
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ForEach(Priority.allCases, id: \.self) { priority in
            HStack {
                Text(priority.spokenName)
                PriorityMarkView(priority: priority)
            }
        }
    }
    .padding()
}
