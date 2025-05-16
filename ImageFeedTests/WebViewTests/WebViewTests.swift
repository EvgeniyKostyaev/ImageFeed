//
//  WebViewTests.swift
//  ImageFeedTests
//
//  Created by Evgeniy Kostyaev on 13.05.2025.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewIsReady() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewIsReadyCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // Given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.viewIsReady()
        
        // Then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // Then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // Then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        // Given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // When
        let url = authHelper.getAuthURL()

        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }

        // Then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        // Given
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        
        let url = urlComponents.url!
        
        // When
        let code = authHelper.getCode(from: url)
        
        // Then
        XCTAssertEqual(code, "test code")
    }
}
