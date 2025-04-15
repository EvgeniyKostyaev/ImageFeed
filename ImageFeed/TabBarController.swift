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
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        profileViewController.view.backgroundColor = UIColor(named: "ypBlack")
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
