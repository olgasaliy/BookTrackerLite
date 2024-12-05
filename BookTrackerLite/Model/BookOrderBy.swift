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
    
    static var allCasesSorted: [BookOrderBy] {
        return self.allCases.sorted { $0.title < $1.title }
    }
    
    static func getIndex(of order: BookOrderBy) -> Int {
        return allCasesSorted.firstIndex(of: order) ?? 0
    }
    
    static func getOrder(at index: Int) -> BookOrderBy {
        return allCasesSorted[safe: index] ?? .relevance
    }
}
