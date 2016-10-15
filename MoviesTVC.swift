import UIKit
import AlamofireImage
import EZLoadingActivity

extension MoviesTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredMovies = searchText.isEmpty ? movies : movies.filter { movie in
            return movie.title.contains(searchText)
        }
        tableView.reloadData()
    }
}
class MoviesTVC: UITableViewController, MoviesVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControl.selectedSegmentIndex = 0
    }
    let searchController = UISearchController(searchResultsController: nil)
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = Colors.navigationBarBackground
        tableView.tableHeaderView = searchController.searchBar
        
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
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.register(MovieCell.self, forCellReuseIdentifier: "cell")
    }
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkErrorBanner()
        setupSearchController()
        setupTableView()
        setupRefreshControl()
        setupSegmentedControl()
        download()
    }
    let segmentedControl = UISegmentedControl(items: ["list","grid"])
    func setupSegmentedControl() {
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
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
            self.refreshControl?.endRefreshing()
            guard let movies = movies else {
                self.networkErrorBanner.isHidden = false
                self.tableView.isScrollEnabled = false
                return
            }
            self.movies = movies
            self.tableView.reloadData()
        }
    }
    var movies = [Movie]() {
        didSet {
            filteredMovies = movies
        }
    }
    var filteredMovies = [Movie]()
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = filteredMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        cell.configure(for: movie)
        return cell
    }
}
    //MARK: - UITableViewDelegate
extension MoviesTVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.row]
        delegate.moviesVC(self, didSelect: movie)
    }
}

protocol MoviesVCDelegate: class {
    func moviesVC(_ moviesVC: UIViewController, didSelect movie: Movie)
    func segmentChanged()
}
