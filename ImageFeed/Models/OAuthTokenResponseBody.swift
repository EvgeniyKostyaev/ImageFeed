//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 25.03.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
