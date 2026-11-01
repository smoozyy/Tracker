//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Антон on 28.10.2026.
//

import UIKit

final class CategoriesViewController: UIViewController {
    //MARK: - Properties
    var selectCategoryHandler: ((String) -> Void)?
    var selectedCategory: String?
    var selectedCategoryIndex: Int?
    let viewModel = CategoriesViewModel.shared
    private lazy var starImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .star))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDay
        label.textAlignment = .center
        label.text = "Категория"
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события можно \nобьеденить по смыслу"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(resource: .blackDay)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Добавить категорию", for: .normal)
        button.tintColor = UIColor(resource: .whiteDay)
        return button
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.backgroundColor = .clear
        return table
    }()
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCategories()
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        
        setUpTableView()
        setUpView()
        setUpConstraints()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.categoryArrayDidChange = { [weak self] in
            guard let self = self else { return }
            let categoriesIsEmpty = self.viewModel.categories.isEmpty
            
            self.tableView.isHidden = categoriesIsEmpty
            self.starImage.isHidden = !categoriesIsEmpty
            self.titleLabel.isHidden = !categoriesIsEmpty
            
            self.tableView.reloadData()
        }
        viewModel.categoryArrayDidChange?()
    }


    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            //StarImage
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            //CategoryLabel
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 31),
            //TitleLabel
            titleLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            //AddButton
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            // TableView
            tableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16)
        ])
    }
    
    private func setUpView() {
        view.addSubview(starImage)
        view.addSubview(categoryLabel)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)
        addButton.addTarget(self, action: #selector(switchToCreateCategoryVC), for: .touchUpInside)
    }
    
    @objc private func switchToCreateCategoryVC() {
        let vc = CreateCategoryViewController()
        present(vc, animated: true)
    }
}

//MARK: - DataSource
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle ,reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.categories[indexPath.row].title
        cell.backgroundColor = UIColor(resource: .backgroundDay)
        cell.selectionStyle = .none
        cell.accessoryType = selectedCategoryIndex == indexPath.row ? .checkmark : .none
        return cell
    }
}

//MARK: - Delegate
extension CategoriesViewController: UITableViewDelegate {
    
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
        tableView.deselectRow(at: indexPath, animated: true)
        let chosenCategory = viewModel.categories[indexPath.row].title
        selectedCategory = chosenCategory
        selectedCategoryIndex = indexPath.row
        selectCategoryHandler?(chosenCategory)
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else {return}
            self.navigationController?.popViewController(animated: true)
        }
    }
}
