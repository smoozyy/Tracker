
    import UIKit
    import CoreData

    final class TrackerStore {
        
        // MARK: - Properties
        
        let context: NSManagedObjectContext
        let daysValueTransformer = DaysValueTransformer()
        
        // MARK: - Init
        
        init(context: NSManagedObjectContext) {
            self.context = context
        }
        
        convenience init() {
            self.init(context: CoreDataStack.shared.context)
        }
        
        // MARK: - Methods
        
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
                schedule: schedule,
                isPinned: trackerCoreData.isPinned
            )
        }
        
        func fetchTracker() throws -> [Tracker] {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            let trackers = try context.fetch(fetchRequest)
            
            return try trackers.map { tracker in
                guard let trackerID = tracker.id,
                      let trackerName = tracker.name,
                      let trackerColor = tracker.color,
                      let trackerEmoji = tracker.emoji,
                      let trackerSchedule = tracker.schedule as? [WeekDay] else {
                    throw StoreError.decodingError
                }
                
                let trackerIsPinned = tracker.isPinned
                
                return Tracker(
                    id: trackerID,
                    name: trackerName,
                    color: trackerColor,
                    emoji: trackerEmoji,
                    schedule: trackerSchedule,
                    isPinned: trackerIsPinned
                )
            }
        }
        
        func fetchTracker(with id: UUID) throws -> (tracker: Tracker, categoryTitle: String) {
            try performSync { context in
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                let trackers = try context.fetch(request)
                
                guard let trackerCoreData = trackers.first else {
                    throw StoreError.decodingError
                }
                
                let tracker = try makeTracker(from: trackerCoreData)
                
                guard let categoryTitle = trackerCoreData.category?.title else {
                    throw StoreError.decodingError
                }
                
                return (tracker: tracker, categoryTitle: categoryTitle)
            }
        }
        
        func updateTracker(_ tracker: Tracker, withCategory categoryTitle: String) throws {
            try performSync { context in
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
                
                let trackers = try context.fetch(request)
                
                guard let trackerCoreData = trackers.first else {
                    throw StoreError.decodingError
                }
                
                trackerCoreData.name = tracker.name
                trackerCoreData.color = tracker.color
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.schedule = tracker.schedule as NSObject
                trackerCoreData.isPinned = tracker.isPinned
                
                let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
                categoryRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
                
                let categories = try context.fetch(categoryRequest)
                
                let category: TrackerCategoryCoreData
                
                if let existingCategory = categories.first {
                    category = existingCategory
                } else {
                    let newCategory = TrackerCategoryCoreData(context: context)
                    newCategory.title = categoryTitle
                    category = newCategory
                }
                
                trackerCoreData.category = category
                
                try context.save()
            }
        }
        
        func addNewTracker(from tracker: Tracker, withCategory categoryTitle: String) throws -> TrackerCoreData {
            let trackerCoreData = TrackerCoreData(context: context)
            
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.color = tracker.color
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule as NSObject
            trackerCoreData.isPinned = tracker.isPinned
            
            let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
            
            let categories = try context.fetch(fetchRequest)
            
            let categoryCoreData: TrackerCategoryCoreData
            
            if let existingCategory = categories.first {
                categoryCoreData = existingCategory
            } else {
                let newCategory = TrackerCategoryCoreData(context: context)
                newCategory.title = categoryTitle
                categoryCoreData = newCategory
            }
            
            trackerCoreData.category = categoryCoreData
            
            try context.save()
            
            return trackerCoreData
        }
        
        private func performSync<R>(_ action: (NSManagedObjectContext) throws -> R) throws -> R {
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

    // MARK: - Extensions

    extension TrackerStore: TrackerStoreProtocol {
        
        var managedObjectContext: NSManagedObjectContext? {
            context
        }
        
        func add(_ tracker: Tracker, withCategory category: String) throws {
            _ = try performSync { context in
                _ = try self.addNewTracker(from: tracker, withCategory: category)
            }
        }
        
        func delete(_ tracker: NSManagedObject) throws {
            try performSync { context in
                if let trackerCoreData = tracker as? TrackerCoreData {
                    let records = trackerCoreData.records?.allObjects as? [TrackerRecordCoreData] ?? []
                    
                    for record in records {
                        context.delete(record)
                    }
                }
                
                context.delete(tracker)
                try context.save()
            }
        }
        
        func updatePinStatus(for trackerID: UUID, isPinned: Bool) throws {
            try performSync { context in
                let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
                
                let trackers = try context.fetch(fetchRequest)
                
                guard let tracker = trackers.first else {
                    throw StoreError.decodingError
                }
                
                tracker.isPinned = isPinned
                
                try context.save()
            }
        }
    }
