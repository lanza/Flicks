import UIKit

struct Theme {
    static func run() {
        
        let nb = UINavigationBar.appearance()
        nb.backgroundColor = Colors.navigationBarBackground
        nb.barStyle = .black
        
        let tb = UITabBar.appearance()
        tb.backgroundColor = Colors.tabBarBackground
        tb.barStyle = .black
    }
}
struct Colors {
    static let blue = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) 
    static let navigationBarBackground = Colors.blue
    static let tabBarBackground = Colors.blue
    static let tint = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
}
struct Fonts {
    static let movieCellTitleLabel = UIFont.systemFont(ofSize: 14)
    static let movieCellOverviewLabel = UIFont.systemFont(ofSize: 9)
}
