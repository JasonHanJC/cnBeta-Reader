//
//  CNPageControlBaguette.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 3/31/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class CNPageControlBaguette: CNBasePageControl {

    fileprivate var diameter: CGFloat {
        return radius * 2
    }
    
    fileprivate var inactive = [CAShapeLayer]()
    
    fileprivate var active: CAShapeLayer = CAShapeLayer()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    override func updateNumberOfPages(_ count: Int) {
        inactive = [CAShapeLayer]()
        inactive = (0..<count).map {_ in
            let layer = CAShapeLayer()
            self.layer.addSublayer(layer)
            return layer
        }
        self.layer.addSublayer(active)
        
        setNeedsLayout()
        self.invalidateIntrinsicContentSize()
    }
    
    override func update(for progress: Double) {
        guard progress >= 0 && progress <= Double(numberOfPages - 1),
            let firstFrame = self.inactive.first?.frame else { return }
        
        let normalized = progress * Double(diameter + padding)
        let distance = abs(round(progress) - progress)
        let mult = 1 + distance * 2
        
        var frame = active.frame
        
        frame.origin.x = CGFloat(normalized) + firstFrame.origin.x
        frame.size.width = frame.height * CGFloat(mult)
        frame.size.height = self.diameter
        
        active.frame = frame
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let floatCount = CGFloat(inactive.count)
        let x = (self.bounds.size.width - self.diameter*floatCount - self.padding*(floatCount-1))*0.5
        let y = (self.bounds.size.height - self.diameter)*0.5
        var frame = CGRect(x: x, y: y, width: self.diameter, height: self.diameter)
        
        active.cornerRadius = self.radius
        active.backgroundColor = (self.currentPageTintColor ?? self.tintColor)?.cgColor
        active.frame = frame
        
        inactive.forEach() { layer in
            layer.backgroundColor = self.tintColor.withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderWidth = self.borderWidth
                layer.borderColor = self.tintColor.cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.diameter + self.padding
        }
        update(for: progress)
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactive.count) * self.diameter + CGFloat(inactive.count - 1) * self.padding,
                      height: self.diameter)
    }
}
