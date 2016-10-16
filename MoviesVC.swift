import UIKit
import AlamofireImage
import EZLoadingActivity

class MoviesVC: UIViewController {
    var delegate: MoviesVCDelegate!
    var type: DownloadManager.GetType!
    
    let tableViewSearchController = UISearchController(searchResultsController: nil)
    let collectionViewSearchController = UISearchController(searchResultsController: nil)
    let networkErrorBanner = UIView()
    let segmentedControl = UISegmentedControl(items: ["list","grid"])
    let refreshControl = UIRefreshControl()
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - Actions
    func segmentChanged() {
        tableView.isHidden = !tableView.isHidden
        collectionView.isHidden = !collectionView.isHidden
    }
    func didRefresh() {
        download()
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkErrorBanner()
        setupSearchController()
        setupTableView()
        setupCollectionView()
        setupRefreshControl()
        setupSegmentedControl()
        download()
        automaticallyAdjustsScrollViewInsets = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let insets = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        collectionView.contentInset = insets
        tableView.contentInset = insets
    }
   
    //MARK: - Model
    func download() {
        _ = EZLoadingActivity.show("Loading...", disableUI: false)
        DownloadManager.shared.get(type: type, page: 1) { movies in
            _ = EZLoadingActivity.hide(movies != nil, animated: false)
            self.refreshControl.endRefreshing()
            guard let movies = movies else {
                self.networkErrorBanner.isHidden = false
                return
            }
            self.movies = movies
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    var movies = [Movie]() { didSet { filteredMovies = movies } }
    var filteredMovies = [Movie]()
    
    //MARK: - setup
    func setupSearchController() {
        let scs = [tableViewSearchController,collectionViewSearchController]
        scs.forEach { sc in
            sc.searchResultsUpdater = self
            sc.dimsBackgroundDuringPresentation = false
            sc.searchBar.sizeToFit()
            sc.searchBar.tintColor = Colors.navigationBarBackground
        }
        definesPresentationContext = true
    }
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
    func setupSegmentedControl() {
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
    }
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = tableViewSearchController.searchBar
    }
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.frame
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionView.backgroundColor = .white
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 8)
        layout.headerReferenceSize = collectionViewSearchController.searchBar.frame.size
        let totalWidth = collectionView.bounds.width - 32
        let numberOfCellsPerRow = 3
        let dimensions = CGFloat(Int(totalWidth) / numberOfCellsPerRow)
        layout.itemSize = CGSize(width: dimensions, height: dimensions * (278/185) - 5)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isHidden = true
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    @objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:) func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        view.addSubview(collectionViewSearchController.searchBar)
        return view
    }
}
    //MARK: - UITableViewDataSource
extension MoviesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = filteredMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.configure(for: movie)
        return cell
    }
}
    //MARK: - UITableViewDelegate
extension MoviesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.row]
        delegate.moviesVC(self, didSelect: movie)
    }
}
    //MARK: - UICollectionViewDataSource
extension MoviesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = filteredMovies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        cell.configure(for: movie)
        return cell
    }
}
    //MARK: - UICollectionViewDelegate
extension MoviesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.row]
        delegate.moviesVC(self, didSelect: movie)
    }
    
}
    //MARK: - UISearchResultsUpdating
extension MoviesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredMovies = searchText.isEmpty ? movies : movies.filter { movie in
            return movie.title.contains(searchText)
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
}
