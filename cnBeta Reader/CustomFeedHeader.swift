//
//  CustomFeedHeader.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 3/15/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class CustomFeedHeader: UICollectionReusableView {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.63, green:0.64, blue:0.65, alpha:1.0)
        label.font = Constants.FEED_HEADER_FONT
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeaderViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeaderViews() {
        
        backgroundColor = UIColor(red:0.95, green:0.97, blue:0.98, alpha:1.0)
        
        addSubview(timeLabel)
        
        addConstraintsWithFormat("H:|-18-[v0]", views: timeLabel)
        addConstraintsWithFormat("V:|-10-[v0]-7-|", views: timeLabel)
    }
    
}
