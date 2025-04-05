//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 03.04.2025.
//

import Foundation

enum ProfileServiceConstants {
    static let unsplashProfileURLString = "https://api.unsplash.com/me"
}

final class ProfileService {
    
    // MARK: - Public Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
       
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private(set) var profile: Profile?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileRequest(authToken: token) else {
            print("Ошибка: не удалось создать профиль запрос")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profileResult = try SnakeCaseJSONDecoder().decode(ProfileResult.self, from: data)
                    if let profile = self?.convert(profileResult: profileResult) {
                        self?.profile = profile
                        completion(.success(profile))
                    } else {
                        print("Ошибка конвертирования")
                        completion(.failure(ServiceError.invalidRequest))
                    }
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
    private func makeProfileRequest(authToken: String) -> URLRequest? {
        
        guard let urlComponents = URLComponents(string: ProfileServiceConstants.unsplashProfileURLString) else {
            return nil
        }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
     }
    
    private func convert(profileResult: ProfileResult) -> Profile {
        let profile = Profile(
            username: profileResult.username,
            name: "\(profileResult.firstName ?? String()) \(profileResult.lastName ?? String())",
            loginName: profileResult.firstName != nil ? "@\(profileResult.firstName ?? String())" : String(),
            bio: profileResult.bio
        )
                                                  
        return profile
    }

}

