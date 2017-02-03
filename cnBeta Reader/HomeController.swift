//
//  ViewController.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let feedCellId = "feedCellId"
    let saveCellId = "saveCellId"
    
    lazy var launchView: LaunchingView = {
        let launchView = LaunchingView(frame: self.view.bounds)
        return launchView
    }()
    

    lazy var settingLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.delegate = self
        return launcher
    }()
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.delegate = self
        return mb
    }()

    fileprivate func setupMenuBar() {
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(44)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = .white
        collectionView?.register(FeedCollectionView.self, forCellWithReuseIdentifier: feedCellId)
        collectionView?.register(SavedTableView.self, forCellWithReuseIdentifier: saveCellId)

        collectionView?.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK: collection view delegate and datasource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! FeedCollectionView
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: saveCellId, for: indexPath) as! SavedTableView
            cell.delegate = self
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.backgroundColor = indexPath.item == 1 ? UIColor.white : UIColor(white: 0.95, alpha: 1)
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
        let index = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        setupCollectionView()
        setupMenuBar()
        
        view.addSubview(launchView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        perform(#selector(dismissLaunchView), with: nil, afterDelay: 1.3)
    }
    
    func dismissLaunchView() {
        self.launchView.startAnimateWithCompletion {
            print("launch view dismissed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeController: MenuBarDelegate, FeedCollectionViewDelegate, SavedTableViewDelegate, SettingLauncherDelegate {
    
    // MARK: MenuBarDelegate
    func didSelectMenuBarAtIndex(_ index: Int) {
        scrollToMenuIndex(index)
    }
    
    func didSelectSettings() {
        settingLauncher.showSettingLauncher()
    }
    
    // MARK: FeedCollectionViewDelegate
    func feedCollectionViewDidSelectFeed(_ feed: Feed) {

        let layout = UICollectionViewFlowLayout()
        let detailController = DetailController(collectionViewLayout: layout)
        detailController.selectedFeed = feed
        detailController.navigationItem.title = "Detail"
        
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    // MARK: SavedTableViewDelegate
    func savedTableViewDidSelectFeed(_ feed: Feed) {
        
        let layout = UICollectionViewFlowLayout()
        let detailController = DetailController(collectionViewLayout: layout)
        detailController.selectedFeed = feed
        detailController.navigationItem.title = "Detail"
        
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    
    // MARK: SettingLauncherDelegate
    func didSelectSetting(_ setting: Setting) {
        print(setting.name)
    }
    
    func didCancelByUser() {

    }
}
