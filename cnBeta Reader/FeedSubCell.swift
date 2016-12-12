//
//  FeedCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

class FeedSubCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(white: 0, alpha: 0.2) : .white
            dateLabel.textColor = isHighlighted ? .white : .black
            titleLabel.textColor = isHighlighted ? .white : .black
            contentTextView.textColor = isHighlighted ? .white : .gray
        }
    }
    
    var feed: Feed? {
        didSet {
            
            if let publishedDate = feed?.publishedDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd-MMM-yyyy HH:mm"
                dateLabel.text = dateFormatter.string(from: publishedDate as Date)
            }
            
            //
        }
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "2016-12-12 02:34:40"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "索尼公布《蜘蛛侠：归来》续集上映时间：《绝地战警4》为其提档"
        label.numberOfLines = 2
        return label
    }()
    
    let contentTextView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "许多影迷翘首以盼的《蜘蛛侠：归来》终于在近日公布了首支预告片。之所以如此令人期待自然有它的原因所在—首部由索尼和漫威合拍的蜘蛛侠电影，并且主角的年龄设备也遵照了原著漫画。虽然《蜘蛛侠：归来》起码要等到明年7月7日才能跟观众见面，但索尼似乎已经等不及要跟人"
        label.numberOfLines = 5
        return label
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let circle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Circle")
        return imageView
    }()
    
    let feedContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(line)
        addSubview(circle)
        addSubview(feedContentView)
        
        addConstraintsWithFormat("H:|-15-[v0(1)]-8-[v1]-15-|", views: line, feedContentView)
        addConstraintsWithFormat("V:|[v0]|", views: line)
        addConstraintsWithFormat("V:|[v0]|", views: feedContentView)
        
        addConstraintsWithFormat("V:|-9-[v0(9)]", views: circle)
        addConstraintsWithFormat("H:[v0(9)]", views: circle)
        addConstraint(NSLayoutConstraint(item: circle, attribute: .centerX, relatedBy: .equal, toItem: line, attribute: .centerX, multiplier: 1, constant: 0))
        
        setupContentView()
    }
    
    func setupContentView() {
        
        feedContentView.addSubview(dateLabel)
        feedContentView.addSubview(titleLabel)
        feedContentView.addSubview(contentTextView)
        
        feedContentView.addConstraintsWithFormat("V:|-6-[v0]-1-[v1]-8-[v2]", views: dateLabel, titleLabel, contentTextView)
        feedContentView.addConstraintsWithFormat("H:|[v0]|", views: dateLabel)
        feedContentView.addConstraintsWithFormat("H:|[v0]|", views: titleLabel)
        feedContentView.addConstraintsWithFormat("H:|[v0]|", views: contentTextView)
    }
}
