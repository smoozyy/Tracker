//
//  Constants.swift
//  Tracker
//
//  Created by Антон on 15.10.2026.
//

import Foundation

enum TrackerConstants {
    static let options = [NSLocalizedString("trackerConstantsCategory", comment: "Переход на экран категории"), NSLocalizedString("trackerConstantsSchedule", comment: "Переход на экран расписание")]
    static let emojiArray = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    static let filterOptions = [
        NSLocalizedString("allTrackers", comment: "Все трекеры"),
        NSLocalizedString("dailyTrackers", comment: "Трекеры на сегодня"),
        NSLocalizedString("completedTrackers", comment: "Завершенные"),
        NSLocalizedString("notCompletedtrackers", comment: "Не завершенные")
    ]
}
