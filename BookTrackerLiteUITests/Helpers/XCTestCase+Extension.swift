//
//  XCTestCase+Extensions.swift
//  BookTrackerLiteUITests
//
//  Created by Olha Salii on 25.11.2024.
//

import Foundation
import XCTest

extension XCTestCase {
    func pauseTestFor(_ seconds: TimeInterval) {
        // Create an expectation
        let expectation = XCTestExpectation(description: "Pause")

        // Fulfill the expectation after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            expectation.fulfill()
        }

        // Wait for the expectation
        wait(for: [expectation], timeout: 2.0)
    }
}
