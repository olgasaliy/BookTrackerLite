//
//  ImageCacheTests.swift
//  BookTrackerLiteTests
//
//  Created by Olha Salii on 19.11.2024.
//

import XCTest
@testable
import BookTrackerLite

final class ImageCacheTests: XCTestCase {
    
    let imageCache = ImageCache.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        imageCache.clearCache()
    }

    func testSetAndGetImage_success() throws {
        let image = UIImage()
        let key = "testKey"
        imageCache.setImage(image, for: key)
        
        let result = imageCache.getImage(for: key)
        
        XCTAssertEqual(result, image)
    }
    
    func testGetImage_failure() throws {
        let key = "missingKey"
        
        let result = imageCache.getImage(for: key)
        
        XCTAssertNil(result)
    }


}
