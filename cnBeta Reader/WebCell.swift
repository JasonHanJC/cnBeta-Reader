//
//  WebCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/16/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import Alamofire

class WebCell: BaseCell {
    
    var paragraph: Paragraph? {
        didSet {
            if let p = paragraph {
                if p.type == .text || p.type == .summary {
                    
                    if let text = p.paragraphString {
                        textLabel.text = text
                    }
                    
                    // set the aligment
                    if p.alignment == .alignmentLeft {
                        textLabel.textAlignment = .left
                    } else if p.alignment == .alignmentCenter {
                        textLabel.textAlignment = .center
                    } else {
                        textLabel.textAlignment = .right
                    }
                    
                    if p.type == .summary {
                        backgroundColor = UIColor(white: 0.95, alpha: 1)
                    } else {
                        backgroundColor = .white
                    }
                    
                    // set style
                    if p.textStyle == .normal {
                        textLabel.font = UIFont.systemFont(ofSize: Constants.CONTENT_FONT_SIZE_DETAIL, weight: 0)
                    } else if p.textStyle == .strong {
                        textLabel.font = UIFont.systemFont(ofSize: Constants.CONTENT_FONT_SIZE_DETAIL, weight: 0.3)
                    }
                    timeLabel.isHidden = true
                    sperateLine.isHidden = true
                    imageView.isHidden = true
                    textLabel.isHidden = false
                } else if p.type == .image {
                    backgroundColor = .white
                    imageView.image = UIImage(named: "image_placeholder")
                    self.isUserInteractionEnabled = false
                    if let imageURL = p.paragraphString {
                        imageView.loadImageWithURLString(urlString: imageURL, completion: { (success) in
                            self.isUserInteractionEnabled = true
                        })
                    }
                    
                    timeLabel.isHidden = true
                    sperateLine.isHidden = true
                    imageView.isHidden = false
                    textLabel.isHidden = true
                } else if p.type == .title {
                    backgroundColor = .white
                    textLabel.text = p.paragraphString!
                    textLabel.font = UIFont.systemFont(ofSize: Constants.TITLE_FONT_SIZE_DETAIL, weight: 0.3)
                    
                    timeLabel.isHidden = false
                    sperateLine.isHidden = false
                    imageView.isHidden = true
                    textLabel.isHidden = false
                }
            }
        }
    }
    
    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: Constants.CONTENT_FONT_SIZE_DETAIL)
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "image_placeholder")
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: Constants.TIME_FONT_SIZE_DETAIL)
        timeLabel.numberOfLines = 0
        timeLabel.backgroundColor = .white
        timeLabel.text = "2016-12-19 07:19:17"
        return timeLabel
    }()

    let sperateLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.80, alpha: 1)
        return line
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(textLabel)
        addSubview(imageView)
        addSubview(timeLabel)
        addSubview(sperateLine)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: imageView)
        addConstraintsWithFormat("V:|-8-[v0]-8-|", views: imageView)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textLabel)
        addConstraintsWithFormat("V:|-2-[v0]-(>=4)-[v1]-1-[v2(0.5)]|", views: textLabel, timeLabel, sperateLine)
        addConstraintsWithFormat("H:|-8-[v0]", views: timeLabel)
        addConstraintsWithFormat("H:|[v0]|", views: sperateLine)
        
        isUserInteractionEnabled = false
    }
    
}
