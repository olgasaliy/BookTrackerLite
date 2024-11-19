//
//  BookListTableViewCell.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 14.11.2024.
//

import UIKit

class BookListTableViewCellViewModel {
    var book: Volume
    private let bookService: BookService
    
    init(book: Volume, bookService: BookService) {
        self.book = book
        self.bookService = bookService
    }
    
    func getInfoForSubtitle() -> String? {
        if let authors = book.authors, !authors.isEmpty {
            let authors = authors.joined(separator: ", ")
            return "By \(authors)"
        } else {
            return book.subtitle
        }
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageLinks = book.imageLinks else {
            completion(UIImage.getDefaultImageForBookCover())
            return
        }
        DispatchQueue.global().async { [weak self] in
            self?.bookService.getImage(from: imageLinks,
                                 preferredSize: .thumbnail) { result in
                self?.handleImageResult(result, completion: completion)
            }
        }
    }
    
    private func handleImageResult(_ result: Result<UIImage, Error>, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.async {
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(UIImage.getDefaultImageForBookCover())
            }
        }
    }
}

class BookListTableViewCell: UITableViewCell {

    @IBOutlet weak var coverBookImage: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: BookListTableViewCellViewModel? {
        didSet {
            configureUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverBookImage.isHidden = true
        activityIndicator.isHidden = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.stopAnimating()
        titleLabel.text = nil
        subtitleLabel.text = nil
        coverBookImage.image = nil
        coverBookImage.isHidden = true
        activityIndicator.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureUI() {
        titleLabel.text = viewModel?.book.title
        subtitleLabel.text = viewModel?.getInfoForSubtitle()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        viewModel?.getImage(completion: { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            self?.coverBookImage.image = image
            self?.coverBookImage.isHidden = false
        })
    }
    
}
