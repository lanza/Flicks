import UIKit
import AlamofireImage
import EZLoadingActivity

extension MoviesCVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredMovies = searchText.isEmpty ? movies : movies.filter { movie in
            return movie.title.contains(searchText)
        }
        collectionView?.reloadData()
    }
}
class MoviesCVC: UICollectionViewController, MoviesVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControl.selectedSegmentIndex = 1
    }
    let searchController = UISearchController(searchResultsController: nil)
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = Colors.navigationBarBackground
        definesPresentationContext = true
    }
    let networkErrorBanner = UIView()
    func setupNetworkErrorBanner() {
        networkErrorBanner.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 25)
        view.addSubview(networkErrorBanner)
        networkErrorBanner.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7981128961)
        let label = UILabel(text: "Network Error")
        networkErrorBanner.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: networkErrorBanner.centerYAnchor).isActive = true
        networkErrorBanner.isHidden = true
    }
    
    var type: DownloadManager.GetType!
    var delegate: MoviesVCDelegate!
    func setupCollectionView() {
        collectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    func setupRefreshControl() {
    }
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view = collectionView
        collectionView?.backgroundColor = .white
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 8)
        
        let totalWidth = collectionView!.bounds.width - 32
        let numberOfCellsPerRow = 3
        let dimensions = CGFloat(Int(totalWidth) / numberOfCellsPerRow)
        layout.itemSize = CGSize(width: dimensions, height: dimensions * (278/185) - 5)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkErrorBanner()
        setupSearchController()
        setupCollectionView()
        setupRefreshControl()
        setupSegmentedControl()
        download()
    }
    let segmentedControl = UISegmentedControl(items: ["list","grid"])
    func setupSegmentedControl() {
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    func segmentChanged() {
        delegate.segmentChanged()
    }
    
    func didRefresh() {
        download()
    }
    func download() {
        _ = EZLoadingActivity.show("Loading...", disableUI: false)
        DownloadManager.shared.get(type: type, page: 1) { movies in
            _ = EZLoadingActivity.hide(movies != nil, animated: false)
            guard let movies = movies else {
                self.networkErrorBanner.isHidden = false
                self.collectionView!.isScrollEnabled = false
                return
            }
            self.movies = movies
            self.collectionView!.reloadData()
        }
    }
    var movies = [Movie]() {
        didSet {
            filteredMovies = movies
        }
    }
    var filteredMovies = [Movie]()
    
    //MARK: - UITableViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = filteredMovies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        cell.configure(for: movie)
        return cell
    }
}
class MovieCollectionViewCell: UICollectionViewCell {
    func configure(for movie: Movie) {
        posterImageView.af_setImage(withURL: movie.posterURL, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false, completion: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        var constraints = [NSLayoutConstraint]()
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    
        
        constraints.append(posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor))
        constraints.append(posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
        let sbgv = UIView()
        sbgv.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        selectedBackgroundView = sbgv
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let posterImageView = UIImageView()
}
extension MoviesCVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.row]
        delegate.moviesVC(self, didSelect: movie)
    }
}
