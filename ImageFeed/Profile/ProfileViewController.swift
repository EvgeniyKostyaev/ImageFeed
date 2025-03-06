//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 17.02.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var userPhotoImageView: UIImageView?
    
    private var nameLabel: UILabel?
    
    private var nicknameLabel: UILabel?
    
    private var statusLabel: UILabel?
    
    private var logoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserPhotoImageView()
        
        setupNameLabel()
        
        setupNicknameLabel()
        
        setupStatusLabel()
        
        setupLogoutButton()
    }
    
    // MARK: - Helper methods
    private func setupUserPhotoImageView() {
        let userPhotoImageView = UIImageView(image: UIImage(named: "user_photo_icon"))
        userPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhotoImageView)
        
        userPhotoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userPhotoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        self.userPhotoImageView = userPhotoImageView
    }
    
    private func setupNameLabel() {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        if let userPhotoImageView = userPhotoImageView {
            nameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 8).isActive = true
        }
        
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
        
        self.nameLabel = nameLabel
    }
    
    private func setupNicknameLabel() {
        let nicknameLabel = UILabel()
        nicknameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        nicknameLabel.textColor = UIColor(red: 174.0/255.0, green: 175.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        
        if let nameLabel = nameLabel {
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        }
        
        nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nicknameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
        
        self.nicknameLabel = nicknameLabel
    }
    
    private func setupStatusLabel() {
        let statusLabel = UILabel()
        statusLabel.font = .systemFont(ofSize: 13, weight: .regular)
        statusLabel.textColor = .white
        statusLabel.text = "Hello, world!"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        if let nicknameLabel = nicknameLabel {
            statusLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8).isActive = true
        }
        
        statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
        
        self.statusLabel = statusLabel
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_icon") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton)
        )
        
        logoutButton.tintColor = UIColor(red: 245.0/255.0, green: 107.0/255.0, blue: 108.0/255.0, alpha: 1.0)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        if let userPhotoImageView = userPhotoImageView {
            logoutButton.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor).isActive = true
        }
        
    }
    
    // MARK: - Action methods
    @objc private func didTapLogoutButton() {
        print("onTapLogoutButton")
    }
}
