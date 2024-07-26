//
//  DetailViewController.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import RxSwift
import SnapKit
import Then
import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.bounces = false
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    private let contentView = UIView()
    
    private let backDropImage = UIImageView().then {
        $0.backgroundColor = .darkGray
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var backButton = UIButton().then {
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        $0.setPreferredSymbolConfiguration(.init(pointSize: 24, weight: .regular, scale: .default), forImageIn: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.textAlignment = .left
        $0.minimumScaleFactor = 0.5
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .systemFont(ofSize: 25, weight: .medium)
    }
    
    private let taglineLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    private let runtimeIconLabel = IconLabel().then {
        $0.icon.image = UIImage(systemName: "clock")
    }
    
    private let ratingIconLabel = IconLabel().then {
        $0.icon.tintColor = .systemOrange
        $0.icon.image = UIImage(systemName: "star.fill")
    }
        
    private lazy var iconLabels = UIStackView(arrangedSubviews: [runtimeIconLabel, ratingIconLabel]).then {
        $0.spacing = 5
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    private lazy var mainInformationSection = UIStackView(arrangedSubviews: [titleLabel, taglineLabel, UIView(), iconLabels]).then {
        $0.spacing = 5
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets.detailViewComponentInset
    }
    
    private let overviewSection = DescriptionView().then {
        $0.titleLabel.text = "Overview"
    }
    
    private let dateGenreSection = DoubleColumnDescriptionView().then {
        $0.dateDescription.titleLabel.text = "Release Date"
        $0.genreDescription.titleLabel.text = "Genre"
    }
    
    private lazy var detailStackView = UIStackView(arrangedSubviews: [mainInformationSection, overviewSection, dateGenreSection]).then {
        $0.axis = .vertical
    }
    
    // MARK: - Lifecycle
    
    init(id: Int) {
        viewModel = DetailViewModel(contentId: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureUI()
        bindData()
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        view.backgroundColor = .background
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backDropImage, backButton, detailStackView].forEach { contentView.addSubview($0) }
        
        // FIXME: - Scrollable content size is ambiguous for UIScrollView
        scrollView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        backDropImage.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(backDropImage.snp.width).multipliedBy(0.7)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(50)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.equalTo(backDropImage.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainInformationSection.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(view.snp.width).multipliedBy(0.325)
        }
    }
    
    private func bindData() {
        viewModel.movieDetailData
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                guard let movieDetail = data else { return }
                
                self?.applyMovieDetailData(data: movieDetail)
            }
            .disposed(by: disposeBag)
    }
    
    private func applyMovieDetailData(data: MovieDetail) {
        if let backdropPath = data.backdropPath {
            backDropImage.setImage(path: APIService.configureUrlString(posterPath: backdropPath))
        } else {
            backDropImage.isHidden = true
            backDropImage.snp.remakeConstraints { make in
                make.top.directionalHorizontalEdges.equalToSuperview()
                make.width.equalToSuperview()
                make.bottom.equalTo(backButton.snp.bottom)
            }
        }
        
        titleLabel.text = data.title
        taglineLabel.text = data.tagline
        
        if let runtime = data.runtime {
            runtimeIconLabel.label.text = "\(runtime) min"
        } else {
            runtimeIconLabel.isHidden = true
        }
        
        if let voteAverage = data.voteAverage {
            ratingIconLabel.label.text = String(voteAverage)
        } else {
            ratingIconLabel.isHidden = true
        }
        
        overviewSection.contentLabel.text = data.overview
        dateGenreSection.dateDescription.contentLabel.text = data.releaseDate?.replacingOccurrences(of: "-", with: ".")
        
        let genres = data.genres?.compactMap { $0.name }.joined(separator: ", ")
        dateGenreSection.genreDescription.contentLabel.text = genres
    }
    
    // MARK: - Selectors
    
    @objc private func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Preview

#Preview {
    // 1022789: Inside Out 2 movie id
    DetailViewController(id: 1022789)
}
