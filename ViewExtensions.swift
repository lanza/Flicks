import UIKit

extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        self.textColor = .white
    }
    static func detailTitleLabel(title: String) -> UILabel {
        let label = UILabel(text: title)
        return label
    }
    static func detailOverviewLabel(overview: String) -> UILabel {
        let label = UILabel(text: overview)
        label.numberOfLines = 0
        label.setContentHuggingPriority(900, for: .vertical)
        return label
    }
    static func detailRatingLabel(rating: Double) -> UILabel {
        let label = UILabel(text: String(rating))
        return label
    }
    static func detailReleaseDateLabel(releaseDate: String) -> UILabel {
        let label = UILabel(text: releaseDate)
        return label
    }
    static func detailLengthLabel(length: String) -> UILabel {
        let label = UILabel(text: length)
        return label
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: UILayoutConstraintAxis) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
    }
}

extension UIView {
    static func blackView() -> UIView {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3269696303)
        return view
    }
}

extension UILabel {
    static func movieCellTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.movieCellTitleLabel
        return label
    }
    static func movieCellOverviewLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 10
        label.font = Fonts.movieCellOverviewLabel
        return label
    }
}
