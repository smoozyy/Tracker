//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Антон on 19.11.2026.
//

import XCTest
import SnapshotTesting
import CoreData
@testable import Tracker

final class TrackerViewControllerSnapshotTests: XCTestCase {

    func testViewController() throws {
        let container = NSPersistentContainer(name: "TrackerModel")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        let expectation = expectation(description: "Загрузка базы")

        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)

        let context = container.viewContext

        let trackerStore = TrackerStore(context: context)
        

        let tracker = Tracker(
            id: UUID(),
            name: "Прочитать 20 страниц",
            color: TrackerColor.color1.rawValue,
            emoji: "📚",
            schedule: WeekDay.allCases,
            isPinned: false
        )

        try trackerStore.add(tracker, withCategory: "Полезные привычки")

        let vc = TrackerViewController(
            trackerStore: trackerStore
        )
        
        assertSnapshots(matching: vc, as: [.image])
    }
}
