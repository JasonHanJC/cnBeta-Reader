//
//  SettingLauncher.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/28/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

protocol SettingLauncherDelegate: class {
    func didSelectSetting(_ setting: Setting)
    
    func didCancelByUser()
}

class SettingLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    var settings: [Setting]!
    
    //weak var superController: HomeController?
    
    weak var delegate: SettingLauncherDelegate?
    
    func showSettingLauncher() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.alpha = 0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            let collectionViewHeight: CGFloat = cellHeight * CGFloat(settings.count);
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: collectionViewHeight)
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height - self.collectionView.frame.height, width: window.frame.width, height: 300)
            }, completion: nil)
        }
    }
    
    @objc fileprivate func handleDismiss(_ setting: Setting) {
        
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                self.blackView.alpha = 0
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 300)
            }, completion: { _ in
                self.blackView.removeFromSuperview()
                self.collectionView.removeFromSuperview()
                if setting.name != .cancel {
                    //self.superController?.showControllerForSetting(setting: setting)
                    if let didSeletctSetting = self.delegate?.didSelectSetting(setting) {
                        didSeletctSetting
                    }
                } else {
                    if let didCancelByUser = self.delegate?.didCancelByUser() {
                        didCancelByUser
                    }
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        cell.setting = settings[indexPath.item]
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.item]
        handleDismiss(setting)
    }
    
    
    
    override init() {
        super.init()
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        
        settings = [Setting(name: .settings, imageName: "Setting"), Setting(name: .sendFeedback, imageName: "FeedBack"), Setting(name: .cancel, imageName: "Cancel")]
    }
    
    deinit {
        print("setting launcher deinit")
    }
}
