//
//  MenuCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Feed")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.rgb(91, green: 14, blue: 13, alpha: 1.0)
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(91, green: 14, blue: 13, alpha: 1.0)
        
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13, alpha: 1.0)
            label.textColor = isHighlighted ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13, alpha: 1.0)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13, alpha: 1.0)
            label.textColor = isSelected ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13, alpha: 1.0)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addSubview(label)
        
        addConstraintsWithFormat("H:|-8-[v0(20)]-(>=0)-[v1(35)]-8-|", views: imageView, label)
        addConstraintsWithFormat("V:[v0(20)]", views: imageView)
        addConstraintsWithFormat("V:[v0(28)]", views: label)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
