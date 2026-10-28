//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Антон on 28.10.2026.
//

import UIKit

final class CategoriesViewController: UIViewController {
    //MARK: - Properties
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
        label.text = "Привычки и события можно обьеденить по смыслу"
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
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        return table
    }()


    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        
        
        setUpView()
        setUpConstraints()
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
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            //addButton
            //completeButton
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            //TableView
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
    
    private func setUpView() {
        view.addSubview(starImage)
        view.addSubview(categoryLabel)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)
    }
}
