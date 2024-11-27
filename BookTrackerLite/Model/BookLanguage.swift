//
//  BookLanguage.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//
import Foundation

enum BookLanguage: String, TitledEnum {
    case english = "en"
    case polish = "pl"
    case german = "de"
    
    var title: String {
        switch self {
        case .english: return "english"
        case .polish: return "polish"
        case .german: return "german"
        }
    }
}
