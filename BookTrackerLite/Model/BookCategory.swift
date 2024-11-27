//
//  BookCategory.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//
import Foundation

enum BookCategory: String, TitledEnum {
    case business
    case philosophy
    case history
    case science
    case technology
    case politics
    case romance
    case fantasy
    
    var title: String {
        switch self {
        case .business: return "Business"
        case .philosophy: return "Philosophy"
        case .history: return "History"
        case .science: return "Science"
        case .technology: return "Technology"
        case .politics: return "Politics"
        case .romance: return "Romance"
        case .fantasy: return "Fantasy"
        }
    }
}
