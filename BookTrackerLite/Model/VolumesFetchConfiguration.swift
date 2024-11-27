//
//  VolumesFetchConfiguration.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 15.11.2024.
//
import Foundation

struct FilterBookList: Equatable {
    var availability: BookAvailability? = nil
    var language: BookLanguage? = nil
    var orderBy: BookOrderBy? = nil
    var categories: [BookCategory]? = nil
}

struct VolumesFetchConfiguration {
    var searchQuery: String = ""
    var limit: Int? = nil
    var filter: FilterBookList? = nil
    
    func asQueryItems() -> [URLQueryItem] {
        var items = [URLQueryItem]()
        
        var qValue = searchQuery.isEmpty ? "books" : searchQuery
        
        if let categories = filter?.categories, !categories.isEmpty {
            let categoriesQuery = categories.map{ "subject:\($0.rawValue)" }.joined(separator: " AND ")
            qValue += qValue.isEmpty ? categoriesQuery : " \(categoriesQuery)"
        }
        
        items.append(URLQueryItem(name: "q", value: qValue))
        
        if let limit = limit {
            items.append(URLQueryItem(name: "maxResults", value: "\(limit)"))
        }
        
        if let filter = filter?.availability?.rawValue {
            items.append(URLQueryItem(name: "filter", value: filter))
        }
        
        if let language = filter?.language?.rawValue {
            items.append(URLQueryItem(name: "langRestrict", value: language))
        }
        
        if let orderBy = filter?.orderBy?.rawValue {
            items.append(URLQueryItem(name: "orderBy", value: orderBy))
        }
        
        return items
    }
}
