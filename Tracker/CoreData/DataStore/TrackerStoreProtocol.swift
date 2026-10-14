//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Антон on 12.10.2026.
//

import CoreData

protocol TrackerStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(_ tracker: Tracker) throws
    func delete(_ tracker: NSManagedObject) throws
}
