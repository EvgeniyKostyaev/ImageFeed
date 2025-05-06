//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 26.03.2025.
//

import UIKit

enum SplashViewControllerTheme {
    static let splashImageViewHeight: CGFloat = 78
    static let splashImageViewWidth: CGFloat = 75
}

final class SplashViewController: UIViewController {

    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let splashImageView = {
        let splashImageView = UIImageView()
        
        splashImageView.backgroundColor = UIColor(named: "ypBlack")
        splashImageView.image = UIImage(named: "launch_screen_icon")
        
        return splashImageView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token, !token.isEmpty {
            fetchProfile(token)
        } else {
            navigateToAuthScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "ypBlack")
        
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashImageView)
        
        NSLayoutConstraint.activate([
            splashImageView.heightAnchor.constraint(equalToConstant: SplashViewControllerTheme.splashImageViewHeight),
            splashImageView.widthAnchor.constraint(equalToConstant: SplashViewControllerTheme.splashImageViewWidth),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Private Methods
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch(result) {
            case .success(let profile):
                if let username = profile.username {
                    self.profileImageService.fetchProfileImageURL(token: token, username: username) { result in
                    }
                }
                
                self.switchToTabBarController()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        window.rootViewController = tabBarController
    }
    
    private func navigateToAuthScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        
        authViewController.delegate = self
           
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true, completion: nil)
    }
}

// MARK: - AuthViewControllerDelegate methods
extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = storage.token, !token.isEmpty else {
            return
        }
        
        fetchProfile(token)
    }
}
