//
//  BookListViewModelTests.swift
//  BookTrackerLiteTests
//
//  Created by Olha Salii on 19.11.2024.
//

import XCTest
@testable
import BookTrackerLite

final class BookListViewModelTests: XCTestCase {

    var viewModel: BookListViewModel!
    var bookService: BookServiceStub!
    var delegate: BookListViewModelDelegateMock!
    
    override func setUpWithError() throws {
        bookService = BookServiceStub()
        DependencyManager.shared.register(bookService, for: BookService.self)
        delegate = BookListViewModelDelegateMock()
        viewModel = BookListViewModel(delegate: delegate)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetBook_success() throws {
        bookService.mockServiceWithBooks()
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        viewModel.getBooks(with: "test")
        // Wait for the async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        guard let result = viewModel.getBook(at: 0) else {
            XCTFail("Could not get book at index 0")
            return
        }
        
        guard let firstBook = bookService.volumesFetchResponse?.items?.first?.volumeInfo else {
            XCTFail("No first book in test data")
            return
        }
        XCTAssertEqual(result, firstBook)
    }
    
    func testGetBook_failure() throws {
        bookService.mockServiceWithBooks()
        
        let result = viewModel.getBook(at: 3)
        XCTAssertNil(result)
    }
    
    func testGetBooks_withNoSearchText_success() throws {
        bookService.mockServiceWithRandomBooks()
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        viewModel.getBooks(with: "")
        // Wait for the async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(delegate.didBooksUpdateWasCalled)
        XCTAssertEqual(viewModel.booksCount, 2)
    }
    
    func testGetBooks_withNoSearchText_failure() throws {
        bookService.error = URLError(.networkConnectionLost)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        viewModel.getBooks(with: "")
        // Wait for the async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertTrue(delegate.didErrorOccurWasCalled)
    }
    
    func testGetBooks_withSearchText_success() throws {
        bookService.mockServiceWithBooks()
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        viewModel.getBooks(with: "test")
        // Wait for the async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(delegate.didBooksUpdateWasCalled)
        XCTAssertEqual(viewModel.booksCount, 3)
    }
    
    func testGetBooks_withSearchText_failure() throws {
        bookService.error = URLError(.networkConnectionLost)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        viewModel.getBooks(with: "test")
        // Wait for the async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(delegate.didErrorOccurWasCalled)
    }
    
    func testGetRandomBooks_success() throws {
        bookService.mockServiceWithRandomBooks()
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        viewModel.getBooks(with: "")
        // Wait for the async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(delegate.didBooksUpdateWasCalled)
        XCTAssertEqual(viewModel.booksCount, 2)
    }
    
    func testGetRandomBooks_failure() throws {
        bookService.error = URLError(.networkConnectionLost)
        
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        viewModel.getBooks(with: "")
        // Wait for the async call to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(delegate.didErrorOccurWasCalled)
    }
    
}

class BookListViewModelDelegateMock: BookListViewModelDelegate {
    var didBooksUpdateWasCalled: Bool = false
    var didErrorOccurWasCalled: Bool = false
    
    func didBooksUpdate() {
        didBooksUpdateWasCalled = true
    }
    
    func didErrorOccur(error: String) {
        didErrorOccurWasCalled = true
    }
}
