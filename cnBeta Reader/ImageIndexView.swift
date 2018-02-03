//
//  ImageIndexView.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 3/1/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class ImageIndexView: UIView {
    
    let sumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "xxx"
        return label
    }()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "xxx"
        return label
    }()
    
    private let slashLable: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "/"
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(indexLabel)
        stackView.addArrangedSubview(slashLable)
        stackView.addArrangedSubview(sumLabel)
        
        addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
