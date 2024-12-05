//
//  FilterBookListViewModel.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 26.11.2024.
//

import Foundation
import SwiftUI

protocol FilterBookListDelegate: AnyObject {
    func didUpdateFilter(_ filter: FilterBookList?)
}

class FilterBookListViewModel: ObservableObject {
    weak var delegate: FilterBookListDelegate?
    private(set) var filter: FilterBookList
    @Published var selectedIndexOfOrderBy: Int {
        didSet {
            updateFilterWithOrderBy()
        }
    }
    //TODO: redo selectedindex logic
    init(filter: FilterBookList? = nil, delegate: FilterBookListDelegate? = nil) {
        self.filter = filter ?? FilterBookList()
        self.delegate = delegate
        let selectedSortBy = self.filter.orderBy ?? .relevance
        self.selectedIndexOfOrderBy = BookOrderBy.getIndex(of: selectedSortBy)
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
    
    private func updateFilterWithOrderBy() {
        filter.orderBy = BookOrderBy.getOrder(at: selectedIndexOfOrderBy)
    }
}
