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
    
    private(set) var profile: ProfileModel?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            print("[fetchProfile] Ошибка: гонка запросов")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileRequest(authToken: token) else {
            print("[fetchProfile] Ошибка: не удалось создать профиль запрос")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let data):
                if let profile = self?.convert(profileResult: data) {
                    self?.profile = profile
                    completion(.success(profile))
                } else {
                    print("[fetchProfile] Ошибка конвертирования")
                    completion(.failure(ServiceError.invalidRequest))
                }
            case .failure(let error):
                print("[fetchProfile] Ошибка сети: \(error.localizedDescription)")
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
    
    private func convert(profileResult: ProfileResult) -> ProfileModel {
        let profile = ProfileModel(
            username: profileResult.username,
            name: "\(profileResult.firstName ?? String()) \(profileResult.lastName ?? String())",
            loginName: profileResult.firstName != nil ? "@\(profileResult.firstName ?? String())" : String(),
            bio: profileResult.bio
        )
                                                  
        return profile
    }

}

