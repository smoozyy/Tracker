//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Антон on 08.10.2026.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    let context: NSManagedObjectContext
    var trackerStore = TrackerStore()
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    convenience init() {
        self.init(context: CoreDataStack.shared.context)
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
    func fetchRecords() throws -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let recordsCD = try context.fetch(request)
        return try recordsCD.map { recordCD in
            guard let trackerId = recordCD.tracker?.id, let date = recordCD.date else {
                throw StoreError.decodingError
            }
            return TrackerRecord(trackerId: trackerId, date: date)
        }
    }
    
    func add(_ record: TrackerRecord) throws {
        let trackersRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let allTrackers = try context.fetch(trackersRequest)
        
        guard let trackerCD = allTrackers.first(where: { $0.id == record.trackerId }) else {
            throw StoreError.decodingError
        }
        
        let recordCD = TrackerRecordCoreData(context: context)
        recordCD.date = record.date
        recordCD.tracker = trackerCD
        
        try context.save()
    }
    
    func remove(_ record: TrackerRecord) throws {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let allRecords = try context.fetch(request)
        let calendar = Calendar.current
        
        let recordsToDelete = allRecords.filter { recordCD in
            guard let trackerId = recordCD.tracker?.id, let recordDate = recordCD.date else {
                return false
            }
            return trackerId == record.trackerId && calendar.isDate(recordDate, inSameDayAs: record.date)
        }
        
        recordsToDelete.forEach { context.delete($0) }
        try context.save()
    }
}

