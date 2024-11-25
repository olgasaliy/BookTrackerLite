//
//  BookListViewControllerUITests.swift
//  BookTrackerLiteUITests
//
//  Created by Olha Salii on 19.11.2024.
//

import XCTest

final class BookListViewControllerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchEnvironment = ["UITest": "true"]
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testInitialStateBooksList() throws {
        XCTAssertTrue(app.navigationBars["Book Tracker"].exists)
        let tableView = app.tables["bookListTableView"]
        XCTAssertTrue(tableView.exists)
        
        XCTAssertEqual(tableView.cells.count, 2)
        
    }
    
    func testSearchBarUpdatesBooksList() throws {
        XCTAssertTrue(app.navigationBars["Book Tracker"].exists)
        let tableView = app.tables["bookListTableView"]
        XCTAssertTrue(tableView.exists)
  
        let searchBar = app.searchFields["Search for books"]
        XCTAssertTrue(searchBar.exists)
        
        searchBar.tap()
        searchBar.typeText("Swift Programming")
        expectation(for: NSPredicate(format: "cells.count > 0"), evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 2.0)
        
        XCTAssertEqual(tableView.cells.count, 3)
    }
    
    func testClearSearchBarBooksList() throws {
        XCTAssertTrue(app.navigationBars["Book Tracker"].exists)
        let tableView = app.tables["bookListTableView"]
        XCTAssertTrue(tableView.exists)
  
        let searchBar = app.searchFields["Search for books"]
        XCTAssertTrue(searchBar.exists)
        
        searchBar.tap()
        searchBar.typeText("Swift Programming")
        expectation(for: NSPredicate(format: "cells.count > 0"), evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 2.0)
        
        XCTAssertEqual(tableView.cells.count, 3)
        
        let clearButton = searchBar.buttons["Clear text"].firstMatch
        if clearButton.exists {
            clearButton.tap()
            expectation(for: NSPredicate(format: "cells.count > 0"), evaluatedWith: tableView, handler: nil)
            waitForExpectations(timeout: 2.0)
            XCTAssertEqual(tableView.cells.count, 2)
        }
    }
    
    func testEmptySearchResults() throws {
        XCTAssertTrue(app.navigationBars["Book Tracker"].exists)
        let tableView = app.tables["bookListTableView"]
        XCTAssertTrue(tableView.exists)
        
        let searchBar = app.searchFields["Search for books"]
        XCTAssertTrue(searchBar.exists)
        
        searchBar.tap()
        searchBar.typeText("non existent book")
        expectation(for: NSPredicate(format: "cells.count == 0"), evaluatedWith: tableView, handler: nil)
        waitForExpectations(timeout: 2.0)
        XCTAssertEqual(tableView.cells.count, 0)
    }
    
    func testErrorHandling() throws {
        XCTAssertTrue(app.navigationBars["Book Tracker"].exists)
        let tableView = app.tables["bookListTableView"]
        XCTAssertTrue(tableView.exists)
        
        let searchBar = app.searchFields["Search for books"]
        XCTAssertTrue(searchBar.exists)
        
        searchBar.tap()
        searchBar.typeText("book error")
        pauseTestFor(1)
        
        let errorMessage = "The server returned data that could not be decoded. Ensure the data format is correct."
        
        let alert = app.alerts["Error"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.staticTexts[errorMessage].exists)
    }
    
}


