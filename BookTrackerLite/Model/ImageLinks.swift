//
//  Author.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 11.11.2024.
//

import Foundation

struct ImageLinks: Codable {
    private var urls: [Size: String]
    
    enum Size: String, CodingKey, CaseIterable {
        case smallThumbnail
        case thumbnail
        case small
        case medium
        case large
        case extraLarge
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Size.self)
        var urls = [Size: String]()
        
        for size in Size.allCases {
            urls[size] = try container.decodeIfPresent(String.self, forKey: size)
        }
        
        self.urls = urls
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Size.self)
        for (size, url) in urls {
            try container.encode(url, forKey: size)
        }
    }
    
    func getURLString(for size: Size) -> String? {
        if let url = urls[size] {
            return url
        }
        
        var url: String? = nil
        var sizes = Size.allCases
        var currentIndex = sizes.firstIndex(of: size)!
        var lIndex = currentIndex
        var rIndex = currentIndex
        let indexesAreInsideOfBounds = lIndex >= 0 && rIndex < sizes.count
        
        repeat {
            lIndex -= 1
            rIndex += 1
            
            url = urls[sizes[lIndex]] ?? urls[sizes[rIndex]]
        } while indexesAreInsideOfBounds && url == nil
        return url
    }
    
}

//struct ImageLinks: Codable {
//    enum Size: CaseIterable {
//        case smallThumbnail
//        case thumbnail
//        case small
//        case medium
//        case large
//        case extraLarge
//    }
//    
//    let smallThumbnail: String?
//    let thumbnail: String?
//    let small: String?
//    let medium: String?
//    let large: String?
//    let extraLarge: String?
//    
//    func getURL(for size: Size) -> String? {
//        return Size.allCases.first(where: { getURLOfTheClosestExistingSize(to: $0) != nil })
//        switch size {
//        case .thumbnail: return thumbnail
//        case .small: return small
//        case .medium: return medium
//        case .large: return large
//        case .smallThumbnail: return smallThumbnail
//        case .extraLarge: return extraLarge
//        }
//    }
//    
//    private func getURLOfTheClosestExistingSize(to size: Size) -> String? {
//        switch size {
//        case .smallThumbnail: return thumbnail ?? small ?? ""
//        case .thumbnail: return smallThumbnail ?? small ?? ""
//        case .small: return thumbnail ?? medium ?? ""
//        case .medium: return small ?? large ?? ""
//        case .large: return medium ?? extraLarge ?? ""
//        case .extraLarge: return medium ?? large ?? ""
//        }
//    }
//    
//    
//}
