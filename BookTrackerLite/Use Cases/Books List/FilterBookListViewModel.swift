//
//  FilterBookListViewModel.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 26.11.2024.
//

import Foundation

protocol FilterBookListDelegate: AnyObject {
    func didUpdateFilter(_ filter: FilterBookList?)
}

class FilterBookListViewModel {
    weak var delegate: FilterBookListDelegate?
    private(set) var filter: FilterBookList
    
    var selectedIndexOfOrderBy: Int {
        set {
            let title = getOrderByTitles()[newValue]
            filter.orderBy = BookOrderBy.allCases.first(where: { $0.title == title })
        }
        get {
            let titles = getOrderByTitles()
            let selectedSortBy = filter.orderBy ?? .relevance
            let index = titles.firstIndex(of: selectedSortBy.title)
            return index ?? 0
        }
    }
    
    init(filter: FilterBookList? = nil, delegate: FilterBookListDelegate? = nil) {
        self.filter = filter ?? FilterBookList()
        self.delegate = delegate
    }
    
    func getOrderByTitles() -> [String] {
        return BookOrderBy.sortedTitles
    }
    
    
    func getAvalabilityTitles() -> [String] {
        return BookAvailability.sortedTitles
    }
    
    func getCategoryTitles() -> [String] {
        return BookCategory.sortedTitles
    }
    
    func getLanguageTitles() -> [String] {
        return BookLanguage.sortedTitles
    }
    
    func applyFilter() {
        delegate?.didUpdateFilter(filter)
    }
}
