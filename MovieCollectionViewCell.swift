import UIKit
import EZLoadingActivity

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
