import UIKit

final class TrackerViewController: UIViewController, CreateHabitViewDelegate {
    
    //MARK: - Properties
    private let trackerRecordStore = TrackerRecordStore()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    var completedTrackers: [TrackerRecord] = []
    private let trackerStore: TrackerStore
    
    init(trackerStore: TrackerStore) {
        self.trackerStore = trackerStore
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private lazy var trackerProvider: TrackerProviderProtocol? = {
        do {
            let provider = try TrackerStoreProvider(trackerStore, delegate: self)
            return provider
        } catch {
            print("Не удалось инициализировать провайдер: \(error)")
            return nil
        }
    }()
    
    
    //MARK: - UI-Elements
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .plusButton), for: .normal)
        return button
    }()
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var searchField: UISearchTextField = {
        let textField = UISearchTextField()
        let searchBarIcon = UIImageView(image: UIImage(resource: .searchIcon))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = searchBarIcon
        textField.leftViewMode = .always
        textField.backgroundColor = .color
        textField.text = "Поиск"
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()
    
    private lazy var starImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .star))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        completedTrackers = (try? trackerRecordStore.fetchRecords()) ?? []
        view.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackerCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerCellHeader.identifier)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
        updatePlaceholder()
        
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Private methods
    private func setupViews() {
        view.addSubview(trackerLabel)
        view.addSubview(plusButton)
        view.addSubview(searchField)
        view.addSubview(datePicker)
        view.addSubview(starImage)
        view.addSubview(questionLabel)
        view.addSubview(collectionView)
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //TrackerLabel
            trackerLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            trackerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            //PlusButton
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            //SearchField
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            //DatePicker
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            //StarImage
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            //QuestionLabel
            questionLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.heightAnchor.constraint(equalToConstant: 18),
            //CollectionView
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updatePlaceholder() {
        let sectionsCount = trackerProvider?.numberOfSections ?? 0
        var totalItems = 0
        for section in 0..<sectionsCount {
            totalItems += trackerProvider?.numberOfRowsInSection(section) ?? 0
        }
        let isNoTrackers = totalItems == 0
        
        starImage.isHidden = !isNoTrackers
        questionLabel.isHidden = !isNoTrackers
        collectionView.isHidden = isNoTrackers
    }
    
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        let pickerDate = Calendar.current.startOfDay(for: datePicker.date)
        return completedTrackers.contains { record in
            record.trackerId == id && Calendar.current.isDate(record.date, inSameDayAs: pickerDate)
        }
    }
    
    //MARK: - Methods
    func didCreateTracker(_ tracker: Tracker) {
        do {
            try trackerProvider?.addTracker(tracker)
        } catch {
            print("Не удалось добавить трекер: \(error)")
        }
    }
    
    //MARK: - Objc methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateformatter.string(from: selectedDate)
        print("Выбранная дата:\(formattedDate)")
        collectionView.reloadData()
    }
    
    @objc private func didTapPlusButton() {
        let createHabbitVC = CreateHabitViewController()
        createHabbitVC.delegate = self
        let navController = UINavigationController(rootViewController: createHabbitVC)
        present(navController, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerProvider?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerProvider?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        guard let tracker = trackerProvider?.object(at: indexPath) else {
            return cell
        }
        
        let isCompleted = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
        cell.configure(isCompleted: isCompleted, completedDays: completedDays, tracker: tracker)
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCellHeader.identifier, for: indexPath) as? TrackerCellHeader else {
            return UICollectionReusableView()
        }
        header.titleLabel.text = "Домашний уют"
        return header
    }
}

//MARK: - TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func trackerCellDidTapPlus(_ cell: TrackerCell) {
        guard
            let indexPath = collectionView.indexPath(for: cell),
            let choosenTracker = trackerProvider?.object(at: indexPath) else {
            return
        }
        
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let pickerDate = calendar.startOfDay(for: datePicker.date)
        guard pickerDate <= currentDate else { return }
        
        let record = TrackerRecord(trackerId: choosenTracker.id, date: pickerDate)
        
        do {
            if let index = completedTrackers.firstIndex(where: { $0.trackerId == choosenTracker.id && calendar.isDate($0.date, inSameDayAs: pickerDate) }) {
                completedTrackers.remove(at: index)
                try trackerRecordStore.remove(record)
            } else {
                completedTrackers.append(record)
                try trackerRecordStore.add(record)
            }
            collectionView.reloadItems(at: [indexPath])
        } catch {
            print("Ошибка обновления рекорда: \(error)")
        }
    }
}

// MARK: - TrackerProviderDelegate
extension TrackerViewController: TrackerProviderDelegate {
    func didUpdate(_ update: TrackerStoreUpdate) {
        collectionView.performBatchUpdates({
            if let insertedIndexes = update.insertedIndexes, !insertedIndexes.isEmpty {
                collectionView.insertItems(at: insertedIndexes.map { IndexPath(item: $0, section: 0) })
            }
            if let deletedIndexes = update.deletedIndexes, !deletedIndexes.isEmpty {
                collectionView.deleteItems(at: deletedIndexes.map { IndexPath(item: $0, section: 0) })
            }
        }, completion: nil)
        
        updatePlaceholder()
    }
}
