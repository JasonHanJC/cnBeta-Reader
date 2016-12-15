//
//  FeedCell.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/11/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

class FeedCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(white: 0, alpha: 0.2) : .white
            dateLabel.textColor = isHighlighted ? .white : .black
            titleLabel.textColor = isHighlighted ? .white : .black
            contentLabel.textColor = isHighlighted ? .white : .gray
        }
    }
    
    var feed: Feed? {
        didSet {
            
            if let publishedDate = feed?.publishedDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd-MMM-yyyy HH:mm"
                dateLabel.text = dateFormatter.string(from: publishedDate as Date)
            }
            
            if let title = feed?.title {
                titleLabel.text = title
            }
            
            if let content = feed?.contentSnippet {
                contentLabel.text = content
            }
            //
        }
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "Dummy date"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Dummy title"
        label.numberOfLines = 2
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Dummy content"
        label.numberOfLines = 8
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
        feedContentView.addSubview(contentLabel)
        
        feedContentView.addConstraintsWithFormat("V:|-6-[v0]-1-[v1]-8-[v2]", views: dateLabel, titleLabel, contentLabel)
        feedContentView.addConstraintsWithFormat("H:|[v0]|", views: dateLabel)
        feedContentView.addConstraintsWithFormat("H:|[v0]|", views: titleLabel)
        feedContentView.addConstraintsWithFormat("H:|[v0]|", views: contentLabel)
    }
}
