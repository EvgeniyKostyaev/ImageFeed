//
//  UserResult.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 05.04.2025.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}
