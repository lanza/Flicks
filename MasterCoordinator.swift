import UIKit


protocol MoviesVC: class {
    var type: DownloadManager.GetType! { get set }
    var delegate: MoviesVCDelegate! { get set }
    var tabBarItem: UITabBarItem! { get }
    var navigationItem: UINavigationItem { get }
}

class MasterCoordinator: Coordinator {
    var moviesTVC: MoviesTVC { return viewController as? MoviesTVC ?? inactiveViewController as! MoviesTVC }
    var moviesCVC: MoviesCVC { return viewController as? MoviesCVC ?? inactiveViewController as! MoviesCVC}
   
    var activeViewController: UIViewController
    var inactiveViewController: UIViewController
    var detailCoordinator: DetailCoordinator?
    var type: DownloadManager.GetType
    
    init(type: DownloadManager.GetType) {
        self.type = type
        self.activeViewController = MoviesTVC()
        self.inactiveViewController = MoviesCVC()
        super.init(viewController: activeViewController)
        let vcs: [MoviesVC] = [moviesTVC, moviesCVC]
        vcs.forEach { vc in
            vc.type = type
            vc.delegate = self
            vc.tabBarItem?.title = type.title
            vc.navigationItem.title = type.title
        }
    }
}

extension MasterCoordinator: MoviesVCDelegate {
    func segmentChanged() {
        let nc = activeViewController.navigationController!
        nc.setViewControllers([inactiveViewController], animated: false)
        swap(&activeViewController, &inactiveViewController)
    }

    func moviesVC(_ moviesVC: UIViewController, didSelect movie: Movie) {
        detailCoordinator = DetailCoordinator()
        detailCoordinator!.movieDetailVC.movie = movie
        activeViewController.show(detailCoordinator!.movieDetailVC, sender: nil)
    }
}
