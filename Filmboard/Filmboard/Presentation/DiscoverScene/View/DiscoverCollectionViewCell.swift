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
        $0.image = UIImage(resource: .posterPlaceholder)
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let movieTitle = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 3
        $0.textAlignment = .center
        $0.minimumScaleFactor = 0.5
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [movieTitle]).then {
        $0.alignment = .center
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureCell() {
        backgroundColor = .lightBackground
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureUI() {
        [posterImageView, stackView].forEach { contentView.addSubview($0) }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    func setData(movie: MovieFront) {
        movieTitle.text = movie.title
        
        let posterPath = APIService.configureUrlString(posterPath: movie.posterPath)
        let placeholder = UIImage(resource: .posterPlaceholder)
        posterImageView.setImage(path: posterPath, placeholder: placeholder)
    }
}

// MARK: - ReusableCell

extension DiscoverCollectionViewCell: ReusableCell { }
