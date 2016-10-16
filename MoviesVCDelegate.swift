import UIKit

protocol MoviesVCDelegate: class {
    func moviesVC(_ moviesVC: UIViewController, didSelect movie: Movie)
}
