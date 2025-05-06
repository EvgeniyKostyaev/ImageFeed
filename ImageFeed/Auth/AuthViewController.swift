//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 19.03.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak private var loginButton: UIButton!
    
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                return
            }
            
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
    
    private func handleNetworkError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Ок",
            style: .default,
            handler: nil
        )
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - WebViewViewControllerDelegate methods
extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch(result) {
            case .success(let data):
                self.oAuth2TokenStorage.token = data.accessToken
                self.delegate?.didAuthenticate(self)
            case .failure:
                self.handleNetworkError()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {

    }
}
