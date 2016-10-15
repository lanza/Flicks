import SwiftyJSON

struct Movie {
    static func parse(json: Any) -> [Movie] {
        return JSON(json)["results"].arrayValue.map { Movie(json: $0) }
    }
    let title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    var posterURL: URL {
        let url = URL(string: "https://image.tmdb.org/t/p/" + "w" + String(Lets.posterImageSize) + poster_path)!
        return url
    }
    var bigPosterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/" + "w" + String(Lets.bigPosterImageSize) + poster_path)!
    }
    
    let release_date: String
    let vote_average: Double
    let vote_count: Int
    init(json: JSON) {
        print(json)
        title = json["title"].stringValue
        overview = json["overview"].stringValue
        popularity = json["popularity"].doubleValue
        poster_path = json["poster_path"].stringValue
        release_date = json["release_date"].stringValue
        vote_average = json["vote_average"].doubleValue
        vote_count = json["vote_count"].intValue
        
    }
}
