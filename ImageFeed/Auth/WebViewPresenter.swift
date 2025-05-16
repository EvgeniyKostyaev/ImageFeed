//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 12.05.2025.
//

import Foundation

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    
    func viewIsReady()
    func onUpdateProgressValue(_ newValue: Double)
    func getCode(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Public Properties
    var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
    
    // MARK: - Initializers
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Public methods (WebViewPresenterProtocol)
    func viewIsReady() {
        guard let request = authHelper.getAuthRequest() else { return }
        
        view?.load(request: request)
        onUpdateProgressValue(0)
    }
    
    func onUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func getCode(from url: URL) -> String? {
        authHelper.getCode(from: url)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

}
