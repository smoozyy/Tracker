//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Антон on 06.10.2026.
//

import CoreData

final class CoreDataStack {
    
    //MARK: - Properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Не удалось выполнить loadPersistentStores")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //MARK: -Methods
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                context.rollback()
                assertionFailure("Ошибка сохранения в [\(#file)] -> [\(#function)]: \(nserror)")
            }
        }
    }
}
