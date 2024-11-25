//
//  ImageCache.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 15.11.2024.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

protocol ImageCacher {
    func getCachedImage(for key: String) -> UIImage?
    func cacheImage(_ image: UIImage, for key: String)
}

extension ImageCacher {
    func getCachedImage(for key: String) -> UIImage? {
        ImageCache.shared.getImage(for: key)
    }
    
    func cacheImage(_ image: UIImage, for key: String) {
        ImageCache.shared.setImage(image, for: key)
    }
}
