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
enum Fonts {
    case movieCellTitleLabel
    case movieCellOverviewLabel
    var font: UIFont {
        switch self {
        case .movieCellTitleLabel:
            return UIFont.systemFont(ofSize: 14)
        case .movieCellOverviewLabel:
            return UIFont.systemFont(ofSize: 9)
        }
    }
}
