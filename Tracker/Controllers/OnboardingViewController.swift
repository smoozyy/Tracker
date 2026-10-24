//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Антон on 23.10.2026.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    //MARK: - Properties
    private lazy var pages: [UIViewController] = [
        makePage(with: UIImage(resource: .uiPageViewControllerBlue),
                 text: "Отслеживайте только то, что хотите"),
        makePage(with: UIImage(resource: .uiPageViewControllerRed),
                 text: "Даже если это не литры воды и йога")
    ]
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackDay
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    //MARK: - Init
    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder){
        nil
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 335),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        button.addTarget(self, action: #selector(switchToTabControllerTapped), for: .touchUpInside)
    }
    
    //MARK: - Private Methods
    private func makePage(with image: UIImage, text: String) -> UIViewController {
        let controller = UIViewController()
        let imageView = UIImageView()
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .blackDay
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        controller.view.addSubview(imageView)
        controller.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: controller.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
            label.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: 388),
            label.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            label.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 16)
        ])
        
        return controller
    }
    
    @objc private func switchToTabControllerTapped() {
        let trackerStore = TrackerStore()
        let trackersVC = TrackerViewController(trackerStore: trackerStore)
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .recordCircle),
            tag: 0
        )
        
        let statsVC = StatsViewController()
        statsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .hare),
            tag: 1
        )
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackersVC, statsVC]
        guard let window = view.window else { return }
        window.rootViewController = tabBarController
    }
}

//MARK: - DataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}
