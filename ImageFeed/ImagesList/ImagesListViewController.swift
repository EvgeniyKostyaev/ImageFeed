//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 04.02.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var photos: [PhotoModel] = []
    private let currentDate = Date()
    
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                
                self.updateTableViewAnimated()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            guard let photoImageURL = URL(string: photos[indexPath.row].largeImageURL) else { return }
            viewController.photoImageURL = photoImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func updateTableViewAnimated() {
        let oldRowsCount = photos.count
        let newRowsCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldRowsCount != newRowsCount {
            let insertRows = (oldRowsCount..<newRowsCount).map {
                IndexPath(row: $0, section: 0)
            }
            tableView.performBatchUpdates {
                self.tableView.insertRows(at: insertRows, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDataSource methods
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - ConfigCell methods
extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photoImageURL = URL(string: photos[indexPath.row].thumbImageURL) else {
            return
        }
        
        cell.delegate = self
        
        cell.photoImageView.kf.indicatorType = .activity
        cell.photoImageView.kf.setImage(
            with: photoImageURL,
            placeholder: UIImage(named: "photo_placeholder_icon")) { result in
                switch (result) {
                case .success(let imageResult):
                    cell.photoImageView.image = imageResult.image
                case .failure(let error): print("Error downloading image: \(error)")
                }
            }
        
        if let createdDate = photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdDate)
        } else {
            cell.dateLabel.text = "-"
        }
        
        cell.setIsLiked(photos[indexPath.row].isLiked)
    }
}

// MARK: - UITableViewDelegate methods
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == imagesListService.photos.count) {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let updatedPhoto):
                self.photos[indexPath.row] = updatedPhoto
                cell.setIsLiked(updatedPhoto.isLiked)
            case .failure(let error):
                print(error)
            }
        }
    }
}

