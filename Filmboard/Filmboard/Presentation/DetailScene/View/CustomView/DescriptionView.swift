//
//  DescriptionView.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import SnapKit
import Then
import UIKit

class DescriptionView: UIView {
    
    // MARK: - Properties
    
    private let divider = UIView().then {
        $0.backgroundColor = .gray
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.textAlignment = .left
        $0.minimumScaleFactor = 0.5
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel]).then {
        $0.spacing = 4
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets.detailViewComponentInset
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
        [divider, stackView].forEach { addSubview($0) }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(0.4)
            make.centerY.equalTo(snp.top)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}
