import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [WeekDay]
}

enum WeekDay: Int, CaseIterable, Codable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    var fullName: String {
        switch self {
        case .monday: return NSLocalizedString("monday", comment: "Понедельник")
        case .tuesday: return NSLocalizedString("tuesday", comment: "Вторник")
        case .wednesday: return NSLocalizedString("wednesday", comment: "Среда")
        case .thursday: return NSLocalizedString("thursday", comment: "Четверг")
        case .friday: return NSLocalizedString("friday", comment: "Пятница")
        case .saturday: return NSLocalizedString("saturday", comment: "Суббота")
        case .sunday: return NSLocalizedString("sunday", comment: "Воскресенье")
        }
    }
    var shortName: String {
        switch self {
        case .monday: return NSLocalizedString("monday_short", comment: "Сокращенное название дня недели")
        case .tuesday: return NSLocalizedString("tuesday_short", comment: "Сокращенное название дня недели")
        case .wednesday: return NSLocalizedString("wednesday_short", comment: "Сокращенное название дня недели")
        case .thursday: return NSLocalizedString("thursday_short", comment: "Сокращенное название дня недели")
        case .friday: return NSLocalizedString("friday_short", comment: "Сокращенное название дня недели")
        case .saturday: return NSLocalizedString("saturday_short", comment: "Сокращенное название дня недели")
        case .sunday: return NSLocalizedString("sunday_short", comment: "Сокращенное название дня недели")
        }
    }
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}
