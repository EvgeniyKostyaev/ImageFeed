//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 25.03.2025.
//

import Foundation
import SwiftKeychainWrapper

private enum Keys: String {
    case token
}

final class OAuth2TokenStorage {
    
    // MARK: - Public Properties
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue, withAccessibility: .whenUnlockedThisDeviceOnly)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
    
    // MARK: - Initializers
    private init() {}
}
