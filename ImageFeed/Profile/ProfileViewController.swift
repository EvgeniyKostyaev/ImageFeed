//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 17.02.2025.
//

import UIKit

enum ProfileViewControllerTheme {
    static let nameLabelFont: CGFloat = 23
    
    static let nicknameLabelFont: CGFloat = 13
    static let nicknameLabelTextColor: UIColor = UIColor(red: 174.0/255.0, green: 175.0/255.0, blue: 180.0/255.0, alpha: 1.0)
    
    static let statusLabelFont: CGFloat = 13
    
    static let logoutButtonCollor: UIColor = UIColor(red: 245.0/255.0, green: 107.0/255.0, blue: 108.0/255.0, alpha: 1.0)
    
    static let userPhotoImageViewHeight: CGFloat = 70
    static let userPhotoImageViewWidth: CGFloat = 70
    
    static let userPhotoImageViewTopConstraint: CGFloat = 32
    
    static let commonLeadingConstraint: CGFloat = 16
    static let commonTrailingConstraint: CGFloat = -16
    static let commonTopConstraint: CGFloat = 8
    
    static let logoutButtonHeight: CGFloat = 44
    static let logoutButtonWidth: CGFloat = 44
}

final class ProfileViewController: UIViewController {
    
    private let userPhotoImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "user_photo_icon"))
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: ProfileViewControllerTheme.nameLabelFont, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        
        return nameLabel
    }()
    
    private let nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.font = .systemFont(ofSize: ProfileViewControllerTheme.nicknameLabelFont, weight: .regular)
        nicknameLabel.textColor = ProfileViewControllerTheme.nicknameLabelTextColor
        nicknameLabel.text = "@ekaterina_nov"
        
        return nicknameLabel
    }()
    
    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = .systemFont(ofSize: ProfileViewControllerTheme.statusLabelFont, weight: .regular)
        statusLabel.textColor = .white
        statusLabel.text = "Hello, world!"
        
        return statusLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_icon") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton)
        )
        logoutButton.tintColor = ProfileViewControllerTheme.logoutButtonCollor
        
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupConstraints()
    }
    
    // MARK: - Helper methods
    private func setupViews() {
        [userPhotoImageView,
         nameLabel,
         nicknameLabel,
         statusLabel,
         logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.heightAnchor.constraint(equalToConstant: ProfileViewControllerTheme.userPhotoImageViewHeight),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: ProfileViewControllerTheme.userPhotoImageViewWidth),
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileViewControllerTheme.userPhotoImageViewTopConstraint),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ProfileViewControllerTheme.commonLeadingConstraint),
            
            nameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: ProfileViewControllerTheme.commonTopConstraint),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ProfileViewControllerTheme.commonLeadingConstraint),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ProfileViewControllerTheme.commonTrailingConstraint),
            
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: ProfileViewControllerTheme.commonTopConstraint),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ProfileViewControllerTheme.commonLeadingConstraint),
            nicknameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ProfileViewControllerTheme.commonTrailingConstraint),
            
            statusLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: ProfileViewControllerTheme.commonTopConstraint),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ProfileViewControllerTheme.commonLeadingConstraint),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ProfileViewControllerTheme.commonTrailingConstraint),
            
            logoutButton.heightAnchor.constraint(equalToConstant: ProfileViewControllerTheme.logoutButtonHeight),
            logoutButton.widthAnchor.constraint(equalToConstant: ProfileViewControllerTheme.logoutButtonWidth),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ProfileViewControllerTheme.commonTrailingConstraint),
            logoutButton.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor)
        ])
    }
    
    // MARK: - Action methods
    @objc private func didTapLogoutButton() {
        // TODO: - Добавить логику при нажатии на кнопку
    }
}
