//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 22.03.2025.
//

import Foundation

enum OAuth2ServiceConstants {
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}

final class OAuth2Service {
    
    // MARK: - Public Properties
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private let urlSession = URLSession.shared
       
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            print("[fetchOAuthToken] Ошибка: гонка запросов")
            completion(.failure(ServiceError.requestRace))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken] Ошибка: не удалось создать токен запрос")
            completion(.failure(ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("[fetchOAuthToken] Ошибка сети: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: OAuth2ServiceConstants.unsplashTokenURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = ServiceRequestType.post.rawValue
        
        return request
     }

}
