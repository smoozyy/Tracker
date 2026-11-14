import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let coreDataStack = CoreDataStack.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        let trackerStore = TrackerStore()
        let trackersVC = TrackerViewController(trackerStore: trackerStore)
        trackersVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackerConstantsCategory", comment: "Надпись категории в tabBar"),
            image: UIImage(resource: .recordCircle),
            tag: 0
        )
        
        let statsVC = StatisticViewController()
        statsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", comment: "Надпись статистики в tabBar"),
            image: UIImage(resource: .hare),
            tag: 1
        )
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackersVC, statsVC]
        let hasSwitch = StorageModel.shared.hasSwitchToTabBarController
        window?.rootViewController = hasSwitch ? tabBarController : OnboardingViewController()
        window?.makeKeyAndVisible()
    }
}

