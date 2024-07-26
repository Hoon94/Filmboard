//
//  DetailViewModel.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import Foundation
import RxRelay
import RxSwift

struct DetailViewModel {
    
    // MARK: - Properties
    
    let movieDetailData = BehaviorRelay<MovieDetail?>(value: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    init(contentId: Int) {
        requestData(contentId: contentId)
    }
    
    // MARK: - Helpers
    
    private func requestData(contentId: Int) {
        let url = APIService.configureUrlString(id: contentId, language: .english)
        
        APIService.fetchWithRx(url: url, retries: 2)
            .map { data -> MovieDetail? in
                let response = try? JSONDecoder().decode(MovieDetail.self, from: data)
                
                return response
            }
            .take(1)
            .bind(to: movieDetailData)
            .disposed(by: disposeBag)
    }
}
