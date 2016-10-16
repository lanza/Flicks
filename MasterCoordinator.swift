import UIKit


class MasterCoordinator: Coordinator {
    var moviesVC: MoviesVC { return viewController as! MoviesVC }
   
    var detailCoordinator: DetailCoordinator?
    var type: DownloadManager.GetType
    
    init(type: DownloadManager.GetType) {
        self.type = type
        super.init(viewController: MoviesVC())
        
        moviesVC.type = type
        moviesVC.delegate = self
        moviesVC.tabBarItem?.title = type.title
        moviesVC.navigationItem.title = type.title
    }
}

extension MasterCoordinator: MoviesVCDelegate {

    func moviesVC(_ moviesVC: UIViewController, didSelect movie: Movie) {
        detailCoordinator = DetailCoordinator()
        detailCoordinator!.movieDetailVC.movie = movie
        viewController.show(detailCoordinator!.movieDetailVC, sender: nil)
    }
}
