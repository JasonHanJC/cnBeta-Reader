//
//  ViewController.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let feedCellId = "feedCellId"
    private let saveCellId = "saveCellId"
    
    private var currentCellIndex = 0
    
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
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .red
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    func setupNavigationBar() {
        
        let myLogoView = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = myLogoView
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = -8
        
        let settingBtn = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(handleSetting))
        settingBtn.tintColor = Constants.All_ICONS_COLOR
        
        navigationItem.rightBarButtonItems = [fixedSpace, settingBtn]
    }
    
    @objc fileprivate func handleSetting() {
        
    }


    fileprivate func setupMenuBar() {
        
        view.addSubview(menuBar)
        
        if #available(iOS 11.0, *) {
            menuBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            menuBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            menuBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        } else {
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            menuBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    fileprivate func setupCollectionView() {
        
        view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        }

        collectionView.backgroundColor = .white
        collectionView.register(FeedCollectionView.self, forCellWithReuseIdentifier: feedCellId)
        collectionView.register(SavedTableView.self, forCellWithReuseIdentifier: saveCellId)
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: false)
    }
    
    // MARK: collection view delegate and datasource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        collectionView.backgroundColor = indexPath.item == 1 ? UIColor.white : UIColor(white: 0.95, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 50)
    }
    
    // MARK: scrollview delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let retio = scrollView.frame.width / menuBar.collectionView.frame.width
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / retio / CGFloat(menuBar.filledImageNames.count)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        currentCellIndex = index
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = true
        view.backgroundColor = .white
        
        setupCollectionView()
        setupMenuBar()
        setupNavigationBar()
        
        view.addSubview(launchView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        perform(#selector(dismissLaunchView), with: nil, afterDelay: 1.3)
    }
    
    @objc func dismissLaunchView() {
        self.launchView.startAnimateWithCompletion {
            print("launch view dismissed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        coordinator.animate(alongsideTransition: nil) { (context) in
            let indexPath = IndexPath(item: self.currentCellIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: [], animated: false)
        }
    }
    
}

extension HomeController: MenuBarDelegate, FeedCollectionViewDelegate, SavedTableViewDelegate, SettingLauncherDelegate {
    
    // MARK: MenuBarDelegate
    func didSelectMenuBarAtIndex(_ index: Int) {
        scrollToMenuIndex(index)
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
