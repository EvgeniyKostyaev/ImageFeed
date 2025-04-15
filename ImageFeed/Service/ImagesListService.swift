//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 15.04.2025.
//

import Foundation

enum ImagesListServiceConstants {
    static let unsplashPhotosURLString = "https://api.unsplash.com/photos"
}

final class ImagesListService {
    
    // MARK: - Public Properties
    static let shared = ImagesListService()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private(set) var photos: [PhotoModel] = []
    
    private var lastLoadedPage: Int?
    static let perPage = 10
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        fetchPhotos(page: nextPage, perPage: ImagesListService.perPage) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": photos])
                
            case .failure(let error):
                print("[fetchPhotos] Ошибка сети: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchPhotos(page: Int, perPage: Int, completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastLoadedPage != page else {
            print("[fetchPhotos] Ошибка: гонка запросов")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastLoadedPage = page
        
        guard let request = makePhotosRequest(page: page, perPage: perPage) else {
            print("[fetchPhotos] Ошибка: не удалось создать запрос фотографий")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let data):
                if let photos = self?.convert(photoResults: data) {
                    completion(.success(photos))
                } else {
                    print("[fetchPhotos] Ошибка конвертирования")
                    completion(.failure(ServiceError.invalidRequest))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastLoadedPage = (page == 1) ? nil : page - 1
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: ImagesListServiceConstants.unsplashPhotosURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        if let token = oAuth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = "GET"
        
        return request
    }
    
    private func convert(photoResults: [PhotoResult]) -> [PhotoModel] {
        var photosList: [PhotoModel] = []
        
        photoResults.forEach { photoResult in
            let photo = PhotoModel(
                id: photoResult.id,
                size: CGSize.init(width: photoResult.width, height: photoResult.height),
                createdAt: photoResult.createdAt,
                welcomeDescription: photoResult.description,
                thumbImageURL: photoResult.urls.thumb,
                largeImageURL: photoResult.urls.full,
                isLiked: photoResult.likedByUser
            )
            
            photosList.append(photo)
        }
        
        return photosList
    }
    
}
