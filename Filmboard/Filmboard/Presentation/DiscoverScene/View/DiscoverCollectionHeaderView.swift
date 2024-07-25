//
//  DiscoverCollectionHeaderView.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class DiscoverCollectionHeaderView: UIView {
    
    // MARK: - Properties
    
    var searchFieldCallBack: ((String) -> Void)?
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 40, weight: .bold)
        $0.text = "Discover Movies"
    }
    
    private let searchField = PaddingTextField().then {
        $0.textColor = .white
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .lightBackground
        $0.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [.foregroundColor: UIColor.placeholder])
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bindSearchField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        
        addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func bindSearchField() {
        searchField.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .distinctUntilChanged()
            .subscribe { [weak self] keyword in
                self?.searchFieldCallBack?(keyword)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - PaddingTextField

class PaddingTextField: UITextField {
    
    // MARK: - Properties
    
    let textPadding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    // MARK: - Helpers
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        
        return rect.inset(by: textPadding)
    }
}
