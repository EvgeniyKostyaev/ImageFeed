//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 15.04.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let created_at: String
    let width: Float
    let height: Float
    let likes: Int
    let liked_by_user: Bool
    let description: String
    let urls: PhotoUrlsResult
}
