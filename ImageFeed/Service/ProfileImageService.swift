//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 05.04.2025.
//

import Foundation

enum ProfileImageServiceConstants {
    static let unsplashProfileImageURLString = "https://api.unsplash.com/users/"
}

final class ProfileImageService {
    
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
       
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private(set) var profileImageURL: String?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            print("[fetchProfileImageURL] Ошибка: гонка запросов")
            completion(.failure(ServiceError.requestRace))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileImageRequest(authToken: token, username: username) else {
            print("[fetchProfileImageURL] Ошибка: не удалось создать запрос для изображения профиля")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                let profileImageURL = data.profileImage.large
                self.profileImageURL = profileImageURL
                completion(.success(profileImageURL))
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL])
            case .failure(let error):
                print("[fetchProfileImageURL] Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastToken = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makeProfileImageRequest(authToken: String, username: String) -> URLRequest? {
        let urlString = ProfileImageServiceConstants.unsplashProfileImageURLString + username
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = ServiceRequestType.get.rawValue
        
        return request
     }

}
