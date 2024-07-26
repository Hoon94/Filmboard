//
//  APIService.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/24/24.
//

import Foundation
import RxSwift

struct APIService {
    
    // MARK: - Static
    
    static func fetchRequest(url: String, retries: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlString = URL(string: url) else {
            print("DEBUG: Invalid URL")
            return
        }
        
        let task = URLSession(configuration: .default).dataTask(with: urlString) { data, response, error in
            print("DEBUG: [Request] \(urlString.absoluteString)")
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                completion(.failure(error))
                
                return
            }
            
            guard let safeData = data else {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                print("DEBUG: Error is no data")
                completion(.failure(NSError(domain: "no data", code: httpResponse.statusCode)))
                
                return
            }
            
            completion(.success(safeData))
        }
        
        task.resume()
    }
    
    static func fetchWithRx(url: String, retries: Int) -> Observable<Data> {
        return Observable.create { emitter in
            fetchRequest(url: url, retries: retries) { result in
                switch result {
                case .success(let data):
                    print("DEBUG: Success \(String(decoding: data, as: UTF8.self))")
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    print("DEBUG: Failure \(error.localizedDescription)")
                    emitter.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Lifecycle
    
    private init() { }
}
