//
//  MenuBar.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

protocol MenuBarDelegate: class {
    func didSelectMenuBarAtIndex(index: Int)
    func didSelectSettings()
}

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 32, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Whitelogo")
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLogoImageTap))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    func handleLogoImageTap(sender: UITapGestureRecognizer) {
        print("tapped")
        delegate?.didSelectSettings()
    }
    
    let cellId = "cellId"
    let imageNames = ["Feed", "Saved"]
    let sectionName = ["Feed", "Saved"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor =  UIColor.rgb(red: 230, green: 32, blue: 32, alpha: 1)

        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addSubview(logoImageView)
        
        addConstraintsWithFormat("H:|[v0(40)]-(>=60)-[v1(150)]|", views: logoImageView, collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:[v0(46)]", views: logoImageView)
        
        addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        setupHorizontalBar()

        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition:[])
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    weak var delegate: MenuBarDelegate?
    
    func setupHorizontalBar() {
        let horizontalBar = UIView()
        horizontalBar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBar)
        
        horizontalBarLeftAnchorConstraint = horizontalBar.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1/CGFloat(imageNames.count)).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    
    // MARK: Collection view delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.label.text = sectionName[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(imageNames.count), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMenuBarAtIndex(index: indexPath.item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
