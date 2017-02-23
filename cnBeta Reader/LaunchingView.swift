//
//  LaunchingView.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 2/2/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class LaunchingView: UIView {
    
    lazy var logoLayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        let path = CAShapeLayer()
        path.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        path.path = self.setBezierPath().cgPath
        path.fillColor = UIColor.white.cgColor
        layer.addSublayer(path)
        
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.rgb(194, green: 31, blue: 31, alpha: 1.0)
        self.layer.addSublayer(logoLayer)
        logoLayer.position = self.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setBezierPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 34.056, y: 0))
        path.addLine(to: CGPoint(x: 20.064, y: 24.522))
        path.addLine(to: CGPoint(x: 27.598, y: 37.805))
        path.addCurve(to: CGPoint(x: 25.22, y: 41.903), controlPoint1:CGPoint(x: 27.598, y: 37.805), controlPoint2:CGPoint(x: 26.009, y: 39.769))
        path.addCurve(to: CGPoint(x: 24.441, y: 46.344), controlPoint1:CGPoint(x: 24.431, y: 44.036), controlPoint2:CGPoint(x: 24.441, y: 46.344))
        path.addCurve(to: CGPoint(x: 14.986, y: 54.215), controlPoint1:CGPoint(x: 24.441, y: 46.344), controlPoint2:CGPoint(x: 18.276, y: 48.561))
        path.addCurve(to: CGPoint(x: 12.008, y: 67.713), controlPoint1:CGPoint(x: 11.696, y: 59.87), controlPoint2:CGPoint(x: 12.008, y: 67.713))
        path.addCurve(to: CGPoint(x: 0.014, y: 112.068), controlPoint1:CGPoint(x: 12.008, y: 67.713), controlPoint2:CGPoint(x: 0.238, y: 107.356))
        path.addCurve(to: CGPoint(x: 3.457, y: 120.852), controlPoint1:CGPoint(x: -0.21, y: 116.779), controlPoint2:CGPoint(x: 2.347, y: 119.417))
        path.addCurve(to: CGPoint(x: 11.347, y: 128.202), controlPoint1:CGPoint(x: 4.567, y: 122.286), controlPoint2:CGPoint(x: 8.264, y: 126.475))
        path.addCurve(to: CGPoint(x: 35.341, y: 136.334), controlPoint1:CGPoint(x: 20.812, y: 133.501), controlPoint2:CGPoint(x: 28.521, y: 134.936))
        path.addCurve(to: CGPoint(x: 69.143, y: 139.992), controlPoint1:CGPoint(x: 42.162, y: 137.733), controlPoint2:CGPoint(x: 61.017, y: 139.859))
        path.addCurve(to: CGPoint(x: 118.168, y: 132.555), controlPoint1:CGPoint(x: 80.167, y: 140.172), controlPoint2:CGPoint(x: 103.698, y: 137.383))
        path.addCurve(to: CGPoint(x: 134.11, y: 124.021), controlPoint1:CGPoint(x: 123.982, y: 130.616), controlPoint2:CGPoint(x: 130.241, y: 127.256))
        path.addCurve(to: CGPoint(x: 138.545, y: 119.023), controlPoint1:CGPoint(x: 135.555, y: 122.813), controlPoint2:CGPoint(x: 136.286, y: 122.195))
        path.addCurve(to: CGPoint(x: 139.896, y: 112.432), controlPoint1:CGPoint(x: 139.497, y: 117.686), controlPoint2:CGPoint(x: 140.292, y: 115.893))
        path.addCurve(to: CGPoint(x: 127.921, y: 67.831), controlPoint1:CGPoint(x: 139.499, y: 108.971), controlPoint2:CGPoint(x: 127.921, y: 67.831))
        path.addCurve(to: CGPoint(x: 126.859, y: 58.655), controlPoint1:CGPoint(x: 127.921, y: 67.831), controlPoint2:CGPoint(x: 128.858, y: 63.535))
        path.addCurve(to: CGPoint(x: 120.292, y: 49.206), controlPoint1:CGPoint(x: 124.86, y: 53.776), controlPoint2:CGPoint(x: 120.292, y: 49.206))
        path.addLine(to: CGPoint(x: 107.018, y: 26.231))
        path.addLine(to: CGPoint(x: 78.949, y: 26.152))
        path.addLine(to: CGPoint(x: 64.998, y: 50.86))
        path.addLine(to: CGPoint(x: 78.949, y: 75.467))
        path.addLine(to: CGPoint(x: 107.018, y: 75.467))
        path.addLine(to: CGPoint(x: 119.226, y: 54.215))
        path.addCurve(to: CGPoint(x: 122.73, y: 60.923), controlPoint1:CGPoint(x: 119.226, y: 54.215), controlPoint2:CGPoint(x: 121.999, y: 56.858))
        path.addCurve(to: CGPoint(x: 121.972, y: 69.495), controlPoint1:CGPoint(x: 123.461, y: 64.989), controlPoint2:CGPoint(x: 122.741, y: 67.473))
        path.addCurve(to: CGPoint(x: 112.776, y: 75.948), controlPoint1:CGPoint(x: 121.204, y: 71.518), controlPoint2:CGPoint(x: 119.326, y: 73.222))
        path.addCurve(to: CGPoint(x: 99.9, y: 80.224), controlPoint1:CGPoint(x: 106.227, y: 78.674), controlPoint2:CGPoint(x: 106.707, y: 78.683))
        path.addCurve(to: CGPoint(x: 75.333, y: 83.166), controlPoint1:CGPoint(x: 94.303, y: 81.49), controlPoint2:CGPoint(x: 75.333, y: 83.166))
        path.addLine(to: CGPoint(x: 63.965, y: 102.867))
        path.addLine(to: CGPoint(x: 36.338, y: 103.174))
        path.addLine(to: CGPoint(x: 37.286, y: 101.061))
        path.addLine(to: CGPoint(x: 62.582, y: 100.741))
        path.addLine(to: CGPoint(x: 76.243, y: 77.008))
        path.addLine(to: CGPoint(x: 62.117, y: 52.016))
        path.addLine(to: CGPoint(x: 34.056, y: 52.016))
        path.addLine(to: CGPoint(x: 20.439, y: 75.948))
        path.addLine(to: CGPoint(x: 33.021, y: 99.062))
        path.addLine(to: CGPoint(x: 31.847, y: 101.518))
        path.addLine(to: CGPoint(x: 17.904, y: 75.948))
        path.addLine(to: CGPoint(x: 20.215, y: 71.858))
        path.addCurve(to: CGPoint(x: 18.223, y: 70), controlPoint1:CGPoint(x: 20.215, y: 71.858), controlPoint2:CGPoint(x: 19.307, y: 71.169))
        path.addCurve(to: CGPoint(x: 19.132, y: 56.781), controlPoint1:CGPoint(x: 16.103, y: 67.713), controlPoint2:CGPoint(x: 17.142, y: 60.609))
        path.addCurve(to: CGPoint(x: 27.598, y: 49.784), controlPoint1:CGPoint(x: 21.122, y: 52.953), controlPoint2:CGPoint(x: 26.088, y: 50.639))
        path.addCurve(to: CGPoint(x: 29.878, y: 46.895), controlPoint1:CGPoint(x: 29.108, y: 48.929), controlPoint2:CGPoint(x: 29.61, y: 48.96))
        path.addCurve(to: CGPoint(x: 30.481, y: 42.967), controlPoint1:CGPoint(x: 30.147, y: 44.83), controlPoint2:CGPoint(x: 30.481, y: 42.967))
        path.addLine(to: CGPoint(x: 34.056, y: 49.206))
        path.addLine(to: CGPoint(x: 62.582, y: 49.206))
        path.addLine(to: CGPoint(x: 76.243, y: 24.894))
        path.addLine(to: CGPoint(x: 62.117, y: 0.094))
        path.addLine(to: CGPoint(x: 34.056, y: 0))
        path.close()
        path.move(to: CGPoint(x: 34.056, y: 0))
        
        return path
    }
    
    func startAnimateWithCompletion(completion: () -> Void) {
        
        let pathTransformAnim            = CAKeyframeAnimation(keyPath:"transform")
        pathTransformAnim.values         = [NSValue(caTransform3D: CATransform3DIdentity),
                                            NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1)),
                                            NSValue(caTransform3D: CATransform3DMakeScale(20, 20, 1))]
        pathTransformAnim.keyTimes       = [0, 0.4, 1]
        pathTransformAnim.duration       = 0.8
        pathTransformAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        logoLayer.add(pathTransformAnim, forKey: "pathUntitled1Anim")
        
        UIView.animate(withDuration: 0.3, animations: {
            //self.logoLayer.transform = CATransform3DMakeScale(0, 0, 1)
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                //self.logoLayer.transform = CATransform3DMakeScale(20, 20, 1)
                self.alpha = 0.0
            }, completion: { (finished) in
                self.removeFromSuperview()
            })
        }
        
        completion()
    }

}
