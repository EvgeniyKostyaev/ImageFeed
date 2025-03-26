//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 26.03.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let showImagesListScreenSegueIdentifier = "ShowImagesListScreen"
    private let storage = OAuth2TokenStorage()
    
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token, !token.isEmpty {
            performSegue(withIdentifier: showImagesListScreenSegueIdentifier, sender: nil)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}
