//
//  DoubleColumnDescriptionView.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import SnapKit
import Then
import UIKit

class DoubleColumnDescriptionView: UIView {
    
    // MARK: - Properties
    
    let dateDescription = DescriptionView()
    let genreDescription = DescriptionView()
    
    private lazy var wrapperStackView = UIStackView(arrangedSubviews: [dateDescription, genreDescription]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 0
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
        addSubview(wrapperStackView)
        wrapperStackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}
