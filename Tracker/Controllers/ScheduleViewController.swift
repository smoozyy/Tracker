import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didTapCompleteButton(_ days: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    //MARK: Properties
    weak var delegate: ScheduleViewControllerDelegate?
    private let options = ["Понедельник",
                           "Вторник",
                           "Среда",
                           "Четверг",
                           "Пятница",
                           "Суббота",
                           "Воскресенье"]
    private var selectedDays: [WeekDay] = []
    
    //MARK: UI-elements
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        return table
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(resource: .blackDay)
        label.text = "Расписание"
        return label
        
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(resource: .blackDay)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Готово", for: .normal)
        button.tintColor = UIColor(resource: .whiteDay)
        return button
    }()
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteDay)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SheduleCell")
        
        
        setUpViews()
        setUpConstraints()
    }
    
    //Private methods
    private func setUpViews() {
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(completeButton)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            //TitleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 31),
            //TableView
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            //completeButton
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: Objc-methods
    @objc private func switchChanged(_ sender: UISwitch) {
        let day = WeekDay.allCases[sender.tag]
        
        if sender.isOn {
            selectedDays.append(day)
            print("В массив добавился день: \(day)")
        } else {
            selectedDays.removeAll { $0 == day }
            print("Из массива удалился день: \(day)")
        }
    }
    
    @objc private func completeButtonTapped() {
        delegate?.didTapCompleteButton(selectedDays)
        navigationController?.popViewController(animated: true)
    }

}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleCell", for: indexPath)
        let switchView = UISwitch(frame: .zero)
        switchView.isOn = false
        switchView.onTintColor = .blue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = switchView
        cell.textLabel?.text = options[indexPath.row]
        cell.backgroundColor = UIColor(resource: .backgroundDay)
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
