//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 17.02.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        imageView.frame.size = image?.size ?? CGSize(width: 0,height: 0)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    // MARK: - Action methods
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
