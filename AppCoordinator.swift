import UIKit

class AppCoordinator: Coordinator {
    
    var tabBarController: UITabBarController { return viewController as! UITabBarController }
    let nowPlayingMasterCoordinator = MasterCoordinator(type: .nowPlaying)
    let topRatedMasterCoordinator = MasterCoordinator(type: .topRated)
    
    init() {
        super.init(viewController: UITabBarController())
        
        let npnc = UINavigationController(rootViewController: nowPlayingMasterCoordinator.viewController)
        let trnc = UINavigationController(rootViewController: topRatedMasterCoordinator.viewController)
        
        tabBarController.viewControllers = [npnc,trnc]
        tabBarController.viewControllers!.forEach { nc in
            nc.tabBarItem.title = (nc as! UINavigationController).viewControllers.first!.tabBarItem.title
        }
    }
    
    override func start() {
        Theme.run()
    }
}


