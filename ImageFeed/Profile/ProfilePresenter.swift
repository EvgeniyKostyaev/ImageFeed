//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 15.05.2025.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewIsReady()
    
    func onLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: Public Properties
    var view: ProfileViewControllerProtocol?
    
    // MARK: Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileService = ProfileService.shared
    
    private let profileLogoutService = ProfileLogoutService.shared
    
    // MARK: Public Methods
    func viewIsReady() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard
                    let self,
                    let profileImageURL = ProfileImageService.shared.profileImageURL,
                    let url = URL(string: profileImageURL)
                else { return }
                self.view?.updateAvatar(url: url)
            }
        
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
    }
    
    func onLogout() {
        profileLogoutService.logout()
    }
}
