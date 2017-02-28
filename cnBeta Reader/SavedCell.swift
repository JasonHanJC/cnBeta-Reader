//
//  SavedCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/19/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

class SavedCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(white: 0.80, alpha: 1) : .white
            dateLabel.textColor = isHighlighted ? .white : Constants.TIME_LABEL_TEXT_COLOR
            titleLabel.textColor = isHighlighted ? .white : .black
            contentLabel.textColor = isHighlighted ? .white : .gray
        }
    }
    
    var feed: Feed? {
        didSet {
            
            if let publishedDate = feed?.publishedDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM-dd-yyyy HH:mm"
                dateLabel.text = dateFormatter.string(from: publishedDate as Date)
            }
            
            if let title = feed?.title {
                let attrString = NSAttributedString(string: title, attributes: Constants.FEED_TITLE_STYLE)
                titleLabel.attributedText = attrString
            }
            
            if let content = feed?.contentSnippet {
                
                let attrString = NSAttributedString(string: content, attributes: Constants.FEED_SUMM_STYLE)
                contentLabel.attributedText = attrString
            }
        }
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.TIME_LABEL_FONT_FEED
        label.textColor = Constants.TIME_LABEL_TEXT_COLOR
        label.text = "Dummy date"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.TITLE_FONT_FEED
        label.textColor = .black
        label.text = "Dummy title"
        label.numberOfLines = 0
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.CONTENT_FONT_FEED
        label.textColor = .gray
        label.text = "Dummy content"
        label.numberOfLines = 0
        return label
    }()
    
    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.SEPRATE_LINE_COLOR
        return view
    }()
    
    
    let saveContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        addSubview(saveContentView)
        addSubview(topLine)
        
        addConstraintsWithFormat("H:|-20-[v0]-20-|", views: saveContentView)
        addConstraintsWithFormat("V:|[v0(0.5)]-29.5-[v1]-30-|", views: topLine, saveContentView)
        
        addConstraintsWithFormat("H:|[v0]|", views: topLine)
        
        setupContentView()
    }
    
    func setupContentView() {
        
        saveContentView.addSubview(dateLabel)
        saveContentView.addSubview(titleLabel)
        saveContentView.addSubview(contentLabel)
        
        saveContentView.addConstraintsWithFormat("V:|[v0]-4-[v1]-12-[v2]", views: dateLabel, titleLabel, contentLabel)
        saveContentView.addConstraintsWithFormat("H:|[v0]|", views: dateLabel)
        saveContentView.addConstraintsWithFormat("H:|[v0]|", views: titleLabel)
        saveContentView.addConstraintsWithFormat("H:|[v0]|", views: contentLabel)
    }
}
