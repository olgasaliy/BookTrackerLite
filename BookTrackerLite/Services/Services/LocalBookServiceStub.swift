//
//  LocalBookServiceStub.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 21.11.2024.
//

import Foundation
import UIKit

class LocalBookServiceStub: BookService {
    func fetchVolumes(configuration: VolumesFetchConfiguration, completion: @escaping (Result<VolumesFetchResponse, any Error>) -> Void) {
        switch configuration.searchQuery {
        case "bestseller":
            getRandomBooks(completion: completion)
        case "non existent book":
            getNonExistentBooks(completion: completion)
        case "book error":
            getBooksWithError(completion: completion)
        default:
            getBooks(with: configuration.searchQuery, completion: completion)
        }
    }
    
    func fetchVolumeDetails(id: String, completion: @escaping (Result<VolumeResource, any Error>) -> Void) { }
    
    func getImage(from imageLinks: ImageLinks, preferredSize: ImageLinks.Size, completion: @escaping (Result<UIImage, any Error>) -> Void) { }
    
    private func getRandomBooks(completion: @escaping (Result<VolumesFetchResponse, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "randomBooks",
                                          withExtension: "json") else {
            completion(.failure(URLError(.fileDoesNotExist)))
            return
        }
        
        networkLayer.fetchData(from: url, completion: completion)
    }
    
    private func getBooks(with searchText: String,
                          completion: @escaping (Result<VolumesFetchResponse, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "books",
                                          withExtension: "json") else {
            completion(.failure(URLError(.fileDoesNotExist)))
            return
        }
        
        networkLayer.fetchData(from: url, completion: completion)
    }
    
    private func getNonExistentBooks(completion: @escaping (Result<VolumesFetchResponse, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "emptyBookList",
                                        withExtension: "json") else {
            completion(.failure(URLError(.fileDoesNotExist)))
            return
        }
        
        networkLayer.fetchData(from: url, completion: completion)
    }
    
    private func getBooksWithError(completion: @escaping (Result<VolumesFetchResponse, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "bookListWithError",
                                        withExtension: "json") else {
            completion(.failure(URLError(.fileDoesNotExist)))
            return
        }
        
        networkLayer.fetchData(from: url, completion: completion)
    }
}
