//
//  WebCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/16/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

class WebCell: BaseCell {
    
    var paragraph: Paragraph? {
        didSet {
            
            if let p = paragraph {
                if p.type == .text {
                    textLabel.text = "        \(p.paragraphString!)"
                    imageView.isHidden = true
                    textLabel.isHidden = false
                } else if p.type == .image {
                    imageView.loadImageWithURLString(urlString: p.paragraphString!)
                    imageView.isHidden = false
                    textLabel.isHidden = true
                } else {
                    
                }
            }
            
        }
    }
    
    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .lightGray
        
        addSubview(textLabel)
        addSubview(imageView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: imageView)
        addConstraintsWithFormat("V:|[v0]|", views: imageView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textLabel)
        addConstraintsWithFormat("V:|[v0]|", views: textLabel)
    }
    
}
