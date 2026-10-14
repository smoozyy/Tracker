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
        guard let id = trackerCoreData.id else {
            print("Ошибка: поле id равно nil")
            throw StoreError.decodingError
        }
        guard let name = trackerCoreData.name else {
            print("Ошибка: поле name равно nil")
            throw StoreError.decodingError
        }
        guard let color = trackerCoreData.color else {
            print("Ошибка: поле color равно nil")
            throw StoreError.decodingError
        }
        guard let emoji = trackerCoreData.emoji else {
            print("Ошибка: поле emoji равно nil")
            throw StoreError.decodingError
        }
        guard let schedule = trackerCoreData.schedule as? [WeekDay] else {
            print("Ошибка: не удалось привести schedule к типу [WeekDay]. Значение в базе: \(String(describing: trackerCoreData.schedule))")
            throw StoreError.decodingError
        }
        
        
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }

    
    func addNewTracker(from tracker: Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        try context.save()
        return trackerCoreData
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) throws -> R) throws -> R { ///метод гарантирующий работу системы в потоке, которому принадлежит контекст с помощью performAndWait
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait {
            do {
                let value = try action(context)
                result = .success(value)
            } catch {
                result = .failure(error)
            }
        }
        return try result.get()
    }
}

//MARK: - Extensions
extension TrackerStore: TrackerStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
    
    func add(_ tracker: Tracker) throws {
        _ = try performSync { context in
            _ = try self.addNewTracker(from: tracker)
        }
    }
    
    func delete(_ tracker: NSManagedObject) throws {
        try performSync { context in
            context.delete(tracker)
            try context.save()
        }
    }
}
