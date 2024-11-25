//
//  Author.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 11.11.2024.
//

import Foundation

struct ImageLinks: Codable, Equatable {
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
        
        let sizes = Size.allCases
        let currentIndex = sizes.firstIndex(of: size)!
        
        for offset in 1...sizes.count {
            if currentIndex - offset >= 0,
               let url = urls[sizes[currentIndex - offset]] {
                return url
            }
            if currentIndex + offset < sizes.count,
               let url = urls[sizes[currentIndex + offset]] {
                return url
            }
        }
        
        return nil
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
