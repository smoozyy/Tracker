import UIKit

class TrackerViewController: UIViewController {
    
    //MARK: Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []

    //MARK: UI-Elements
    private let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .plusButton), for: .normal)
        return button
    }()
    
    private let trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let searchField: UISearchTextField = {
        let textField = UISearchTextField()
        let searchBarIcon = UIImageView(image: UIImage(resource: .searchIcon))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = searchBarIcon
        textField.leftViewMode = .always
        textField.backgroundColor = .color
        textField.text = "Поиск"
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()
    
    private let starImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .star))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrackerCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerCellHeader.identifier)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let mockTracker = Tracker(id: UUID(), name: "ТЕСТ", color: "ColorSection1" , emoji: "😩", shedule: [.monday, .tuersday, .wednesday, .thursday, .friday, .saturday, .sunday])
        categories = [TrackerCategory(title: "Домашний уют", trackers: [mockTracker])
        ]
        collectionView.reloadData()
        updatePlaceholder()
        
        
        setupViews()
        setupConstraints()
    }
        
    //MARK: Private methods
    
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
        let isNoTrackers = categories.isEmpty || categories.allSatisfy { $0.trackers.isEmpty }
        
        starImage.isHidden = !isNoTrackers
        questionLabel.isHidden = !isNoTrackers
        collectionView.isHidden = isNoTrackers
    }
    
    //MARK: Objc methods
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateformatter.string(from: selectedDate)
        print("Выбранная дата:\(formattedDate)")
    }
    
    @objc private func didTapPlusButton() {
        let createHabbitVC = CreateHabbitViewController()
        let navController = UINavigationController(rootViewController: createHabbitVC)
        present(navController, animated: true)
    }

}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let pickerDate = Calendar.current.startOfDay(for: datePicker.date)
        let isCompleted = completedTrackers.contains { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: pickerDate)
        }
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
        cell.configure(isCompleted: isCompleted, completedDays: completedDays, tracker: tracker)
        return cell
    }
}

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

extension TrackerViewController: TrackerCellDelegate {
    func trackerCellDidTapPlus(_ cell: TrackerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let choosenTracker = categories[indexPath.section].trackers[indexPath.row]
        print("получаем трекер")
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let pickerDate = calendar.startOfDay(for: datePicker.date)
        if currentDate < pickerDate {
            return
        }
        if let index = completedTrackers.firstIndex(where: { $0.trackerId == choosenTracker.id && Calendar.current.isDate($0.date, inSameDayAs: pickerDate) }) {
            completedTrackers.remove(at: index)
            print("удаляем рекорд")
        } else {
            let newRecord = TrackerRecord(trackerId: choosenTracker.id, date: pickerDate)
            completedTrackers.append(newRecord)
            print("добавляем новый рекорд")
        }
        collectionView.reloadItems(at: [indexPath])
        print("перезагружаем ячейку")
    }
}
