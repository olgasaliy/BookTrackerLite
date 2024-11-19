//
//  NetworkingLayerTests.swift
//  BookTrackerLiteTests
//
//  Created by Olha Salii on 12.11.2024.
//

import XCTest
@testable import BookTrackerLite

final class NetworkingLayerTests: XCTestCase {
    private let testURL = URL(string: "https://example.com/test")!
        
    func testFetchData_failureWithErrorReturned() throws {
        let urlSession = URLSessionMock(mockError: URLError(.badURL))
        let networkingLayer = NetworkingLayer(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        networkingLayer.fetchData(from: testURL) { (result: Result<[Volume], Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .badURL)
            default:
                XCTFail("Unexpected error type")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testFetchData_failureWithEmptyData() throws {
        let urlSession = URLSessionMock()
        let networkingLayer = NetworkingLayer(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        networkingLayer.fetchData(from: testURL) { (result: Result<[Volume], Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .badServerResponse)
            default:
                XCTFail("Unexpected error type")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testFetchData_failureWithDecoding() throws {
        let urlSession = URLSessionMock(mockData: Data())
        let networkingLayer = NetworkingLayer(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        networkingLayer.fetchData(from: testURL) { (result: Result<[Volume], Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .cannotDecodeRawData)
            default:
                XCTFail("Unexpected error type")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testFetchData_success() throws {
        let title = "Test Book"
        let subtitle = "Test subtitle"
        let pageCount = 100
        let data = """
        {
            "title": "\(title)",
            "subtitle": "\(subtitle)",
            "pageCount": \(pageCount)
        }
        """.data(using: .utf8)
        
        let urlSession = URLSessionMock(mockData: data)
        let networkingLayer = NetworkingLayer(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        networkingLayer.fetchData(from: testURL) { (result: Result<Volume, Error>) in
            switch result {
            case .success(let volume):
                XCTAssertEqual(volume.title, title)
                XCTAssertEqual(volume.subtitle ?? "", subtitle)
                XCTAssertEqual(volume.pageCount ?? 0, pageCount)
            case .failure(_):
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
}

class URLSessionMock: URLSessionProtocol {
    private let mockData: Data?
    private let mockError: Error?
    
    init(mockData: Data? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockError = mockError
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(mockData, nil, mockError)
        
        return URLSessionDataTaskMock()
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() {}
}
