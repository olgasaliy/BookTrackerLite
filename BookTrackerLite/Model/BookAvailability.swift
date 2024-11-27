//
//  BookAvailability.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//
import Foundation

enum BookAvailability: String, TitledEnum {
    case ebooks
    case freeEbooks = "free-ebooks"
    case full
    case paidEbooks = "paid-ebooks"
    case partial
    
    var title: String {
        switch self {
        case .ebooks: return "ebooks"
        case .freeEbooks: return "free-ebooks"
        case .full: return "full"
        case .paidEbooks: return "paid-ebooks"
        case .partial: return "partial"
        }
    }
}
