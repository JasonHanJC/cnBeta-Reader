//
//  ImagePresentViewController.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 2/1/18.
//  Copyright © 2018 JasonH. All rights reserved.
//

import UIKit
import Kingfisher

typealias ImageInfo = (imageContent : [Paragraph], index : Int)

class ImagePresentViewController: UIViewController {

    // MARK: - private properties
    fileprivate let imagesInfo: ImageInfo
    fileprivate let cellId = "imageCell"
    static private let pageControlImageNumber = 7
    
    // lazy load views
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    
        let collectionView = UICollectionView(frame: view.frame , collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // add gesture
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        collectionView.addGestureRecognizer(doubleTap)
        
        return collectionView
    }()
    
    lazy var pageControl: CNPageControlBaguette = {
        let pageControl = CNPageControlBaguette()
        pageControl.radius = 4;
        pageControl.tintColor = .lightGray
        pageControl.currentPageTintColor = Constants.All_ICONS_COLOR
        pageControl.hideForSinglePage = true;
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var imageIndexView: ImageIndexView = {
        let view = ImageIndexView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - private function
    @objc fileprivate func doubleTapAction() {
        // zoom the image
        let currentImageCell = self.collectionView.visibleCells[0] as! ImageCell
        guard currentImageCell.imageView.image != nil else {
            return
        }
        
        if currentImageCell.imageScrollView.zoomScale > 1 {
            UIView.animate(withDuration: 0.2, animations: {
                currentImageCell.imageScrollView.zoomScale = 1
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                currentImageCell.imageScrollView.zoomScale = 2
            })
        }
        
    }
    
    fileprivate func configCollectionView() {
        
        view.addSubview(collectionView)
        
        // layout collection view
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
        
        // register cell
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.layoutIfNeeded()
        
        // scroll to selected image
        let indexPath = IndexPath(item: imagesInfo.index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    fileprivate func configNavigationBar() {
        
        let myLogoView = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = myLogoView
        
        let backButton = UIBarButtonItem(image: UIImage(named: "nav_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNavBack))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    fileprivate func configNumberDisplay() {
        if (imagesInfo.imageContent.count >  ImagePresentViewController.pageControlImageNumber) {
            view.addSubview(imageIndexView)
            
            if #available(iOS 11.0, *) {
                imageIndexView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
                imageIndexView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
                imageIndexView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
                imageIndexView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            } else {
                imageIndexView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
                imageIndexView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                imageIndexView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                imageIndexView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
            
            imageIndexView.sumLabel.text = "\(imagesInfo.imageContent.count)"
            imageIndexView.indexLabel.text = "\(imagesInfo.index + 1)"
        } else {
            view.addSubview(pageControl)
            
            if #available(iOS 11.0, *) {
                pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
                pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
                pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
                pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
            } else {
                pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
                pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
            
            pageControl.numberOfPages = imagesInfo.imageContent.count
            pageControl.progress = Double(imagesInfo.index)
        }
    }
    
    @objc private func handleNavBack(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Lifecycle
    
    init(with imagesInfo: ImageInfo) {
        self.imagesInfo = imagesInfo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        configNavigationBar()
        configCollectionView()
        configNumberDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension ImagePresentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesInfo.imageContent.count
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        
        let imageString = imagesInfo.imageContent[indexPath.item].paragraphString
        let resource = ImageResource(downloadURL: URL(string: imageString!)!, cacheKey: imageString)
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: resource, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil) { (image, error, cacheType, url) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! ImageCell).imageScrollView.zoomScale = 1
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / scrollView.frame.size.width
        if (imagesInfo.imageContent.count > ImagePresentViewController.pageControlImageNumber) {
            imageIndexView.indexLabel.text = "\(Int(index) + 1)"
        } else {
            pageControl.set(progress: Int(index), animated: true)
        }
    }
}
