//
//  LaunchingView.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 2/2/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class LaunchingView: UIView {
    
    var isDismissed = false
    
    lazy var logoLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        let path = CAShapeLayer()
        path.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        path.path = self.setBezierPath().cgPath
        path.fillColor = Constants.All_ICONS_COLOR.cgColor
        layer.addSublayer(path)
        
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.addSublayer(logoLayer)
        logoLayer.position = self.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setBezierPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 18.6, y: 0))
        path.addLine(to: CGPoint(x: 55.956, y: 0.09))
        path.addLine(to: CGPoint(x: 74.713, y: 32.577))
        path.addLine(to: CGPoint(x: 56.113, y: 64.974))
        path.addLine(to: CGPoint(x: 18.756, y: 64.884))
        path.addLine(to: CGPoint(x: 0, y: 32.397))
        path.addLine(to: CGPoint(x: 18.6, y: 0))
        path.close()
        path.move(to: CGPoint(x: 18.6, y: 75.026))
        path.addLine(to: CGPoint(x: 55.956, y: 75.116))
        path.addLine(to: CGPoint(x: 74.713, y: 107.603))
        path.addLine(to: CGPoint(x: 56.113, y: 140))
        path.addLine(to: CGPoint(x: 18.756, y: 139.91))
        path.addLine(to: CGPoint(x: 0, y: 107.423))
        path.addLine(to: CGPoint(x: 18.6, y: 75.026))
        path.close()
        path.move(to: CGPoint(x: 83.882, y: 37.513))
        path.addLine(to: CGPoint(x: 121.239, y: 37.603))
        path.addLine(to: CGPoint(x: 139.995, y: 70.09))
        path.addLine(to: CGPoint(x: 121.395, y: 102.487))
        path.addLine(to: CGPoint(x: 84.039, y: 102.397))
        path.addLine(to: CGPoint(x: 65.282, y: 69.91))
        path.addLine(to: CGPoint(x: 83.882, y: 37.513))
        path.close()
        path.move(to: CGPoint(x: 83.882, y: 37.513))
        
        return path
    }
    
    func startAnimateWithCompletion(completion: () -> Void) {
        guard isDismissed == false else {
            return
        }
        
        let expandAnim = CAKeyframeAnimation(keyPath:"transform")
        expandAnim.values = [NSValue(caTransform3D: CATransform3DIdentity),
                                    NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1)),
                                    NSValue(caTransform3D: CATransform3DMakeScale(20, 20, 1))]
        expandAnim.keyTimes = [0, 0.4, 1]
        expandAnim.duration = 0.8
        expandAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.isRemovedOnCompletion = false
        logoLayer.add(expandAnim, forKey: "expandAnim")
        
        let dimAnim : CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        dimAnim.delegate = self
        dimAnim.fromValue = 1
        dimAnim.toValue = 0
        dimAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        dimAnim.duration = 0.8
        dimAnim.fillMode = kCAFillModeForwards
        dimAnim.isRemovedOnCompletion = false
        layer.add(dimAnim, forKey: "dimAnim")
        
        completion()
    }
}

extension LaunchingView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            isDismissed = true
        }
    }
}
