//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Evgeniy Kostyaev on 04.02.2025.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(insertRows: [IndexPath])
    
    func updateLikeForCell(at indexPath: IndexPath, isLiked: Bool)
    
    func showProgressHUD()
    
    func hideProgressHUD()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewIsReady()
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
            
            let photoImageURL = presenter?.getLargeImageURL(for: indexPath)
            viewController.photoImageURL = photoImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Public Methods
    func updateTableViewAnimated(insertRows: [IndexPath]) {
        tableView.performBatchUpdates {
            self.tableView.insertRows(at: insertRows, with: .automatic)
        } completion: { _ in }
    }
    
    func updateLikeForCell(at indexPath: IndexPath, isLiked: Bool) {
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
            cell.setIsLiked(isLiked)
        }
    }
    
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func hideProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: - UITableViewDataSource methods
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPhotos().count ?? Int()
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
        guard let photos = presenter?.getPhotos(), let photoImageURL = URL(string: photos[indexPath.row].thumbImageURL) else {
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
        guard let photos = presenter?.getPhotos() else { return 0 }
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let photos = presenter?.getPhotos() else { return }
        if (indexPath.row + 1 == photos.count) {
            presenter?.onFetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.onChangeLike(for: indexPath)
    }
}

