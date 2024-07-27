//
//  ChartTableViewCell.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/26/24.
//

import Cosmos
import SnapKit
import Then
import UIKit

class ChartTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let padding = 10.0
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 30
    }
    
    private let rankLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.minimumScaleFactor = 0.7
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .systemFont(ofSize: 25, weight: .regular)
    }
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(resource: .posterPlaceholder)
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.textColor = .white
        $0.textAlignment = .left
        $0.minimumScaleFactor = 0.5
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private let genreLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private let releaseDateLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private let starRatingView = CosmosView().then {
        $0.settings.starSize = 17
        $0.settings.starMargin = 1
        $0.settings.totalStars = 5
        $0.settings.fillMode = .precise
        $0.settings.filledColor = .systemOrange
        $0.settings.emptyBorderColor = .systemOrange
        $0.settings.updateOnTouch = false
    }
    
    private let ratingCountLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private lazy var starStackView = UIStackView(arrangedSubviews: [starRatingView, ratingCountLabel, UIView()]).then {
        $0.spacing = 5
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private lazy var informationStackView = UIStackView(arrangedSubviews: [titleLabel, genreLabel, releaseDateLabel, starStackView]).then {
        $0.spacing = 5
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureCell() {
        backgroundColor = .background
        selectionStyle = .none
    }
    
    private func configureUI() {
        contentView.addSubview(containerView)
        [rankLabel, posterImageView, informationStackView].forEach { containerView.addSubview($0) }
        
        containerView.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(4)
            make.directionalHorizontalEdges.equalToSuperview().inset(padding)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().dividedBy(12)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(padding)
            make.leading.equalTo(rankLabel.snp.trailing).offset(padding)
            make.width.equalToSuperview().dividedBy(4)
        }
        
        informationStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.leading.equalTo(posterImageView.snp.trailing).offset(padding * 2)
            make.bottom.equalToSuperview().inset(padding * 2)
            make.trailing.equalToSuperview().inset(padding * 2)
        }
    }
    
    func setData(rank: Int, movie: MovieFront) {
        rankLabel.text = "\(rank + 1)"
        titleLabel.text = movie.title
        genreLabel.text = movie.genre
        releaseDateLabel.text = movie.releaseDate
        starRatingView.rating = movie.ratingScore / 2
        ratingCountLabel.text = "(\(movie.ratingCount))"
        
        let posterPath = APIService.configureUrlString(posterPath: movie.posterPath)
        let placeholder = UIImage(resource: .posterPlaceholder)
        posterImageView.setImage(path: posterPath, placeholder: placeholder)
        
        configureCellStyle(by: rank)
    }
    
    private func configureCellStyle(by rank: Int) {
        switch rank {
        case 0:
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.rankBorder.cgColor
        case 1:
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.rankBorder.cgColor
        case 2:
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.rankBorder.cgColor
        default:
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
}

// MARK: - ReusableCell

extension ChartTableViewCell: ReusableCell { }
