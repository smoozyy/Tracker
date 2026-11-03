
import UIKit

struct CategoryCellViewModel {
    let title: String
    let isSelected: Bool
}

final class CategoriesViewModel {
    //MARK: - Properties
    static let shared = CategoriesViewModel()
    var categoryArrayDidChange: (() -> Void)?
    var onButtonStateChanged: ((Bool) -> Void)?
    var onCategorySelected: ((String) -> Void)?
    private let trackerCategoryStore: TrackerCategoryStore
    private(set) var selectedCategory: String?
    private init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
    }
    
    //MARK: - Methods
    var categories: [TrackerCategory] {
        return trackerCategoryStore.categories
    }
    
    func numberOfCategories() -> Int {
        categories.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel? {
        guard categories.indices.contains(indexPath.row) else {
            return nil
        }
        
        let category = categories[indexPath.row]
        
        return CategoryCellViewModel(
            title: category.title,
            isSelected: category.title == selectedCategory
        )
    }
    
    func selectCategory(at index: Int) {
        guard categories.indices.contains(index) else {
            return
        }
        
        let category = categories[index]
        selectedCategory = category.title
        
        categoryArrayDidChange?()
        onCategorySelected?(category.title)
    }
    
    func loadCategories() {
        categoryArrayDidChange?()
    }
    
    func saveCategory(_ name: String) {
        let trimmedText = name.trimmingCharacters(in: .whitespaces)
        
        guard isValidCategoryName(trimmedText) else {
            return
        }
        
        let newCategory = TrackerCategory(
            title: trimmedText,
            trackers: []
        )
        
        do {
            try trackerCategoryStore.addNewCategory(from: newCategory)
        } catch {
            print("Не удалось сохранить категорию: \(error)")
        }
    }
    
    private func isValidCategoryName(_ name: String) -> Bool {
        !name.isEmpty && name.count < 38
    }
    
    func updateCategoryName(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        let isEnabled = isValidCategoryName(trimmedText)
        
        onButtonStateChanged?(isEnabled)
    }
}

    //MARK: - TrackerCategoryStoreDelegate
extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
        categoryArrayDidChange?()
    }
}
