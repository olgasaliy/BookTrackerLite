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
    
    private var books: [Volume] = []
    private var totalItems: Int = 0
    private var debounceTimer: DispatchWorkItem?
    private weak var delegate: BookListViewModelDelegate?
    
    init(delegate: BookListViewModelDelegate?) {
        self.bookService = resolve(BookService.self)
        self.delegate = delegate
    }
    
    func getBook(at index: Int) -> Volume? {
        return books[safe: index]
    }
    
    func getBestsellers() {
        let configuration = VolumesFetchConfiguration(searchQuery: "bestseller",
                                                      limit: 15)
        fetchBooks(with: configuration)
    }
    
    func getBooks(with searchText: String) {
        guard !searchText.isEmpty else {
            getBestsellers()
            return
        }
        
        debounceTimer?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            let configuration = VolumesFetchConfiguration(searchQuery: searchText,
                                                          limit: 10)
            self?.fetchBooks(with: configuration)
        }
        
        debounceTimer = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
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
                self.books = volumes.items.compactMap { $0.volumeInfo }
                self.totalItems = volumes.totalItems
                self.delegate?.didBooksUpdate()
            case .failure(let error):
                self.delegate?.didErrorOccur(error: error.detailedDescription)
            }
        }
    }
    
}
