import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        let trackersVC = TrackerViewController()
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
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

