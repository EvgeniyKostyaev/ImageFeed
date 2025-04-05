//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 05.04.2025.
//

import Foundation

enum ProfileImageServiceConstants {
    static let unsplashProfileImageURLString = "https://api.unsplash.com/users/:username"
}

final class ProfileImageService {
    
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
       
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private(set) var avatarURL: String?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileImageRequest(authToken: token, username: username) else {
            print("Ошибка: не удалось создать запрос для изображения профиля")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let userResult = try SnakeCaseJSONDecoder().decode(UserResult.self, from: data)
                    self?.avatarURL = userResult.profileImage.small
                    completion(.success(userResult.profileImage.small))
                } catch {
                    DispatchQueue.main.async {
                        print("Ошибка декодирования: \(error)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Ошибка сети: \(error)")
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastToken = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makeProfileImageRequest(authToken: String, username: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: ProfileImageServiceConstants.unsplashProfileImageURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "username", value: username)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
     }

}
