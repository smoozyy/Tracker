//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Антон on 12.10.2026.
//

import CoreData

protocol TrackerStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(_ tracker: Tracker, withCategory: String) throws
    func delete(_ tracker: NSManagedObject) throws
    func updatePinStatus(for trackerID: UUID, isPinned: Bool) throws
    func fetchTracker(with id: UUID) throws -> (tracker: Tracker, categoryTitle: String)
    func updateTracker(_ tracker: Tracker, withCategory: String) throws
}
