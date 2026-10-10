//
//  TrackerStore.swift
//  Tracker
//
//  Created by Антон on 08.10.2026.
//

import UIKit
import CoreData

final class TrackerStore {
    //MARK: - Properties
    var context: NSManagedObjectContext
    let daysValueTransformer = DaysValueTransformer()
    let coreDataStack = CoreDataStack()
    
    //MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("Failed to convenience init [\(#file)]")
        }
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    //MARK: - Methods
    func makeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard
            let id = trackerCoreData.id,
            let name = trackerCoreData.name,
            let color = trackerCoreData.color,
            let emoji = trackerCoreData.emoji,
            let schedule = trackerCoreData.schedule as? [WeekDay]
        else{
            assertionFailure("Failed to get data from TrackerCoreData")
            throw StoreError.decodingError
        }
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       schedule: schedule)
    }
    
    func addNewTracker(from tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = daysValueTransformer.transformedValue(tracker.schedule) as? NSObject
        try context.save()
        return trackerCoreData
    }
}
