//
//  TitleCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 2/22/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class TitleCell: BaseCell {
    
    var paragraph: Paragraph? {
        didSet {
            if let p = paragraph {
                textLabel.text = p.paragraphString!
                textLabel.textAlignment = .left
            }
        }
    }
    
    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font =  Constants.TITLE_FONT_DETAIL;
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = Constants.TIME_LABEL_FONT_DETAIL
        timeLabel.textColor = Constants.TIME_LABEL_TEXT_COLOR
        timeLabel.numberOfLines = 0
        timeLabel.backgroundColor = .white
        timeLabel.text = "0000-00-00 00:00:00"
        return timeLabel
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(textLabel)
        addSubview(timeLabel)
        

        addConstraintsWithFormat("H:|-24-[v0]-24-|", views: textLabel)
        addConstraintsWithFormat("V:|-30-[v0]-(>=6)-[v1]|", views: textLabel, timeLabel)
        addConstraintsWithFormat("H:|-24-[v0]", views: timeLabel)
    }

}
