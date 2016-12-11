//
//  Extensions.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func rgb(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
