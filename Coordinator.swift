import UIKit

class Coordinator: NSObject {
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func start() {
        
    }
}

extension Coordinator {
    func show(_ vc: UIViewController, sender: Any?) {
        viewController.show(vc, sender: sender)
    }
    func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        viewController.showDetailViewController(vc, sender: sender)
    }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewController.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}



