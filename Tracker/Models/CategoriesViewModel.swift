//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Антон on 28.10.2026.
//

import Foundation

final class CategoriesViewModel {
    static let shared = CategoriesViewModel()
    var categoryArrayDidChange: (() -> Void)?
    var onButtonStateChanged: ((Bool) -> Void)?
    
    private let trackerCategoryStore: TrackerCategoryStore
    
    private init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
    }
    
    var categories: [TrackerCategory] {
        return trackerCategoryStore.categories
    }
    
    func loadCategories() {
        categoryArrayDidChange?()
    }

    func saveCategory(_ name: String) {
        let trimmedText = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty else { return }
        let newCategory = TrackerCategory(title: trimmedText, trackers: [])
        try? trackerCategoryStore.addNewCategory(from: newCategory)
    }
    
    func updateCategoryName(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        let isEnabled = !trimmedText.isEmpty && trimmedText.count < 38
        onButtonStateChanged?(isEnabled)
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
        categoryArrayDidChange?()
    }
}
