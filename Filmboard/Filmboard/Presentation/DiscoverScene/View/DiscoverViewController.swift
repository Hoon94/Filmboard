//
//  DiscoverViewController.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import RxSwift
import SnapKit
import Then
import UIKit

class DiscoverViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = DiscoverViewModel()
    private let disposeBag = DisposeBag()
    private let headerView = DiscoverCollectionHeaderView()
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.minimumInteritemSpacing = 20
        $0.minimumLineSpacing = 20
    }
    
    private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout).then {
        $0.register(DiscoverCollectionViewCell.self)
        $0.backgroundColor = .background
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureUI()
        bindData()
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        title = "Discover"
        view.backgroundColor = .background
        dismissKeyboard()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let customRefreshControl = UIRefreshControl().then {
            $0.tintColor = .white
        }
        
        collectionView.refreshControl = customRefreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureUI() {
        [headerView, collectionView].forEach { view.addSubview($0) }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(180)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindData() {
        
    }
    
    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Selectors
    
    @objc private func refreshData() {
//        viewModel.requestData(page: 1)
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        
//        cell.setData(movie: )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.size.width - 60) / 2
        
        return CGSize(width: itemWidth, height: itemWidth * 1.75)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let id = viewModel.movieListData.value[indexPath.item].id
//        navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//    }
}