//
//  ViewController.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let feedCellId = "feedCellId"
    let saveCellId = "saveCellId"
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.delegate = self
        return mb
    }()

    private func setupMenuBar() {
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(44)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingId)

        collectionView?.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        collectionView?.isPagingEnabled = true
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: collection view delegate and datasource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let identifier: String
//        if indexPath.item == 1 {
//            identifier = trendingId
//        } else if indexPath.item == 2 {
//            identifier = subscriptionCellId
//        } else {
//            identifier = cellId
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = indexPath.item == 1 ? .blue : .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 44 - 20)

    }
    
    // MARK: scrollview delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        let retio = scrollView.frame.width / menuBar.collectionView.frame.width
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / retio / CGFloat(menuBar.imageNames.count)
        
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
    }
//
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        setupCollectionView()
        setupMenuBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeController: MenuBarDelegate {
    func didSelectMenuBarAtIndex(index: Int) {
        scrollToMenuIndex(menuIndex: index)
    }
}
