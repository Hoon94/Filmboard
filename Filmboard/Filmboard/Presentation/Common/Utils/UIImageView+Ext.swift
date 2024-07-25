//
//  UIImageView+Ext.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/25/24.
//

import UIKit

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var savedTask: URLSessionTask? {
        get {
            objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var savedUrl: URL? {
        get {
            objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIImageView {
    func setImage(path: String?, placeholder: UIImage? = nil) {
        if let path {
            setImage(with: URL(string: path), placeholder: placeholder)
        } else {
            setImage(with: nil, placeholder: placeholder)
        }
    }
    
    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        savedTask?.cancel()
        savedTask = nil
        
        image = placeholder
        
        guard let url = url else { return }
        
        if let cachedImage = ImageCacheManager.shared.loadCachedData(for: url.absoluteString) {
            image = cachedImage
            
            return
        }
                
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error, (error as? URLError)?.code != .cancelled {
                print("DEBUG: Network error with \(error.localizedDescription)")
                
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("DEBUG: Unable to decode image")
                
                return
            }
            
            ImageCacheManager.shared.saveCacheData(of: image, for: url.absoluteString)
            if url == self?.savedUrl {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
        
        savedUrl = url
        savedTask = task
        task.resume()
    }
}
