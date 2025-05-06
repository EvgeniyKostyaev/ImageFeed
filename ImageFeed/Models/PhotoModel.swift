//
//  PhotoModel.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 15.04.2025.
//

import Foundation

struct PhotoModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
