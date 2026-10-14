//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Антон on 08.10.2026.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    var context: NSManagedObjectContext
    var trackerStore = TrackerStore()
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("Failed to convenience init [\(#file)]")
        }
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    func makeNewRecord(from recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerId = recordCoreData.tracker?.id else {
            assertionFailure("Failed to get trackerId")
            throw StoreError.decodingError
        }
        guard let date = recordCoreData.date else {
            assertionFailure("Failed to get date")
            throw StoreError.decodingError
        }
        
        return TrackerRecord(trackerId: trackerId, date: date)
    }
    
    func addNewRecord(from trackerRecord: TrackerRecord, with trackerCoreData: TrackerCoreData) throws -> TrackerRecordCoreData {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = trackerRecord.date
        trackerRecordCoreData.tracker = trackerCoreData
        
        try context.save()
        return trackerRecordCoreData
    }
}
