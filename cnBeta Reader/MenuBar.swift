//
//  MenuBar.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

protocol MenuBarDelegate: class {
    func didSelectMenuBarAtIndex(_ index: Int)
}

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
            //UIColor.rgb(230, green: 32, blue: 32, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let cellId = "cellId"
    let filledImageNames = ["feed_filled", "Saved"]
    let hollowImageNames = ["feed_hollow", "Save"]
    let sectionName = ["Feed", "Saved"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
            //UIColor.rgb(230, green: 32, blue: 32, alpha: 1)

        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addSubview(topLine)
        
        addConstraintsWithFormat("H:|[v0]|", views: topLine)
        addConstraintsWithFormat("V:|[v0(0.5)]", views: topLine)
        
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
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
        horizontalBar.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1/CGFloat(filledImageNames.count)).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    
    // MARK: Collection view delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filledImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        // the first one is selected at the beginning
        if (indexPath.item == 0) {
            cell.imageView.image = UIImage(named: filledImageNames[indexPath.item])!
        } else {
            cell.imageView.image = UIImage(named: hollowImageNames[indexPath.item])!
        }
        
        cell.filledImage = UIImage(named: filledImageNames[indexPath.item])!
        cell.hollowImage = UIImage(named: hollowImageNames[indexPath.item])!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(filledImageNames.count), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMenuBarAtIndex(indexPath.item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
