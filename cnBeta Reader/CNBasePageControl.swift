//
//  CNBasePageControl.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 3/31/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class CNBasePageControl: UIControl, CNPagaControllable {

    @IBInspectable open var numberOfPages: Int = 0 {
        didSet {
            updateNumberOfPages(numberOfPages)
            self.isHidden = hideForSinglePage && numberOfPages == 1
        }
    }
    
    @IBInspectable open var hideForSinglePage: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var progress: Double = 0 {
        didSet {
            update(for: progress)
        }
    }
    
    open var currentPage: Int {
        return Int(round(progress))
    }
    
    @IBInspectable open var padding: CGFloat = 5.0 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable open var radius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable open var inactiveTransparency: CGFloat = 0.4 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable open var hidesForSinglePage: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override open var tintColor: UIColor! {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var currentPageTintColor: UIColor? {
        didSet {
            setNeedsLayout()
        }
    }

    internal var moveToProgress: Double?
    
    private var displayLink: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupDisplayLink()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupDisplayLink()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        self.displayLink?.remove(from: .current, forMode: .commonModes)
    }
    
    internal func setupDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        self.displayLink?.add(to: .current, forMode: .commonModes)
    }
    
    @objc internal func updateFrame() {
        self.animate()
    }
    
    func animate() {
        guard let moveToProgress = self.moveToProgress else { return }
        
        let a = fabsf(Float(moveToProgress))
        let b = fabsf(Float(progress))
        
        if a > b {
            self.progress += 0.1
        }
        if a < b {
            self.progress -= 0.1
        }
        
        if a == b {
            self.progress = moveToProgress
            self.moveToProgress = nil
        }
        
        if self.progress < 0 {
            self.progress = 0
            self.moveToProgress = nil
        }
        
        if self.progress > Double(numberOfPages - 1) {
            self.progress = Double(numberOfPages - 1)
            self.moveToProgress = nil
        }
    }
    
    open func set(progress: Int, animated: Bool) {
        guard progress <= numberOfPages - 1 && progress >= 0 else { return }
        if animated == true {
            self.moveToProgress = Double(progress)
        } else {
            self.progress = Double(progress)
        }
    }
    
    func updateNumberOfPages(_ count: Int) {
        fatalError("Should be implemented in child class")
    }
    
    func update(for progress: Double) {
        fatalError("Should be implemented in child class")
    }

}
