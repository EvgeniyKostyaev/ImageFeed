//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Evgeniy Kostyaev on 14.05.2025.
//

import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(String())
        
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(String())
        
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["LikeButton"].tap()
        
        sleep(5)
        
        cellToLike.buttons["LikeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
            
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons["NavBackButton"].tap()
    }
    
    func testProfile() throws {
        sleep(5)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(5)
        
        let nameLabel = app.staticTexts["NameLabel"]
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 5))
        XCTAssertFalse(nameLabel.label.isEmpty)
        
        app.buttons["LogoutButton"].tap()
        
        let logoutAlert = app.alerts["Вы действительно хотите выйти?"]
        XCTAssertTrue(logoutAlert.waitForExistence(timeout: 3))
        logoutAlert.scrollViews.otherElements.buttons["YesAction"].tap()
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 10))
    }
}
