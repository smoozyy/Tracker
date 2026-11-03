//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Антон on 28.10.2026.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    //MARK: - Properties
    
    let viewModel = CategoriesViewModel.shared
    private lazy var newCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackDay
        label.textAlignment = .center
        label.text = "Новая категория"
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .gray
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Готово", for: .normal)
        button.tintColor = UIColor(resource: .whiteDay)
        button.isEnabled = false
        return button
    }()
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 16
        text.placeholder = "Введите название категории"
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.leftView = paddingView
        text.leftViewMode = .always
        text.backgroundColor = .backgroundDay
        return text
    }()

    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        setUpView()
        setUpConstraints()
        
        bindViewModel()
    }
    
    //MARK: - Private methods
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            //NewCategoryLabel
            newCategoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCategoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 31),
            //CompleteButton
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            //TextField
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: newCategoryLabel.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setUpView() {
        view.addSubview(newCategoryLabel)
        view.addSubview(completeButton)
        view.addSubview(textField)
        completeButton.addTarget(self, action: #selector(switchToCategoriesController), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onButtonStateChanged = { [weak self] isEnabled in
            guard let self = self else { return }

            self.completeButton.isEnabled = isEnabled
            self.completeButton.backgroundColor = isEnabled
                ? UIColor(resource: .blackDay)
                : .gray
        }
    }
    //MARK: - Objc methods
    @objc private func textFieldDidChange() {
            viewModel.updateCategoryName(textField.text ?? "")
        }
    
    @objc private func switchToCategoriesController() {
        guard let text = textField.text else {return}
        viewModel.saveCategory(text)

        dismiss(animated: true)
    }

}


