//
//  GoogleBooksAPIServiceTests.swift
//  BookTrackerLiteTests
//
//  Created by Olha Salii on 12.11.2024.
//

import XCTest
@testable import BookTrackerLite

final class GoogleBooksAPIServiceTests: XCTestCase {
    
    func testFetchVolumes_success() throws {
        let title = "Test Book"
        let subtitle = "Test subtitle"
        let id = "1"
        let totalItems = 1

        let volumes = VolumesFetchResponse(
            items: [VolumeResource(volumeInfo: Volume(title: title, subtitle: subtitle, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: id)],
            totalItems: totalItems
        )
        let encodedData = try! JSONEncoder().encode(volumes)
        
        let networkingLayerStub = NetworkingLayerStub()
        networkingLayerStub.result = .success(encodedData)
        let service = GoogleBooksAPIService(networkingLayer: networkingLayerStub)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        service.fetchVolumes(configuration: VolumesFetchConfiguration(searchQuery: "q")) { result in
            switch result {
            case .success(let volumes):
                XCTAssertEqual(volumes.totalItems, totalItems)
                XCTAssertEqual(volumes.items.count, 1)
                XCTAssertEqual(volumes.items.first!.volumeInfo.title, title)
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testFetchVolumes_failure() throws {
        let title = "Test Book"
        let subtitle = "Test subtitle"
        let id = "1"

        let volumes = [VolumeResource(volumeInfo: Volume(title: title, subtitle: subtitle, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: id)]
        let encodedData = try! JSONEncoder().encode(volumes)
        
        let networkingLayerStub = NetworkingLayerStub()
        networkingLayerStub.result = .success(encodedData)
        let service = GoogleBooksAPIService(networkingLayer: networkingLayerStub)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        service.fetchVolumes(configuration: VolumesFetchConfiguration(searchQuery: "q")) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, URLError(.cannotDecodeRawData).code)
            case .failure(_):
                XCTFail("Expected failure with another error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testFetchVolumeDetails_success() throws {
        let title = "Test Book"
        let subtitle = "Test subtitle"
        let id = "1"

        let volume = VolumeResource(volumeInfo: Volume(title: title, subtitle: subtitle, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil), id: id)
        let encodedData = try! JSONEncoder().encode(volume)
        
        let networkingLayerStub = NetworkingLayerStub()
        networkingLayerStub.result = .success(encodedData)
        let service = GoogleBooksAPIService(networkingLayer: networkingLayerStub)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        service.fetchVolumeDetails(id: id) {result in
            switch result {
            case .success(let volume):
                XCTAssertEqual(volume.id, id)
                XCTAssertEqual(volume.volumeInfo.title, title)
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testFetchVolumeDetails_failure() throws {
        let title = "Test Book"
        let subtitle = "Test subtitle"
        let id = "1"

        let volume = Volume(title: title, subtitle: subtitle, authors: nil, publisher: nil, publishedDate: nil, description: nil, pageCount: nil, mainCategory: nil, averageRating: nil, imageLinks: nil)
        let encodedData = try! JSONEncoder().encode(volume)
        
        let networkingLayerStub = NetworkingLayerStub()
        networkingLayerStub.result = .success(encodedData)
        let service = GoogleBooksAPIService(networkingLayer: networkingLayerStub)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        service.fetchVolumeDetails(id: id) {result in
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, URLError(.cannotDecodeRawData).code)
            case .failure(_):
                XCTFail("Expected failure with another error")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }

}

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

