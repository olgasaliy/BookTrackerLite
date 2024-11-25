//
//  GoogleBooksAPIService.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 11.11.2024.
//

import Foundation
import UIKit

class GoogleBooksAPIService: BookService, ImageCacher {
    
    private struct Configuration {
        static let baseURL = "https://www.googleapis.com/books/v1/"
        static var apiKey: String {
            if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
               let apiKey = dict["GOOGLE_BOOKS_API_KEY"] as? String {
                return apiKey
            }
            return ""
        }
    }
    
    func fetchVolumes(configuration: VolumesFetchConfiguration, completion: @escaping (Result<VolumesFetchResponse, Error>) -> Void) {
        guard let url = createURL(with: "volumes", queryItems: configuration.asQueryItems()) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        networkLayer.fetchData(from: url, completion: completion)
    }
    
    func fetchVolumeDetails(id: String, completion: @escaping (Result<VolumeResource, Error>) -> Void) {
        guard let url = createURL(with: "volumes/\(id)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        networkLayer.fetchData(from: url, completion: completion)
    }
    
    func getImage(from imageLinks: ImageLinks, preferredSize: ImageLinks.Size, completion: @escaping (Result<UIImage, any Error>) -> Void) {
        guard let urlString = imageLinks.getURLString(for: preferredSize),
        let url = URL(string: urlString) else {
            completion(.failure(URLError(.zeroByteResource)))
            return
        }
        
        fetchImageFromCacheOrFromNetwork(url: url, completion: completion)
    }
    
    private func createURL(with path: String, queryItems: [URLQueryItem] = []) -> URL? {
        let queryItemsWithKey = queryItems + [URLQueryItem(name: "apiKey", value: Configuration.apiKey)]
        return URL(string: Configuration.baseURL)?.appending(path: path).appending(queryItems: queryItemsWithKey)
    }
    
    private func fetchImageFromCacheOrFromNetwork(url: URL, completion: @escaping (Result<UIImage, any Error>) -> Void) {
        if let cachedImage = getCachedImage(for: url.absoluteString) {
            completion(.success(cachedImage))
        } else {
            networkLayer.fetchData(from: url) { (result: Result<Data, Error>) in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self.cacheImage(image, for: url.absoluteString)
                        completion(.success(image))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

