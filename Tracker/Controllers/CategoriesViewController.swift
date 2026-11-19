
import UIKit

final class CategoriesViewController: UIViewController {

    // MARK: - Properties

    var selectCategoryHandler: ((String) -> Void)?

    let viewModel = CategoriesViewModel.shared

    private var blurView: UIVisualEffectView?

    // MARK: - UI - elements

    private lazy var starImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .star))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(resource: .forText)
        label.textAlignment = .center
        label.text = NSLocalizedString("categoryLabel", comment: "Категория")
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("categoryTitleLabel", comment: "Надпись при заглушке")
        label.textColor = UIColor(resource: .forText)
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
        button.setTitle(NSLocalizedString("categoryAddButton", comment: "Добавление категории"), for: .normal)
        button.setTitleColor(UIColor(resource: .forTextInButton), for: .normal)
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

    // MARK: - ViewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCategories()
    }

    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteDay

        tableView.register(TrackerCategoryCell.self, forCellReuseIdentifier: TrackerCategoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self

        setUpView()
        setUpConstraints()
        bindViewModel()
    }

    // MARK: - Bind ViewModel

    private func bindViewModel() {
        viewModel.categoryArrayDidChange = { [weak self] in
            guard let self = self else { return }

            let categoriesIsEmpty = self.viewModel.numberOfCategories() == 0

            self.tableView.isHidden = categoriesIsEmpty
            self.starImage.isHidden = !categoriesIsEmpty
            self.titleLabel.isHidden = !categoriesIsEmpty

            self.tableView.reloadData()
        }

        viewModel.onCategorySelected = { [weak self] categoryTitle in
            guard let self = self else { return }

            self.selectCategoryHandler?(categoryTitle)
            self.navigationController?.popViewController(animated: true)
        }

        viewModel.categoryArrayDidChange?()
    }

    // MARK: - Constraints

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            // StarImage
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),

            // CategoryLabel
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 31),

            // TitleLabel
            titleLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // AddButton
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

    // MARK: - SetUpView

    private func setUpView() {
        view.addSubview(starImage)
        view.addSubview(categoryLabel)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)

        addButton.addTarget(self, action: #selector(switchToCreateCategoryVC), for: .touchUpInside)
    }

    // MARK: - Create Category

    @objc private func switchToCreateCategoryVC() {
        let vc = CreateCategoryViewController()
        present(vc, animated: true)
    }

    // MARK: - Private methods

    private func openCategoryEditor(categoryTitle: String) {
        let vc = CreateCategoryViewController()
        vc.configureEditing(categoryTitle: categoryTitle)
        present(vc, animated: true)
    }

    private func confirmCategoryDeletion(categoryTitle: String, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: NSLocalizedString("dontNeed", comment: "Эта категория точно не нужна?"),
            message: nil,
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: "Удалить"), style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(title: categoryTitle)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "отменить"), style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    // MARK: - Context Menu Blur

    private func showContextMenuBlur(using animator: UIContextMenuInteractionAnimating) {
        guard blurView == nil else { return }

        let blur = UIVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.effect = nil
        blur.isUserInteractionEnabled = false

        view.insertSubview(blur, belowSubview: tableView)

        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        blurView = blur

        animator.addAnimations {
            blur.effect = UIBlurEffect(style: .systemMaterial)
        }
    }

    private func hideContextMenuBlur(using animator: UIContextMenuInteractionAnimating) {
        guard let blur = blurView else { return }

        animator.addAnimations {
            blur.effect = nil
        }

        animator.addCompletion { [weak self, weak blur] in
            blur?.removeFromSuperview()
            self?.blurView = nil
        }
    }
}

// MARK: - DataSource

extension CategoriesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCategories()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCategoryCell.identifier) as? TrackerCategoryCell else {
            return UITableViewCell()
        }

        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else {
            return cell
        }

        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - Delegate

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
        viewModel.selectCategory(at: indexPath.row)
    }

    // MARK: - Context Menu

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let category = viewModel.cellViewModel(at: indexPath) else { return nil }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            UIMenu(children: [
                UIAction(title:NSLocalizedString("editing", comment: "Редактировать")) { [weak self] _ in
                    self?.openCategoryEditor(categoryTitle: category.title)
                },
                UIAction(title: NSLocalizedString("delete", comment: "Удалить"), attributes: .destructive) { [weak self] _ in
                    self?.confirmCategoryDeletion(categoryTitle: category.title, at: indexPath)
                }
            ])
        }
    }

    func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        guard let animator else { return }
        showContextMenuBlur(using: animator)
    }
    
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        guard let animator else { return }
        hideContextMenuBlur(using: animator)
    }
}
