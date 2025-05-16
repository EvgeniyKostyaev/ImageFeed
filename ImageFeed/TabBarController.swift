//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 09.04.2025.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditorialActive),
            selectedImage: nil
        )
        imagesListViewController.view.backgroundColor = UIColor(named: "ypBlack")
        
        let profileViewController = ProfileViewController()
        
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        profileViewController.view.backgroundColor = UIColor(named: "ypBlack")
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
