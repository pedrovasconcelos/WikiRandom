//
//  ArticleCollectionViewCell.swift
//  WikiRandom
//
//  Created by Pedro Vasconcelos on 06/03/2018.
//  Copyright © 2018 Pedro Vasconcelos. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift
import RxCocoa

class ArticleCollectionViewCell: UICollectionViewCell {

    // MARK: - UICollectionViewCell
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var lastRevisionDateLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    // MARK: - UICollectionViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowRadius = 5
        
        // Remove top/bottom insets
        bodyTextView.textContainer.lineFragmentPadding = 0
        bodyTextView.textContainerInset = .zero
        
        // Remove side padding
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.textContainerInset = .zero
        
        self.articleImageView.isHidden = true
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        self.articleImageView.isHidden = true
    }
}

// MARK: - Public

extension ArticleCollectionViewCell {
    func configureFor(title: String, body: String, lastRevisionDate: Date, imageUrlString: String? = nil, openButtonHandler: @escaping ()->()) {
        titleTextView.text = title
        bodyTextView.text = body
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        lastRevisionDateLabel.text = "Updated \(dateFormatter.string(from: lastRevisionDate))"
        
        if let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) {
            articleImageView.af_setImage(withURL: imageUrl) { response in
                if response.error == nil {
                    self.articleImageView.isHidden = false
                }
            }
        }
        
        // Bind open button
        openButton.rx.tap.bind {
            openButtonHandler()
        }.disposed(by: disposeBag)
    }
}
