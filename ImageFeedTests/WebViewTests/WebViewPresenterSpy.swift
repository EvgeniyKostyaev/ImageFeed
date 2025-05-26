//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Evgeniy Kostyaev on 13.05.2025.
//

import Foundation
@testable import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewIsReadyCalled: Bool = false
    
    var view: WebViewViewControllerProtocol?
    
    func viewIsReady() {
        viewIsReadyCalled = true
    }
    
    func onUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func getCode(from url: URL) -> String? {
        return nil
    }
    
    
}
