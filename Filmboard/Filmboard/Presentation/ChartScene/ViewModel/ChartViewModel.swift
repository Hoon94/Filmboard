//
//  ChartViewModel.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/26/24.
//

import Foundation
import RxRelay
import RxSwift

struct ChartViewModel {
    
    // MARK: - Properties
    
    let listTitle = BehaviorSubject<String>(value: MovieListCategory.popular.title)
    let movieListData = BehaviorRelay<[MovieFront]>(value: [])
    var currentCategory = MovieListCategory.popular
    
    private let disposeBag = DisposeBag()
    private var currentPage = 1
    private let maximumPage = 6
    
    // MARK: - Helpers
    
    mutating private func requestData() {
        requestData(category: currentCategory)
    }
    
    mutating func requestData(category: MovieListCategory) {
        if currentCategory != category { currentPage = 1 }
        
        currentCategory = category
        fetchData(category: category)
    }
    
    mutating func refreshData() {
        currentPage = 1
        fetchData(category: currentCategory)
    }
    
    mutating func requestMoreData() {
        currentPage += 1
        
        guard currentPage < maximumPage else { return }
        requestData()
    }
    
    private func fetchData(category: MovieListCategory) {
        let url = APIService.configureUrlString(category: category, language: .english, page: currentPage)
        
        APIService.fetchWithRx(url: url, retries: 2)
            .map { data -> [MovieListResult] in
                guard let response = try? JSONDecoder().decode(MovieList.self, from: data) else { return [] }
                listTitle.onNext(category.title)
                
                return response.results
            }
            .map { $0.map { return MovieFront.convertFromMovieInfo(movie: $0) } }
            .take(1)
            .map { list in
                if currentPage == 1 {
                    return list
                } else {
                    return movieListData.value + list
                }
            }
            .bind(to: movieListData)
            .disposed(by: disposeBag)
    }
}
