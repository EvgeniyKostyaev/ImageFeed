//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 25.03.2025.
//

import Foundation

private enum Keys: String {
    case token
}

final class OAuth2TokenStorage {
    
    private let storage: UserDefaults = .standard
    
    var token: String {
        get {
            storage.string(forKey: Keys.token.rawValue) ?? String()
        }
        
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
