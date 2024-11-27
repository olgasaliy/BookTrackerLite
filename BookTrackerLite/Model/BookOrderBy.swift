//
//  BookOrderBy.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//
import Foundation

enum BookOrderBy: String, TitledEnum {
    case relevance
    case newest
    
    var title: String {
        switch self {
        case .relevance: return "Relevance"
        case .newest: return "Newest"
        }
    }
}
