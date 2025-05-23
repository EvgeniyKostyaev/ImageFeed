//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 06.02.2025.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - @IBOutlet properties
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Public Properties
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
        dateLabel.text = nil
        likeButton.setImage(nil, for: .normal)
    }
    
    // MARK: - IB Actions
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Public Methods
    func setIsLiked(_ isLiked: Bool) {
        let imageLike = isLiked ? UIImage(resource: .activeIcon) : UIImage(resource: .inactiveIcon)
        likeButton.setImage(imageLike, for: UIControl.State.normal)
    }
    
}
