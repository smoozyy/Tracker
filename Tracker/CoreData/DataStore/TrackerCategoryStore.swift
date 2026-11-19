//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Антон on 08.10.2026.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidUpdate(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    // MARK: - Properties
    let context: NSManagedObjectContext
    var trackerStore = TrackerStore()
    weak var delegate: TrackerCategoryStoreDelegate?
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?

    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }

    convenience override init() {
        self.init(context: CoreDataStack.shared.context)
    }

    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCategoryCoreData.title), ascending: true)]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try? controller.performFetch()
    }

    var categories: [TrackerCategory] {
        guard let objects = fetchedResultsController?.fetchedObjects else { return [] }
        return objects.compactMap { categoryCoreData in
            try? makeCategory(from: categoryCoreData)
        }
    }

    // MARK: - Methods
    func makeCategory(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = categoryCoreData.title else {
            assertionFailure("Failed to get title from TrackerCategoryCoreData")
            throw StoreError.decodingError
        }
        let categoryCoreDataArray = categoryCoreData.trackers?.allObjects as? [TrackerCoreData] ?? []
        let trackers = try categoryCoreDataArray.map { trackerCoreData in
            try trackerStore.makeTracker(from: trackerCoreData)
        }
        return TrackerCategory(title: title, trackers: trackers)
    }

    func addNewCategory(from trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = trackerCategory.title
        try context.save()
    }

    func updateCategory(oldTitle: String, newTitle: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", oldTitle)

        guard let category = try context.fetch(request).first else {
            throw StoreError.decodingError
        }

        category.title = newTitle
        try context.save()
    }

    func deleteCategory(title: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)

        guard let category = try context.fetch(request).first else {
            throw StoreError.decodingError
        }

        let trackers = category.trackers?.allObjects as? [TrackerCoreData] ?? []

        for tracker in trackers {
            let records = tracker.records?.allObjects as? [TrackerRecordCoreData] ?? []

            for record in records {
                context.delete(record)
            }

            context.delete(tracker)
        }

        context.delete(category)
        try context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdate(self)
    }
}

