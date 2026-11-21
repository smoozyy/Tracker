import Foundation

enum TrackerFilter {
    case all
    case today
    case completed
    case notCompleted
    
    func filtered(
        trackers: [Tracker],
        completedTrackers: [TrackerRecord],
        date: Date
    ) -> [Tracker] {
        
        let weekDay = Calendar.current.component(.weekday, from: date)
        let trackerWeekDay = WeekDay(rawValue: weekDay == 1 ? 7 : weekDay - 1)
        guard let trackerWeekDay else {
            return []
        }
        switch self {
        case .all:
            return trackers
        case .today:
            return trackers.filter { tracker in
                tracker.schedule.contains(trackerWeekDay)
            }
        case .completed:
            return trackers.filter { tracker in
                completedTrackers.contains { record in
                    record.trackerId == tracker.id &&
                    Calendar.current.isDate(record.date, inSameDayAs: date)
                }
            }
        case .notCompleted:
            return trackers.filter { tracker in
                tracker.schedule.contains(trackerWeekDay) &&
                !completedTrackers.contains { record in
                    record.trackerId == tracker.id &&
                    Calendar.current.isDate(record.date, inSameDayAs: date)
                }
            }
        }
    }
}
