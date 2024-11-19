//
//  BookService.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 12.11.2024.
//

import Foundation
import UIKit

protocol BookService {
    func fetchVolumes(configuration: VolumesFetchConfiguration, completion: @escaping (Result<VolumesFetchResponse, Error>) -> Void)
    func fetchVolumeDetails(id: String, completion: @escaping (Result<VolumeResource, Error>) -> Void)
    func getImage(from imageLinks: ImageLinks, preferredSize: ImageLinks.Size, completion: @escaping (Result<UIImage, any Error>) -> Void)
}
