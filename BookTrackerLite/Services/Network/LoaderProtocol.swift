//
//  LoaderProtocol.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 21.11.2024.
//
import Foundation

protocol LoaderProtocol {
    func fetchData<T>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) where T: Codable
}
