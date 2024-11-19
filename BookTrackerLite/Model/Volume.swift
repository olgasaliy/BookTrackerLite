//
//  Volume.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 11.11.2024.
//

import Foundation

struct Volume: Codable {
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
}

struct VolumeResource: Codable {
    let volumeInfo: Volume
    let id: String
}

struct VolumesFetchResponse: Codable {
    let items: [VolumeResource]
    let totalItems: Int
}
