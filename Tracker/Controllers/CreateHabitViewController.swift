import UIKit

protocol CreateHabitViewDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker)
}

final class CreateHabitViewController: UIViewController, ScheduleViewControllerDelegate {
    
    //MARK: - Properties
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    private var selectedColorIndex: Int?
    private var selectedEmojiIndex: Int?
    private var scheduleSubtitle: String?
    let habitCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: CreateHabitViewDelegate?
    private var selectedDays: [WeekDay] = []
    private let options = ["Категория", "Расписание"]
    private let emojiArray = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    //MARK: - UI-elements
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        return table
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDay
        label.textAlignment = .center
        label.text = "Новая привычка"
        return label
    }()
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 16
        text.placeholder = "Введите название трекера"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.leftView = paddingView
        text.leftViewMode = .always
        text.backgroundColor = .backgroundDay
        return text
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .red).cgColor
        button.backgroundColor = .whiteDay
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(resource: .red), for: .normal)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(resource: .GRAY)
        button.tintColor = UIColor(resource: .whiteDay)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteDay)
        
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
        habitCollectionView.translatesAutoresizingMaskIntoConstraints = false
        habitCollectionView.dataSource = self
        habitCollectionView.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        updateCreateButtonStyle()
        setUpViews()
        constraintsActivate()
    }
    
    //MARK: - Methods
    func registerCell() {
        habitCollectionView.register(HabitCell.self, forCellWithReuseIdentifier: HabitCell.habitIdentifier)
        habitCollectionView.register(HabitEmojiHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitEmojiHeader.identifier)
    }
    
    func didTapCompleteButton(_ days: [WeekDay]) {
        self.selectedDays = days
        updateCreateButtonStyle()
        if days.count == 7 {
            scheduleSubtitle = "Каждый день"
        } else {
            scheduleSubtitle = days.map { $0.shortName }.joined(separator: ", ")
        }
        tableView.reloadData()
    }
    
    //MARK: - Private Methods
    private func updateCreateButtonStyle() {
        let hasText = !(textField.text?.isEmpty ?? true)
        let hasSchedule = !selectedDays.isEmpty
        let hasEmoji = selectedEmoji != nil
        let hasColor = selectedColor != nil
        
        if hasText && hasSchedule && hasEmoji && hasColor {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(resource: .blackDay)
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(resource: .GRAY)
        }
    }
    
    private func setUpViews() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        view.addSubview(tableView)
        view.addSubview(habitCollectionView)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func constraintsActivate() {
        NSLayoutConstraint.activate([
            //TitleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 31),
            //TextField
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.widthAnchor.constraint(equalToConstant: 343),
            textField.heightAnchor.constraint(equalToConstant: 75),
            //CancelButton
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            //CreateButton
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            //TableView
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            //HabitCollectionView
            habitCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            habitCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            habitCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            habitCollectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16)
        ])
    }
    
    //MARK: - Objc private methods
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let titleText = textField.text, !titleText.isEmpty else { return }
        guard let selectedEmoji = selectedEmoji else {return}
        guard let selectedColorIndex = selectedColorIndex else {return}
        let colorName = TrackerColor.allCases[selectedColorIndex].rawValue
        let newTracker = Tracker(
            id: UUID(),
            name: titleText,
            color: colorName,
            emoji: selectedEmoji,
            schedule: selectedDays
        )
        delegate?.didCreateTracker(newTracker)
        dismiss(animated: true)
    }

    @objc private func textFieldDidChange() {
        updateCreateButtonStyle()
    }
}

//MARK: - UICollectionViewDataSource
extension CreateHabitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojiArray.count
        } else {
            return TrackerColor.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCell.habitIdentifier, for: indexPath) as? HabitCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            let emojiTitleLabel = emojiArray[indexPath.row]
            let isSelectedEmoji = (selectedEmojiIndex != nil) && (indexPath.row == selectedEmojiIndex)
            habitCell.configureEmoji(emojiTitleLabel: emojiTitleLabel, isSelectedEmoji: isSelectedEmoji)
            return habitCell
        } else {
            let colorView = TrackerColor.allCases[indexPath.row]
            let isSelectedColor = (selectedColorIndex != nil) && (indexPath.row == selectedColorIndex)
            habitCell.configureColor(colorView: colorView.color, isSelectedColor: isSelectedColor)
            return habitCell
        }
    }
}

    //MARK: - UICollectionViewDelegateFlowLayout
extension CreateHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let boundsWidth = collectionView.bounds.width - 62
        return CGSize(width: boundsWidth / 6, height: 52)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.section == 0 {
            selectedEmoji = emojiArray[indexPath.row]
            selectedEmojiIndex = indexPath.row
            print("Выбран эмодзи - \(String(describing: selectedEmoji))")
        } else {
            selectedColor = TrackerColor.allCases[indexPath.row].color
            selectedColorIndex = indexPath.row
            print("Выбран цвет - \(String(describing: selectedColor))")
        }
        
        updateCreateButtonStyle()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HabitEmojiHeader.identifier, for: indexPath) as? HabitEmojiHeader else {
            return UICollectionReusableView()
        }
        if indexPath.section == 0{
            header.titleLabel.text = "Emoji"
        } else {
            header.titleLabel.text = "Цвет"
        }
        return  header
    }
}

    //MARK: - UITableViewDataSource
extension CreateHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle ,reuseIdentifier: "cell")
        
        cell.textLabel?.text = options[indexPath.row]
        cell.backgroundColor = UIColor(resource: .backgroundDay)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = nil
        } else if indexPath.row == 1 {
            cell.detailTextLabel?.text = scheduleSubtitle
            cell.detailTextLabel?.textColor = .gray
            cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        }
        return cell
    }
}

    //MARK: - UITableViewDelegate
extension CreateHabitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
    }
}
