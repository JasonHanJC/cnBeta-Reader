//
//  FeedCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

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
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        collectionView.register(FeedSubCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return feeds?.count ?? 0
        return 40;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedSubCell
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
        return CGSize(width: frame.width,height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
