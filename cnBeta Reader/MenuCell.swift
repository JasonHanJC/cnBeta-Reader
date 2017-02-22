//
//  MenuCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
    var filledImage = UIImage()
    var hollowImage = UIImage()
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.image = isHighlighted ? filledImage : hollowImage
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.image = isSelected ? filledImage : hollowImage
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat("H:[v0(34)]", views: imageView)
        addConstraintsWithFormat("V:[v0(34)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
}
