//
//  DetailImageCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 2/22/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class DetailImageCell: BaseCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "image_placeholder")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat("H:|-24-[v0]-24-|", views: imageView)
        addConstraintsWithFormat("V:|-24-[v0]|", views: imageView)
    }
}
