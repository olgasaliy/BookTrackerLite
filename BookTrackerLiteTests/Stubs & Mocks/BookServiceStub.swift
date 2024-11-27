//
//  BookServiceStubs.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 19.11.2024.
//

import Foundation
import UIKit
@testable import BookTrackerLite

class BookServiceStub: BookService {
    
    var volumesFetchResponse: VolumesFetchResponse?
    var randomVolumesFetchResponse: VolumesFetchResponse?
    var error: Error?
    
    func fetchVolumes(configuration: VolumesFetchConfiguration, completion: @escaping (Result<VolumesFetchResponse, any Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if configuration.searchQuery == "bestseller" {
            if let randomVolumesFetchResponse {
                completion(.success(randomVolumesFetchResponse))
            } else {
                completion(.failure(URLError(.unknown)))
            }
            return
        }
        
        if let volumesFetchResponse = volumesFetchResponse {
            completion(.success(volumesFetchResponse))
        } else {
            completion(.failure(URLError(.unknown)))
        }
    }
    
    func fetchVolumeDetails(id: String, completion: @escaping (Result<VolumeResource, any Error>) -> Void) {}
    
    func getImage(from imageLinks: ImageLinks, preferredSize: ImageLinks.Size, completion: @escaping (Result<UIImage, any Error>) -> Void) {}
}

extension BookServiceStub {
    func mockServiceWithBooks() {
        let book1 = VolumeResource(volumeInfo: Volume(title: "Book1", subtitle: nil, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: "1")
        let book2 = VolumeResource(volumeInfo: Volume(title: "Book2", subtitle: nil, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: "2")
        let book3 = VolumeResource(volumeInfo: Volume(title: "Book3", subtitle: nil, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: "3")
        let books = [book1, book2, book3]
        let volumesFetchResponse = VolumesFetchResponse(items: books, totalItems: 3)
        self.volumesFetchResponse = volumesFetchResponse
    }
    
    func mockServiceWithRandomBooks() {
        let book1 = VolumeResource(volumeInfo: Volume(title: "Bestseller1", subtitle: nil, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: "1")
        let book2 = VolumeResource(volumeInfo: Volume(title: "Bestseller2", subtitle: nil, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: "2")
        let books = [book1, book2]
        let volumesFetchResponse = VolumesFetchResponse(items: books, totalItems: 2)
        randomVolumesFetchResponse = volumesFetchResponse
    }
}
