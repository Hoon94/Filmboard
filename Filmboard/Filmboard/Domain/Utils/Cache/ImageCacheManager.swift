//
//  ImageCacheManager.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import UIKit

class ImageCacheManager {
    
    // MARK: - Static
    
    static let shared = ImageCacheManager()
    
    // MARK: - Properties
    
    private let cache = Cache<String, UIImage>()
    
    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Helpers
    
    func loadCachedData(for key: String) -> UIImage? {
        return cache.loadValue(forKey: key)
    }
    
    func saveCacheData(of image: UIImage, for key: String) {
        cache.insertValue(image, forKey: key)
    }
}
