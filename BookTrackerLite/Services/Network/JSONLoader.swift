//
//  JSONLoader.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 21.11.2024.
//

import Foundation

class JSONLoader: LoaderProtocol  {
    func fetchData<T>(from url: URL, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable, T : Encodable {
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch let error as URLError {
            completion(.failure(error))
        } catch {
            completion(.failure(URLError(.cannotDecodeRawData)))
        }
    }
    
}
