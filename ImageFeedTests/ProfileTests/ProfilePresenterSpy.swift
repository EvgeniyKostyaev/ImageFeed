//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Evgeniy Kostyaev on 14.05.2025.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewIsReadyCalled: Bool = false
    
    var view: ProfileViewControllerProtocol?
    
    func viewIsReady() {
        viewIsReadyCalled = true
    }
    
    func onLogout() {
        
    }
    
}
