//
//  NetworkingLayerStub.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 21.11.2024.
//
import Foundation
@testable import BookTrackerLite

class NetworkingLayerStub: NetworkingLayer {
    var result: Result<Data, Error>? = nil
    
    override func fetchData<T>(from url: URL, completion: @escaping (Result<T, any Error>) -> Void) where T : Codable {
        switch result {
        case .success(let data):
            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(decodedData))
            } else {
                completion(.failure(URLError(.cannotDecodeRawData)))
            }
        case .failure(let error):
            completion(.failure(error))
        default:
            completion(.failure(URLError(.unknown)))
        }
        
    }
}
