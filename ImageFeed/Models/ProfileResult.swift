//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 03.04.2025.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
}
