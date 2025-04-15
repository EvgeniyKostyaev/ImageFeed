//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 15.04.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likes: Int
    let likedByUser: Bool
    let description: String
    let urls: PhotoUrlsResult
}
