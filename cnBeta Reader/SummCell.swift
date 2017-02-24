//
//  SummCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 2/22/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class SummCell: TextCell {
    
    override var paragraph: Paragraph? {
        didSet {
            textLabel.textColor = Constants.DETAIL_TEXT_SUMM_COLOR
        }
    }
    
    let blockView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.All_ICONS_COLOR
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(blockView)
        
        addConstraintsWithFormat("H:|[v0(20)]", views: blockView)
        addConstraintsWithFormat("V:|-36-[v0(20)]", views: blockView)
    }
}
