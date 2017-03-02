//
//  ImageIndexView.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 3/1/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class ImageIndexView: UIView {
    
    let sumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "xxx"
        return label
    }()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "/  xxx"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sumLabel)
        addSubview(indexLabel)
        
        addConstraintsWithFormat("H:|[v0]", views: indexLabel)
        addConstraintsWithFormat("H:|-20-[v0]", views: sumLabel)
        addConstraintsWithFormat("V:|[v0]|", views: indexLabel)
        addConstraintsWithFormat("V:|[v0]|", views: sumLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
