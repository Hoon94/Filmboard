//
//  IconLabel.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import SnapKit
import Then
import UIKit

class IconLabel: UIView {
    
    // MARK: - Properties
    
    let icon = UIImageView().then {
        $0.tintColor = .lightGray
    }
    
    let label = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [icon, label]).then {
        $0.spacing = 4
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
    }
}
