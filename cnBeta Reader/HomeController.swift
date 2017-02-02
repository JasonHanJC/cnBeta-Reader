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
        
        //// Color Declarations
        let fillColor = UIColor(red: 0.538, green: 0.538, blue: 0.538, alpha: 1.000)
        
        //// Page-1
        //// Path-2 Drawing
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -34.13, y: -64))
        path.addLine(to: CGPoint(x: -47.23, y: -41.44))
        path.addLine(to: CGPoint(x: -40.18, y: -29.22))
        path.addCurve(to: CGPoint(x: -42.4, y: -25.45), controlPoint1: CGPoint(x: -40.18, y: -29.22), controlPoint2: CGPoint(x: -41.66, y: -27.41))
        path.addCurve(to: CGPoint(x: -43.13, y: -21.36), controlPoint1: CGPoint(x: -43.14, y: -23.49), controlPoint2: CGPoint(x: -43.13, y: -21.36))
        path.addCurve(to: CGPoint(x: -51.98, y: -14.12), controlPoint1: CGPoint(x: -43.13, y: -21.36), controlPoint2: CGPoint(x: -48.9, y: -19.32))
        path.addCurve(to: CGPoint(x: -54.76, y: -1.7), controlPoint1: CGPoint(x: -55.06, y: -8.92), controlPoint2: CGPoint(x: -54.76, y: -1.7))
        path.addCurve(to: CGPoint(x: -65.99, y: 39.1), controlPoint1: CGPoint(x: -54.76, y: -1.7), controlPoint2: CGPoint(x: -65.78, y: 34.77))
        path.addCurve(to: CGPoint(x: -62.77, y: 47.18), controlPoint1: CGPoint(x: -66.2, y: 43.44), controlPoint2: CGPoint(x: -63.8, y: 45.86))
        path.addCurve(to: CGPoint(x: -55.38, y: 53.95), controlPoint1: CGPoint(x: -61.73, y: 48.5), controlPoint2: CGPoint(x: -58.27, y: 52.36))
        path.addCurve(to: CGPoint(x: -32.93, y: 61.43), controlPoint1: CGPoint(x: -46.53, y: 58.82), controlPoint2: CGPoint(x: -39.31, y: 60.14))
        path.addCurve(to: CGPoint(x: -1.3, y: 64.79), controlPoint1: CGPoint(x: -26.55, y: 62.71), controlPoint2: CGPoint(x: -8.91, y: 64.67))
        path.addCurve(to: CGPoint(x: 44.57, y: 57.95), controlPoint1: CGPoint(x: 9.01, y: 64.96), controlPoint2: CGPoint(x: 31.03, y: 62.39))
        path.addCurve(to: CGPoint(x: 59.49, y: 50.1), controlPoint1: CGPoint(x: 50.01, y: 56.17), controlPoint2: CGPoint(x: 55.87, y: 53.08))
        path.addCurve(to: CGPoint(x: 63.64, y: 45.5), controlPoint1: CGPoint(x: 60.84, y: 48.99), controlPoint2: CGPoint(x: 61.52, y: 48.42))
        path.addCurve(to: CGPoint(x: 64.9, y: 39.44), controlPoint1: CGPoint(x: 64.53, y: 44.27), controlPoint2: CGPoint(x: 65.27, y: 42.62))
        path.addCurve(to: CGPoint(x: 53.7, y: -1.6), controlPoint1: CGPoint(x: 64.53, y: 36.25), controlPoint2: CGPoint(x: 53.7, y: -1.6))
        path.addCurve(to: CGPoint(x: 52.7, y: -10.04), controlPoint1: CGPoint(x: 53.7, y: -1.6), controlPoint2: CGPoint(x: 54.57, y: -5.55))
        path.addCurve(to: CGPoint(x: 46.56, y: -18.73), controlPoint1: CGPoint(x: 50.83, y: -14.53), controlPoint2: CGPoint(x: 46.56, y: -18.73))
        path.addLine(to: CGPoint(x: 34.14, y: -39.87))
        path.addLine(to: CGPoint(x: 7.87, y: -39.94))
        path.addLine(to: CGPoint(x: -5.18, y: -17.21))
        path.addLine(to: CGPoint(x: 7.87, y: 5.43))
        path.addLine(to: CGPoint(x: 34.14, y: 5.43))
        path.addLine(to: CGPoint(x: 45.56, y: -14.12))
        path.addCurve(to: CGPoint(x: 48.84, y: -7.95), controlPoint1: CGPoint(x: 45.56, y: -14.12), controlPoint2: CGPoint(x: 48.16, y: -11.69))
        path.addCurve(to: CGPoint(x: 48.13, y: -0.06), controlPoint1: CGPoint(x: 49.52, y: -4.21), controlPoint2: CGPoint(x: 48.85, y: -1.92))
        path.addCurve(to: CGPoint(x: 39.53, y: 5.87), controlPoint1: CGPoint(x: 47.41, y: 1.8), controlPoint2: CGPoint(x: 45.66, y: 3.36))
        path.addCurve(to: CGPoint(x: 27.48, y: 9.81), controlPoint1: CGPoint(x: 33.4, y: 8.38), controlPoint2: CGPoint(x: 33.85, y: 8.39))
        path.addCurve(to: CGPoint(x: 4.49, y: 12.51), controlPoint1: CGPoint(x: 22.24, y: 10.97), controlPoint2: CGPoint(x: 4.49, y: 12.51))
        path.addLine(to: CGPoint(x: -6.15, y: 30.64))
        path.addLine(to: CGPoint(x: -32, y: 30.92))
        path.addLine(to: CGPoint(x: -31.11, y: 28.98))
        path.addLine(to: CGPoint(x: -7.44, y: 28.68))
        path.addLine(to: CGPoint(x: 5.34, y: 6.85))
        path.addLine(to: CGPoint(x: -7.88, y: -16.15))
        path.addLine(to: CGPoint(x: -34.13, y: -16.15))
        path.addLine(to: CGPoint(x: -46.87, y: 5.87))
        path.addLine(to: CGPoint(x: -35.1, y: 27.14))
        path.addLine(to: CGPoint(x: -36.2, y: 29.4))
        path.addLine(to: CGPoint(x: -49.25, y: 5.87))
        path.addLine(to: CGPoint(x: -47.08, y: 2.11))
        path.addCurve(to: CGPoint(x: -48.95, y: 0.4), controlPoint1: CGPoint(x: -47.08, y: 2.11), controlPoint2: CGPoint(x: -47.93, y: 1.48))
        path.addCurve(to: CGPoint(x: -48.1, y: -11.76), controlPoint1: CGPoint(x: -50.93, y: -1.7), controlPoint2: CGPoint(x: -49.96, y: -8.24))
        path.addCurve(to: CGPoint(x: -40.18, y: -18.2), controlPoint1: CGPoint(x: -46.24, y: -15.28), controlPoint2: CGPoint(x: -41.59, y: -17.41))
        path.addCurve(to: CGPoint(x: -38.04, y: -20.86), controlPoint1: CGPoint(x: -38.76, y: -18.99), controlPoint2: CGPoint(x: -38.29, y: -18.96))
        path.addCurve(to: CGPoint(x: -37.48, y: -24.47), controlPoint1: CGPoint(x: -37.79, y: -22.76), controlPoint2: CGPoint(x: -37.48, y: -24.47))
        path.addLine(to: CGPoint(x: -34.13, y: -18.73))
        path.addLine(to: CGPoint(x: -7.44, y: -18.73))
        path.addLine(to: CGPoint(x: 5.34, y: -41.1))
        path.addLine(to: CGPoint(x: -7.88, y: -63.91))
        path.addLine(to: CGPoint(x: -34.13, y: -64))
        path.close()
        path.miterLimit = 4;
        
        path.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        path.fill()
        return path
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
