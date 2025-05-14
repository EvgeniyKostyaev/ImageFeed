//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 14.05.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    
    func getPhotos() -> [PhotoModel]
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: - Public Properties
    var view: (any ImagesListViewControllerProtocol)?
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService.shared
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private var photos: [PhotoModel] = []
    
    // MARK: - Public Methods
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                
                let oldRowsCount = self.photos.count
                let newRowsCount = self.imagesListService.photos.count
                self.photos = self.imagesListService.photos
                
                if oldRowsCount != newRowsCount {
                    let insertRows = (oldRowsCount..<newRowsCount).map {
                        IndexPath(row: $0, section: 0)
                    }
                    
                    self.view?.updateTableViewAnimated(insertRows: insertRows)
                }
            }
    }
    
    func getPhotos() -> [PhotoModel] {
        return self.photos
    }
    
}
