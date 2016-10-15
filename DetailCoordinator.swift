import UIKit

class DetailCoordinator: Coordinator {
    var movieDetailVC: MovieDetailVC { return viewController as! MovieDetailVC }
    init() {
        super.init(viewController: MovieDetailVC())
    }
}
