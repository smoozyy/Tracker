import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [WeekDay]
}

enum WeekDay: Int, CaseIterable {
    case monday = 1, tuersday, wednesday, thursday, friday, saturday, sunday
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}
