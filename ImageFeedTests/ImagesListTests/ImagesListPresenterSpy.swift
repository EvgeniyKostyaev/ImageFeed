//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Evgeniy Kostyaev on 14.05.2025.
//

import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewIsReadyCalled: Bool = false
    
    var view: ImagesListViewControllerProtocol?
    
    func viewIsReady() {
        viewIsReadyCalled = true
    }
    
    func onFetchPhotosNextPage() {
        
    }
    
    func onChangeLike(for indexPath: IndexPath) {
        
    }
    
    func getPhotos() -> [PhotoModel] {
        return [PhotoModel]()
    }
    
    func getLargeImageURL(for indexPath: IndexPath) -> URL? {
        return URL(string: String())
    }
}
