//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Evgeniy Kostyaev on 14.05.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewIsReady() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewIsReadyCalled)
    }
}
