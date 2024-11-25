//
//  Volume.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 11.11.2024.
//

import Foundation

struct Volume: Codable, Equatable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let mainCategory: String?
    let averageRating: Double?
    let imageLinks: ImageLinks?
    
    static func == (lhs: Volume, rhs: Volume) -> Bool {
        return lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle &&
               lhs.authors == rhs.authors &&
               lhs.publisher == rhs.publisher &&
               lhs.publishedDate == rhs.publishedDate &&
               lhs.description == rhs.description &&
               lhs.pageCount == rhs.pageCount &&
               lhs.mainCategory == rhs.mainCategory &&
               lhs.averageRating == rhs.averageRating &&
               lhs.imageLinks == rhs.imageLinks
    }
}

struct VolumeResource: Codable {
    let volumeInfo: Volume
    let id: String
}

struct VolumesFetchResponse: Codable {
    let items: [VolumeResource]
    let totalItems: Int
}
