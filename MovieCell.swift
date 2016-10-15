import UIKit

class MovieCell: UITableViewCell {
    func configure(for movie: Movie) {
        posterImageView.af_setImage(withURL: movie.posterURL, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false, completion: nil)
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        var constraints = [NSLayoutConstraint]()
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        constraints.append(posterImageView.heightAnchor.constraint(equalToConstant: Lets.posterImageViewHeight))
        constraints.append(posterImageView.widthAnchor.constraint(equalToConstant: Lets.posterImageViewWidth))
        constraints.append(posterImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor))
        constraints.append(posterImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor))
        constraints.append(posterImageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor))
        
        constraints.append(posterImageView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -8))
        constraints.append(titleLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor))
        
        constraints.append(posterImageView.rightAnchor.constraint(equalTo: overviewLabel.leftAnchor, constant: -8))
        constraints.append(overviewLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor))
        constraints.append(overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8))
        constraints.append(overviewLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor))
        
        titleLabel.setContentHuggingPriority(1000, for: .vertical)
        NSLayoutConstraint.activate(constraints)
        
        let sbgv = UIView()
        sbgv.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        selectedBackgroundView = sbgv
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let posterImageView = UIImageView()
    let titleLabel = UILabel.movieCellTitleLabel()
    let overviewLabel = UILabel.movieCellOverviewLabel()
}

struct Lets {
    static let posterImageSize = 185
    static let bigPosterImageSize = 500
    static let movieCellBuffer: CGFloat = 8
    static let posterImageViewHeight: CGFloat = 132
    static let posterImageViewWidth: CGFloat = 92
}

extension UILabel {
    static func movieCellTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.movieCellTitleLabel.font
        return label
    }
    static func movieCellOverviewLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 10
        label.font = Fonts.movieCellOverviewLabel.font
        return label
    }
}


