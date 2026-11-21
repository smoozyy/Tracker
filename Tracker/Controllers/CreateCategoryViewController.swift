
import UIKit

final class CreateCategoryViewController: UIViewController {

    // MARK: - Properties

    let viewModel = CategoriesViewModel.shared

    private var categoryToEdit: String?

    private lazy var newCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(resource: .forText)
        label.textAlignment = .center
        label.text = NSLocalizedString("newCategoryLabel", comment: "Надпись вверху экрана CreateCategoryVC")
        return label
    }()

    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .gray
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitle(NSLocalizedString("categoryCompleteButton", comment: "Кнопка подтверждения"), for: .normal)
        button.tintColor = UIColor(resource: .forCreatebuttonhabit)
        button.isEnabled = false
        return button
    }()

    private lazy var textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 16
        text.placeholder = NSLocalizedString("categoryTextField", comment: "Надпись в поиске")

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        text.leftView = paddingView
        text.leftViewMode = .always
        text.backgroundColor = UIColor(resource: .tableViewBackcolor)

        return text
    }()

    // MARK: - Configure Editing

    func configureEditing(categoryTitle: String) {
        categoryToEdit = categoryTitle
    }

    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(resource: .backgroundDay)

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        setUpView()
        setUpConstraints()

        if let categoryToEdit {
            newCategoryLabel.text = "Редактирование категории"
            textField.text = categoryToEdit
            completeButton.setTitle("Готово", for: .normal)
        }

        bindViewModel()

        if let categoryToEdit {
            viewModel.updateCategoryName(categoryToEdit)
        }
    }

    // MARK: - Private Methods

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // NewCategoryLabel
            newCategoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCategoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 31),

            // CompleteButton
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completeButton.heightAnchor.constraint(equalToConstant: 60),

            // TextField
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
            self.completeButton.backgroundColor = isEnabled ? UIColor(resource: .blackDay) : UIColor(resource: .forCreatebuttonhabit)

            let textColor = isEnabled ? UIColor(resource: .forTextInButton) : UIColor(resource: .ypWhite)
            self.completeButton.setTitleColor(textColor, for: .normal)
        }
    }

    // MARK: - Objc Methods

    @objc private func textFieldDidChange() {
        viewModel.updateCategoryName(textField.text ?? "")
    }

    @objc private func switchToCategoriesController() {
        guard let text = textField.text else { return }

        if let categoryToEdit {
            viewModel.updateCategory(oldTitle: categoryToEdit, newTitle: text)
        } else {
            viewModel.saveCategory(text)
        }

        dismiss(animated: true)
    }
}
