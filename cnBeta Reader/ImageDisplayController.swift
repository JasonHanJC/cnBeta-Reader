//
//  ImageDisplayController.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 1/13/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class ImageDisplayController: NSObject {
    
    let cellId = "cellId"
    
    let imageUrls: [String] = []
    
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .red
        return pageControl
    }()
    
    func show() {
        
    }
}
