//
//  TrackerStoreProvider.swift
//  Tracker
//
//  Created by Антон on 12.10.2026.
//

import CoreData
import UIKit

struct TrackerStoreUpdate {
    let insertedIndexes: IndexSet?
    let deletedIndexes: IndexSet?
}

protocol TrackerProviderProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at: IndexPath) -> Tracker?
    func addTracker(_ tracker: Tracker, withCategory: String) throws
    func deleteTracker(at indexPath: IndexPath) throws
    func headerTitle(for section: Int) -> String?
}

protocol TrackerProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}

final class TrackerStoreProvider: NSObject {
    
    //MARK: - Properties
    weak var delegate: TrackerProviderDelegate?
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private let trackerStore: TrackerStore
    
    //MARK: - FetchResultsController
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
            fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()

    init(_ trackerStore: TrackerStore, delegate: TrackerProviderDelegate) throws {
        guard let context = trackerStore.managedObjectContext else {
            throw StoreError.failedToInitializeContext
        }
        self.delegate = delegate
        self.context = context
        self.trackerStore = trackerStore
    }
}

extension TrackerStoreProvider: TrackerProviderProtocol {
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func headerTitle(for section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        return try? trackerStore.makeTracker(from: trackerCoreData)
    }
    
    func addTracker(_ tracker: Tracker, withCategory category: String) throws {
          try trackerStore.add(tracker, withCategory: category)
      }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let tracker = fetchedResultsController.object(at: indexPath)
        try trackerStore.delete(tracker)
    }
}

extension TrackerStoreProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedIndexes = self.insertedIndexes,
            let deletedIndexes = self.deletedIndexes else {
            return
        }
                
        
        delegate?.didUpdate(TrackerStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes
        )
        )
        self.insertedIndexes = nil
        self.deletedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
