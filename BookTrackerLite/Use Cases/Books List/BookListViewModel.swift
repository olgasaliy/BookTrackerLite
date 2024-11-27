//
//  BookListViewModel.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 13.11.2024.
//

import Foundation
import UIKit

protocol BookListViewModelDelegate: AnyObject {
    func didBooksUpdate()
    func didErrorOccur(error: String)
}

class BookListViewModel {
    let bookService: BookService
    var booksCount: Int { books.count }
    
    private(set) var filter: FilterBookList? {
        didSet {
            applyFilter()
        }
    }
    private var books: [Volume] = []
    private var totalItems: Int = 0
    private var lastSearchText: String?
    private var debounceTimer: DispatchWorkItem?
    private weak var delegate: BookListViewModelDelegate?
    
    init(delegate: BookListViewModelDelegate?) {
        self.bookService = resolve(BookService.self)
        self.delegate = delegate
    }
    
    func getBook(at index: Int) -> Volume? {
        return books[safe: index]
    }
    
    func getBooks(with searchText: String) {
        lastSearchText = searchText
        guard !searchText.isEmpty else {
            getRandomBooks()
            return
        }
        
        debounceTimer?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            let configuration = VolumesFetchConfiguration(searchQuery: searchText,
                                                          limit: 10,
                                                          filter: self?.filter)
            self?.fetchBooks(with: configuration)
        }
        
        debounceTimer = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    func getRandomBooks() {
        let configuration = VolumesFetchConfiguration(limit: 15,
                                                      filter: filter)
        fetchBooks(with: configuration)
    }
    
    private func applyFilter() {
        getBooks(with: lastSearchText ?? "")
    }
    
    private func fetchBooks(with configuration: VolumesFetchConfiguration) {
        DispatchQueue.global().async { [weak self] in
            print("Request started for \(configuration.searchQuery)")
            self?.bookService.fetchVolumes(configuration: configuration) { result in
                self?.handleFetchResult(result)
            }
        }
    }
    
    private func handleFetchResult(_ result: Result<VolumesFetchResponse, Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch result {
            case .success(let volumes):
                if let items = volumes.items {
                    self.books = items.compactMap { $0.volumeInfo }
                } else {
                    self.books.removeAll()
                }
                self.totalItems = volumes.totalItems
                self.delegate?.didBooksUpdate()
            case .failure(let error):
                self.delegate?.didErrorOccur(error: error.detailedDescription)
            }
        }
    }
}

extension BookListViewModel: FilterBookListDelegate {
    func didUpdateFilter(_ filter: FilterBookList?) {
        self.filter = filter
    }
}
