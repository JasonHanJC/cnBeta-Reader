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
    
    lazy var launchView: UIView = {
        let launchView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 2, height: self.view.frame.height * 2))
        launchView.backgroundColor = UIColor.rgb(194, green: 31, blue: 31, alpha: 1.0)
        let layer = CAShapeLayer()
        layer.path = self.setBezierPath().cgPath
        layer.anchorPoint = CGPoint(x: 1, y: 1)
        layer.position = launchView.center
        layer.fillColor = UIColor.white.cgColor
        launchView.layer.addSublayer(layer)
        launchView.center = self.view.center
        return launchView
    }()
    
    func setBezierPath() -> UIBezierPath {
        let strokeColor = UIColor(red: 0.521, green: 0.521, blue: 0.521, alpha: 1.000)
        
        let path2Path = UIBezierPath()
        path2Path.move(to: CGPoint(x: -34.17, y: -64.4))
        path2Path.addLine(to: CGPoint(x: -47.27, y: -41.84))
        path2Path.addLine(to: CGPoint(x: -40.22, y: -29.62))
        path2Path.addCurve(to: CGPoint(x: -42.44, y: -25.85), controlPoint1: CGPoint(x: -40.22, y: -29.62), controlPoint2: CGPoint(x: -41.7, y: -27.81))
        path2Path.addCurve(to: CGPoint(x: -43.17, y: -21.76), controlPoint1: CGPoint(x: -43.18, y: -23.88), controlPoint2: CGPoint(x: -43.17, y: -21.76))
        path2Path.addCurve(to: CGPoint(x: -52.02, y: -14.52), controlPoint1: CGPoint(x: -43.17, y: -21.76), controlPoint2: CGPoint(x: -48.94, y: -19.72))
        path2Path.addCurve(to: CGPoint(x: -54.81, y: -2.1), controlPoint1: CGPoint(x: -55.1, y: -9.32), controlPoint2: CGPoint(x: -54.81, y: -2.1))
        path2Path.addCurve(to: CGPoint(x: -66.03, y: 38.71), controlPoint1: CGPoint(x: -54.81, y: -2.1), controlPoint2: CGPoint(x: -65.82, y: 34.37))
        path2Path.addCurve(to: CGPoint(x: -62.81, y: 46.79), controlPoint1: CGPoint(x: -66.24, y: 43.04), controlPoint2: CGPoint(x: -63.85, y: 45.47))
        path2Path.addCurve(to: CGPoint(x: -55.42, y: 53.55), controlPoint1: CGPoint(x: -61.77, y: 48.11), controlPoint2: CGPoint(x: -58.31, y: 51.96))
        path2Path.addCurve(to: CGPoint(x: -32.97, y: 61.03), controlPoint1: CGPoint(x: -46.57, y: 58.42), controlPoint2: CGPoint(x: -39.35, y: 59.74))
        path2Path.addCurve(to: CGPoint(x: -1.34, y: 64.4), controlPoint1: CGPoint(x: -26.59, y: 62.32), controlPoint2: CGPoint(x: -8.95, y: 64.27))
        path2Path.addCurve(to: CGPoint(x: 44.53, y: 57.55), controlPoint1: CGPoint(x: 8.97, y: 64.56), controlPoint2: CGPoint(x: 30.99, y: 62))
        path2Path.addCurve(to: CGPoint(x: 59.45, y: 49.7), controlPoint1: CGPoint(x: 49.97, y: 55.77), controlPoint2: CGPoint(x: 55.83, y: 52.68))
        path2Path.addCurve(to: CGPoint(x: 63.6, y: 45.1), controlPoint1: CGPoint(x: 60.8, y: 48.59), controlPoint2: CGPoint(x: 61.68, y: 48.06))
        path2Path.addCurve(to: CGPoint(x: 64.9, y: 42.32), controlPoint1: CGPoint(x: 64.42, y: 43.83), controlPoint2: CGPoint(x: 64.6, y: 43.29))
        path2Path.addCurve(to: CGPoint(x: 64.86, y: 39.04), controlPoint1: CGPoint(x: 65.21, y: 41.34), controlPoint2: CGPoint(x: 65.13, y: 40.63))
        path2Path.addCurve(to: CGPoint(x: 53.66, y: -1.99), controlPoint1: CGPoint(x: 64.59, y: 37.46), controlPoint2: CGPoint(x: 53.66, y: -1.99))
        path2Path.addCurve(to: CGPoint(x: 52.66, y: -10.43), controlPoint1: CGPoint(x: 53.66, y: -1.99), controlPoint2: CGPoint(x: 54.53, y: -5.95))
        path2Path.addCurve(to: CGPoint(x: 46.52, y: -19.13), controlPoint1: CGPoint(x: 50.79, y: -14.92), controlPoint2: CGPoint(x: 46.52, y: -19.13))
        path2Path.addLine(to: CGPoint(x: 34.1, y: -40.27))
        path2Path.addLine(to: CGPoint(x: 7.83, y: -40.34))
        path2Path.addLine(to: CGPoint(x: -5.22, y: -17.61))
        path2Path.addLine(to: CGPoint(x: 7.83, y: 5.03))
        path2Path.addLine(to: CGPoint(x: 34.1, y: 5.03))
        path2Path.addLine(to: CGPoint(x: 45.52, y: -14.52))
        path2Path.addCurve(to: CGPoint(x: 48.8, y: -8.35), controlPoint1: CGPoint(x: 45.52, y: -14.52), controlPoint2: CGPoint(x: 48.12, y: -12.09))
        path2Path.addCurve(to: CGPoint(x: 48.09, y: -0.46), controlPoint1: CGPoint(x: 49.48, y: -4.61), controlPoint2: CGPoint(x: 48.81, y: -2.32))
        path2Path.addCurve(to: CGPoint(x: 39.49, y: 5.48), controlPoint1: CGPoint(x: 47.37, y: 1.4), controlPoint2: CGPoint(x: 45.61, y: 2.97))
        path2Path.addCurve(to: CGPoint(x: 27.44, y: 9.41), controlPoint1: CGPoint(x: 33.36, y: 7.98), controlPoint2: CGPoint(x: 33.81, y: 7.99))
        path2Path.addCurve(to: CGPoint(x: 2.01, y: 12.03), controlPoint1: CGPoint(x: 21.07, y: 10.83), controlPoint2: CGPoint(x: 2.01, y: 12.03))
        path2Path.addLine(to: CGPoint(x: 5.3, y: 6.45))
        path2Path.addLine(to: CGPoint(x: -7.92, y: -16.54))
        path2Path.addLine(to: CGPoint(x: -34.17, y: -16.54))
        path2Path.addLine(to: CGPoint(x: -45.26, y: 2.82))
        path2Path.addCurve(to: CGPoint(x: -48.99, y: 0), controlPoint1: CGPoint(x: -45.26, y: 2.82), controlPoint2: CGPoint(x: -47.01, y: 2.11))
        path2Path.addCurve(to: CGPoint(x: -48.14, y: -12.16), controlPoint1: CGPoint(x: -50.97, y: -2.1), controlPoint2: CGPoint(x: -50, y: -8.64))
        path2Path.addCurve(to: CGPoint(x: -40.22, y: -18.6), controlPoint1: CGPoint(x: -46.28, y: -15.68), controlPoint2: CGPoint(x: -41.63, y: -17.81))
        path2Path.addCurve(to: CGPoint(x: -38.08, y: -21.25), controlPoint1: CGPoint(x: -38.8, y: -19.38), controlPoint2: CGPoint(x: -38.33, y: -19.35))
        path2Path.addCurve(to: CGPoint(x: -37.52, y: -24.87), controlPoint1: CGPoint(x: -37.83, y: -23.15), controlPoint2: CGPoint(x: -37.52, y: -24.87))
        path2Path.addLine(to: CGPoint(x: -34.17, y: -19.13))
        path2Path.addLine(to: CGPoint(x: -7.48, y: -19.13))
        path2Path.addLine(to: CGPoint(x: 5.3, y: -41.5))
        path2Path.addLine(to: CGPoint(x: -7.92, y: -64.31))
        path2Path.addLine(to: CGPoint(x: -34.17, y: -64.4))
        path2Path.close()
        path2Path.miterLimit = 4;
        
        path2Path.usesEvenOddFillRule = true;
        
        strokeColor.setStroke()
        path2Path.lineWidth = 1
        path2Path.stroke()        
        return path2Path
    }
    
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
        UIView.animate(withDuration: 0.2, animations: {
            self.launchView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                self.launchView.transform = CGAffineTransform(scaleX: 50, y: 50)
                self.launchView.alpha = 0.0
            }, completion: { (finished) in
                self.launchView.removeFromSuperview()
            })
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
