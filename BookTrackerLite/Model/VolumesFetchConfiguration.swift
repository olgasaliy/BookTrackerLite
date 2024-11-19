//
//  VolumesFetchConfiguration.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 15.11.2024.
//
import Foundation

struct VolumesFetchConfiguration {
    
    enum OrderBy: String {
        case relevance
        case newest
    }
    
    enum Language: String {
        case english = "en"
        case polish = "pl"
        case german = "de"
    }
    
    enum Filter: String {
        case ebooks = "ebooks"
        case freeEbooks = "free-ebooks"
        case full = "full"
        case paidEbooks = "paid-ebooks"
        case partial = "partial"
        
    }
    
    var searchQuery: String
    var limit: Int?
    var availabilityFilter: Filter?
    var language: Language?
    var orderBy: OrderBy?
    
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [URLQueryItem(name: "q", value: "\(searchQuery)")]
        
        if let limit = limit {
            items.append(URLQueryItem(name: "maxResults", value: "\(limit)"))
        }
        
        if let filter = availabilityFilter?.rawValue {
            items.append(URLQueryItem(name: "filter", value: filter))
        }
        
        if let language = language?.rawValue {
            items.append(URLQueryItem(name: "langRestrict", value: language))
        }
        
        if let orderBy = orderBy?.rawValue {
            items.append(URLQueryItem(name: "orderBy", value: orderBy))
        }
        
        return items
    }
}
