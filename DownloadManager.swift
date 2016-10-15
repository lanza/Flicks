import Alamofire

class DownloadManager {
    enum GetType: String {
        case nowPlaying = "now_playing"
        case topRated = "top_rated"
        var string: String { return self.rawValue }
        var title: String {
            switch self {
            case .nowPlaying: return "Now Playing"
            case .topRated: return "Top Rated"
            }
        }
    }
    static var shared = DownloadManager()
    var api_key = "1f54f03acf91d62119b062b0a43598d7"
    func get(type: GetType, page: Int, completion: @escaping (_ movies: [Movie]?) -> ()) {
        let urlString = "https://api.themoviedb.org/3/movie/\(type.string)?api_key=\(api_key)&language=en-US&page=\(page)"
        Alamofire.request(urlString).responseJSON { response in
            guard let data = response.result.value else {
                completion(nil)
                return
            }
            let movies = Movie.parse(json: data)
            completion(movies)
        }
    }
}

