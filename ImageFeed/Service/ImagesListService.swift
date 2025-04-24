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
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private(set) var photos: [PhotoModel] = []
    
    private var lastLoadedPage: Int?
    private let perPage = 10
    
    private var lastPhotoId: String?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        fetchPhotos(page: nextPage, perPage: perPage) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos.append(contentsOf: photos)
                
                guard let self = self else { return }
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos])
                
            case .failure(let error):
                print("[fetchPhotos] Ошибка сети: \(error.localizedDescription)")
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastPhotoId != photoId else {
            print("[changeLike] Ошибка: гонка запросов")
            completion(.failure(ServiceError.requestRace))
            return
        }
        
        task?.cancel()
        lastPhotoId = photoId
        
        guard let request = makeChangeLikeRequest(photoId: photoId, isLike: isLike) else {
            print("[changeLike] Ошибка: не удалось создать запрос фотографий")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoUpdatedResult, Error>) in
            switch result {
            case .success(let data):
                if let photo = self?.convert(photoResult: data.photo) {
                    completion(.success(photo))
                } else {
                    print("[changeLike] Ошибка конвертирования")
                    completion(.failure(ServiceError.invalidRequest))
                }
            case .failure(let error):
                print("[changeLike] Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastPhotoId = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func fetchPhotos(page: Int, perPage: Int, completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastLoadedPage != page else {
            print("[fetchPhotos] Ошибка: гонка запросов")
            completion(.failure(ServiceError.requestRace))
            return
        }
        
        task?.cancel()
        
        guard let request = makePhotosRequest(page: page, perPage: perPage) else {
            print("[fetchPhotos] Ошибка: не удалось создать запрос фотографий")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let data):
                if let photos = self?.convert(photoResults: data) {
                    self?.lastLoadedPage = page
                    completion(.success(photos))
                } else {
                    print("[fetchPhotos] Ошибка конвертирования")
                    self?.handleLoadError(page: page)
                    completion(.failure(ServiceError.invalidRequest))
                }
            case .failure(let error):
                self?.handleLoadError(page: page)
                completion(.failure(error))
            }
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func handleLoadError(page: Int) {
        lastLoadedPage = (page > 1) ? page - 1 : nil
        print("[fetchPhotos] Ошибка загрузки страницы \(page). LastLoadedPage обновлён: \(lastLoadedPage ?? 0)")
    }
    
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
    
    private func makeChangeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        if let token = oAuth2TokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if (isLike) {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        
        return request
    }
    
    private func convert(photoResult: PhotoResult) -> PhotoModel {
        return PhotoModel(
            id: photoResult.id,
            size: CGSize.init(width: photoResult.width, height: photoResult.height),
            createdAt: photoResult.createdAt,
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
    
    private func convert(photoResults: [PhotoResult]) -> [PhotoModel] {
        return photoResults.map(convert)
    }
    
}
