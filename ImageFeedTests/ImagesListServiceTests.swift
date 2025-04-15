//
//  ImagesListServiceTests.swift
//  ImagesListServiceTests
//
//  Created by Evgeniy Kostyaev on 15.04.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    
    private let imagesListService = ImagesListService.shared
    
    func testFetchPhotos() {
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        imagesListService.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 20)
        
        XCTAssertEqual(imagesListService.photos.count, 10)
    }
}
