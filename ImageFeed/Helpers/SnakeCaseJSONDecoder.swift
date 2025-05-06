//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 28.03.2025.
//

import Foundation

final class SnakeCaseJSONDecoder: JSONDecoder, @unchecked Sendable {
    override init() {
        super.init()
        
        keyDecodingStrategy = .convertFromSnakeCase
        dateDecodingStrategy = .iso8601
    }
}
