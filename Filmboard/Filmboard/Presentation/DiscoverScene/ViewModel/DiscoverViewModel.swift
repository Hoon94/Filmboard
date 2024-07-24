//
//  DiscoverViewModel.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import Foundation
import RxRelay
import RxSwift

struct DiscoverViewModel {
    
    // MARK: - Properties
    
    var movieListData = BehaviorRelay<[MovieFront]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: - Helpers
    
    func requestData(page: Int) {
        let url = APIService.configureUrlString(category: .nowPlaying, language: .english, page: page)
        
        APIService.fetchWithRx(url: url, retries: 2)
            .map { data -> [MovieFront] in
                guard let response = try? JSONDecoder().decode(MovieList.self, from: data) else { return [] }
                
                return response.results.map { MovieFront.convertFromMovieInfo(movie: $0) }
            }
            .take(1)
            .bind(to: movieListData)
            .disposed(by: disposeBag)
    }
}
