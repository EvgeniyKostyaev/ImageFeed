//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 06.02.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var datetLabel: UILabel!
}
