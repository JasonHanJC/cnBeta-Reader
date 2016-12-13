//
//  FeedCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var feeds: [Feed]?
    
    let cellId = "cellId"
    
    override func setupViews() {
        
        ApiService.sharedInstance.fetchFeed(withURL: "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.cnbeta.com/rss&num=100", completion: { (feeds) in
            DispatchQueue.main.async {
                self.feeds = feeds
                self.collectionView.reloadData()
            }
        })
        
   
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.register(FeedSubCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedSubCell
        
        cell.feed = feeds?[indexPath.item];
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        let translation = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
//        
//        if translation.y < 0 {
//            cell.alpha = 0
//            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 300, 0)
//            cell.layer.transform = rotationTransform
//            UIView.animate(withDuration: 0.6, animations: {
//                cell.alpha = 1
//                cell.layer.transform = CATransform3DIdentity
//            })
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let size = CGSize(width: 281, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: (feeds?[indexPath.item].contentSnippet!)!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
        
        return CGSize(width: frame.width,height: estimatedFrame.height + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
