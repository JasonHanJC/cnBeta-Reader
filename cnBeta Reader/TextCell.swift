//
//  WebCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/16/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import Kingfisher

class TextCell: BaseCell {
    
    var paragraph: Paragraph? {
        didSet {
            if let p = paragraph {
                if let text = p.paragraphString {
                    let attrString = NSAttributedString(string: text, attributes: Constants.DETAIL_NORMAL_STYLE)
                    textLabel.attributedText = attrString
                }
                
                if p.alignment == .alignmentLeft {
                    textLabel.textAlignment = .left
                } else if p.alignment == .alignmentCenter {
                    textLabel.textAlignment = .center
                } else {
                    textLabel.textAlignment = .right
                }
                
                textLabel.textColor = Constants.DETAIL_TEXT_NORMAL_COLOR
            }
        }
    }
    
    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font =  Constants.CONTENT_FONT_DETAIL_NORMAL;
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(textLabel)

        addConstraintsWithFormat("H:|-24-[v0]-24-|", views: textLabel)
        addConstraintsWithFormat("V:|-36-[v0]", views: textLabel)
    }
    
}
