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
    
    static let shared = OAuth2Service()
    private init() {}
    
    // MARK: - Public Methods
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Ошибка: не удалось создать токен запрос")
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let oAuthTokenResponseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(oAuthTokenResponseBody.accessToken))
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
        }
        
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
        request.httpMethod = "POST"
        
        return request
     }

}
