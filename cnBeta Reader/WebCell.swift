//
//  WebCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/16/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import Kingfisher

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
                        textLabel.font = Constants.CONTENT_FONT_DETAIL_NORMAL
                    } else if p.textStyle == .strong {
                        textLabel.font = Constants.CONTENT_FONT_DETAIL_NORMAL
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
                        let resource = ImageResource(downloadURL: URL(string: imageURL)!, cacheKey: imageURL)
                        imageView.kf.setImage(with: resource, completionHandler: {
                            (image, error, cacheType, imageUrl) in
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
                    textLabel.font = Constants.TITLE_FONT_DETAIL
                    textLabel.textAlignment = .left

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
        textLabel.font =  Constants.CONTENT_FONT_DETAIL_NORMAL;
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "image_placeholder")
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = Constants.TIME_FONT_FONT_DETAIL
        timeLabel.textColor = Constants.TIME_LABEL_TEXT_COLOR
        timeLabel.numberOfLines = 0
        timeLabel.backgroundColor = .white
        timeLabel.text = "0000-00-00 00:00:00"
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
