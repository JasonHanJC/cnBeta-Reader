//
//  SavedCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/19/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData

class SavedCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            viewHolder.backgroundColor = isHighlighted ? UIColor(white: 0.80, alpha: 1) : .white
            dateLabel.textColor = isHighlighted ? .white : .lightGray
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
                titleLabel.text = title
            }
            
            if let content = feed?.contentSnippet {
                contentLabel.text = content
            }
        }
    }

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "Dummy date"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.text = "Dummy title"
        label.numberOfLines = 2
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.text = "Dummy content"
        label.numberOfLines = 3
        return label
    }()
    
    let viewHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0);
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2.0
        return view
    }()

    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        addSubview(viewHolder)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: viewHolder)
        addConstraintsWithFormat("V:|-4-[v0]-4-|", views: viewHolder)
        
        setupViewHolder()
    }
    
    func setupViewHolder() {
        
        viewHolder.addSubview(titleLabel)
        viewHolder.addSubview(dateLabel)
        viewHolder.addSubview(contentLabel)
        
        viewHolder.addConstraintsWithFormat("V:|-8-[v0]-8-[v1]-4-[v2]", views: titleLabel, dateLabel, contentLabel)
        viewHolder.addConstraintsWithFormat("H:|-4-[v0]-4-|", views: dateLabel)
        viewHolder.addConstraintsWithFormat("H:|-4-[v0]-4-|", views: titleLabel)
        viewHolder.addConstraintsWithFormat("H:|-4-[v0]-4-|", views: contentLabel)

        
    }
}
