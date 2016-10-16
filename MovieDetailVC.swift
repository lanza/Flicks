import UIKit

class MovieDetailVC: UIViewController {
    var movie: Movie! {
        didSet {
            setupMovieLabels()
        }
    }
    var posterImageView: UIImageView { return view as! UIImageView }
    override func loadView() {
        view = UIImageView()
        view.isUserInteractionEnabled = true
        guard let movie = movie else { return }
        posterImageView.af_setImage(withURL: movie.posterURL, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false) { response in
            DispatchQueue.main.async {
                self.posterImageView.af_setImage(withURL: movie.bigPosterURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)
            }
        }
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let blackView = UIView.blackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        let bounds = UIScreen.main.bounds
        scrollView.frame = CGRect(x: (bounds.width * 0.25) / 2, y: bounds.height / 2, width: bounds.width * 0.75, height: bounds.height * 0.5 - 49)
        contentView.frame = CGRect(x: 0, y: 0, width: bounds.width * 0.75, height: bounds.height * 0.5 - 9)
        scrollView.contentSize = contentView.frame.size
        scrollView.addSubview(contentView)
        contentView.addSubview(blackView)
        
        blackView.frame = CGRect(x: 0, y: 40, width: contentView.frame.width, height: contentView.frame.height - 40)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func setupMovieLabels() {
        let titleLabel = UILabel.detailTitleLabel(title: movie.title)
        let overviewLabel = UILabel.detailOverviewLabel(overview: movie.overview)
        let ratingLabel = UILabel.detailRatingLabel(rating: movie.vote_average)
        let releaseDateLabel = UILabel.detailReleaseDateLabel(releaseDate: movie.release_date)
        let stackView = UIStackView(arrangedSubviews: [titleLabel,releaseDateLabel,ratingLabel, overviewLabel], axis: .vertical)
        blackView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            stackView.leftAnchor.constraint(equalTo: blackView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: blackView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: blackView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: blackView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}

