import Foundation

/// Secciones automáticas de la vista de pendientes, en el orden en que se muestran.
enum TaskSection: CaseIterable {
    case overdue
    case today
    case upcoming
    case noDate

    var title: LocalizedStringResource {
        switch self {
        case .overdue: "Vencidas"
        case .today: "Hoy"
        case .upcoming: "Próximas"
        case .noDate: "Sin fecha"
        }
    }
}
