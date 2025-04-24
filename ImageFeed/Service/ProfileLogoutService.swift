//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 24.04.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    
    // MARK: - Public Properties
    static let shared = ProfileLogoutService()
    
    // MARK: - Private Properties
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func logout() {
        oAuth2TokenStorage.token = nil
        
        cleanCookies()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    // MARK: - Private Methods
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
