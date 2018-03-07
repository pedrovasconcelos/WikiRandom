//
//  ArticlesViewController.swift
//  WikiRandom
//
//  Created by Pedro Vasconcelos on 06/03/2018.
//  Copyright © 2018 Pedro Vasconcelos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class ArticlesViewController: UIViewController {

    // MARK: - Properties
    
    // A request for a new batch of random articles will be triggered when the number of articles left unseen is equal to this value
    static let remainingArticlesBeforeNewRequest = 2
    
    // Number of articles to fetch each time. Max = 20 (Limited by Wikipedia API)
    static let articlesRequestBatchSize = 10
    
    // Articles data source (Obs: Variable is deprecated!)
    let articles = Variable<[Article]>([])
    
    // Service used to interact with Wikipedia API
    let wikipediaService = WikipediaService()
    
    // RxSwift dispose bag for clean up
    let disposeBag = DisposeBag()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBOutlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavBar()
        setupNextButton()
        
        bindUI()
        
        fetchArticles(limit: ArticlesViewController.articlesRequestBatchSize)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Wait until collection view is laid out. Set item size equal to collection view size.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.itemSize = collectionView.bounds.size
            collectionView.collectionViewLayout = layout
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupCollectionView() {
        let articleCollectionViewCellNib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        collectionView.register(articleCollectionViewCellNib, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
    }
    
    private func setupNavBar() {
        // Make navbar white and remove bottom border
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupNextButton() {
        let wikipediaLogo = UIImage(named: "Wikipedia Round")?.withRenderingMode(.alwaysTemplate)
        nextButton.setImage(wikipediaLogo, for: .normal)
        nextButton.tintColor = #colorLiteral(red: 0.9460263325, green: 0.08692867242, blue: 0.1047819703, alpha: 1)
    }
    
    private func bindUI() {
        // Populate UICollectionView
        articles.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "ArticleCollectionViewCell", cellType: ArticleCollectionViewCell.self)) {index, article, cell in
            
            cell.configureFor(title: article.title, body: article.body, lastRevisionDate: article.lastRevisionAt, imageUrlString: article.imageUrlString, openButtonHandler: {
                guard let articleUrl = URL(string: article.articleUrlString) else { return }
                
                let safariViewController = SFSafariViewController(url: articleUrl)
                self.present(safariViewController, animated: true, completion: nil)
            })
        }.disposed(by: disposeBag)
        
        // Fetch more articles when number of remaining articles to display reaches below threshold
        collectionView.rx.willDisplayCell.bind { controlEvent in
            let indexRow = controlEvent.at.row
            if self.articles.value.count - 1 - indexRow <= ArticlesViewController.remainingArticlesBeforeNewRequest {
                self.fetchArticles(limit: ArticlesViewController.articlesRequestBatchSize)
            }
        }.disposed(by: disposeBag)
        
        // Rotate button when collectionView scrolls
        collectionView.rx.didScroll.bind {
            let maxWidth = self.collectionView.bounds.width
            let relevantOffset = self.collectionView.contentOffset.x.truncatingRemainder(dividingBy: maxWidth)
            let rotationAngle = (relevantOffset * .pi * 2) / maxWidth
            self.nextButton.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        }.disposed(by: disposeBag)
        
        // Next article button
        nextButton.rx.tap.bind {
            guard let currentIndexPath = self.collectionView.indexPathsForVisibleItems.first,
                currentIndexPath.row < self.articles.value.count - 1
                else { return }
            
            let nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: 0)
            self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func fetchArticles(limit: Int) {
        wikipediaService.getRandomArticles(limit: limit, completionHandler: { result in
            switch result {
            case let .success(newArticles):
                self.articles.value.append(contentsOf: newArticles)

            default:
                // Fail silently
                break
            }
        })
    }
}
