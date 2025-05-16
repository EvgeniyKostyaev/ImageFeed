//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 14.05.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewIsReady()
    
    func onFetchPhotosNextPage()
    
    func onChangeLike(for indexPath: IndexPath)
    
    func getPhotos() -> [PhotoModel]
    
    func getLargeImageURL(for indexPath: IndexPath) -> URL?
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: - Public Properties
    var view: ImagesListViewControllerProtocol?
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService.shared
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private var photos: [PhotoModel] = []
    
    // MARK: - Initializers
    deinit {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Public Methods
    func viewIsReady() {
        onFetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                
                let oldCount = self.photos.count
                var newPhotos = self.imagesListService.photos

                if oldCount > 0 {
                    for i in 0..<min(oldCount, newPhotos.count) {
                        newPhotos[i].isLiked = self.photos[i].isLiked
                    }
                }

                self.photos = newPhotos

                if newPhotos.count > oldCount {
                    let insertRows = (oldCount..<newPhotos.count).map {
                        IndexPath(row: $0, section: 0)
                    }
                    self.view?.updateTableViewAnimated(insertRows: insertRows)
                }
            }
    }
    
    func onFetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func onChangeLike(for indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        
        view?.showProgressHUD()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            self.view?.hideProgressHUD()
            
            switch result {
            case .success(let updatedPhoto):
                self.photos[indexPath.row] = updatedPhoto
                view?.updateLikeForCell(at: indexPath, isLiked: updatedPhoto.isLiked)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPhotos() -> [PhotoModel] {
        return self.photos
    }
    
    func getLargeImageURL(for indexPath: IndexPath) -> URL? {
        return URL(string: photos[indexPath.row].largeImageURL)
    }
    
}
