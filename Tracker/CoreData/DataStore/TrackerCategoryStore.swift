//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Антон on 08.10.2026.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    
    //MARK: - Properties
    var context: NSManagedObjectContext
    var trackerStore = TrackerStore()
    
    //MARK: - Init
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("Failed to convenience init [\(#file)]")
        }
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    //MARK: - Methods
    func makeCategory(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = categoryCoreData.title else {
            assertionFailure("Failed to get title from TrackerCategoryCoreData")
            throw StoreError.decodingError
        }
        guard let categoryCoreDataArray = categoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {
            assertionFailure("Failed to get trackers from TrackerCategoryCoreData")
            throw StoreError.decodingError
        }
        let trackers = try categoryCoreDataArray.map {trackerCoreData in
            try trackerStore.makeTracker(from: trackerCoreData)
        }
        return TrackerCategory(title: title, trackers: trackers)
    }
    
    func addNewCategory(from trackerCategory: TrackerCategory) throws -> TrackerCategoryCoreData {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = trackerCategory.title
        
        try context.save()
        return trackerCategoryCoreData
    }
}
