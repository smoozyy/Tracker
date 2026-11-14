//
//  FilterViewController.swift
//  Tracker
//
//  Created by Антон on 07.11.2026.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func chosenFilter(filter: TrackerFilter)
}

final class FilterViewController: UIViewController {
    //MARK: - Properties
    private let filters: [TrackerFilter] = [
        .all,
        .today,
        .completed,
        .notCompleted
    ]
    private var selectedRow: Int?
    weak var delegate: FilterViewControllerDelegate?
    //MARK: - UI-elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("FilterLabel", comment: "Фильтр надпись")
        label.textColor = UIColor(resource: .forText)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .backgroundDay)
        
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        setUpView()
        setUpConstraints()
    }
    
    //MARK: - Private Methods
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            //TitleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 31),
            // TableView
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 31),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setUpView(){
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
}

//MARK: - DataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterCell.identifier
        ) as? FilterCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = TrackerConstants.filterOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor(resource: .forText)
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.textAlignment = .left
        cell.accessoryType = indexPath.row == selectedRow ? .checkmark : .none
        return cell
    }
}

//MARK: - Delegate
extension FilterViewController: UITableViewDelegate {
    
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
        selectedRow = indexPath.row
        let filter = filters[indexPath.row]
        delegate?.chosenFilter(filter: filter)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}

