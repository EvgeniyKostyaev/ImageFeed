//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 15.04.2025.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Public Properties
    static let shared = ImagesListService()
    
    // MARK: - Private Properties
    private(set) var photos: [PhotoModel] = []

    private var lastLoadedPage: Int?
    
    // MARK: - Initializers
    private init() {}
    
    // ...
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
    }
}
