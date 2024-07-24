//
//  DiscoverCollectionViewCell.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import RxSwift
import SnapKit
import Then
import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .posterPlaceholder)
    }
    
    private let movieTitle = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 3
        $0.minimumScaleFactor = 0.5
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [posterImageView, movieTitle]).then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
//        posterImageView.snp.makeConstraints { make in
//            make.directionalHorizontalEdges.greaterThanOrEqualToSuperview()
//            make.bottom.lessThanOrEqualToSuperview()
//        }
        
//        movieTitle.setContentHuggingPriority(.required, for: .vertical)
//        movieTitle.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setData(movie: MovieFront) {
        movieTitle.text = movie.title
        
//        let posterPath = APIService.configureUrlString(posterPath: movie.posterPath)
//        let placeholder = UIImage(resource: .posterPlaceholder)
//        posterImageView.setImage(path: posterPath, placeholder: placeholder)
    }
}

// MARK: - ReusableCell

extension DiscoverCollectionViewCell: ReusableCell { }
