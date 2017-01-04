//
//  ZoomImageController.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 1/3/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit

class ZoomImageController: NSObject, UIScrollViewDelegate {
    
    var zoomImage: UIImage?
    var startingFrame: CGRect?
    
    let blackView = UIView()
    
    let imageScrollView = UIScrollView()
    let imageView = CustomImageView()
    
    func show() {
        if let window = UIApplication.shared.keyWindow {
            
            // setup blackView
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.9)
            blackView.frame = window.frame
            blackView.alpha = 0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            
            var scrollViewTopBottomInset: CGFloat
            
            // setup scrollView
            if let image = imageView.image {
                
                let ratio = window.frame.width / image.size.width
                let imageViewH = image.size.height * ratio
                let imageViewW = window.frame.width
                
                if imageViewH >= window.frame.height {
                    scrollViewTopBottomInset = 0
                } else {
                    scrollViewTopBottomInset = (window.frame.height - imageViewH) / 2.0
                }
                
                imageScrollView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                imageScrollView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
                imageScrollView.bounces = true
                imageScrollView.backgroundColor = .clear
                imageScrollView.clipsToBounds = false
                imageScrollView.contentSize = CGSize(width: imageViewW, height: imageViewH)
                imageScrollView.contentInset = UIEdgeInsetsMake(scrollViewTopBottomInset, 0, scrollViewTopBottomInset, 0)
                imageScrollView.minimumZoomScale = 1.0
                imageScrollView.maximumZoomScale = 3.0
                imageScrollView.bouncesZoom = false
                imageScrollView.delegate = self
                imageScrollView.showsVerticalScrollIndicator = false
                imageScrollView.showsHorizontalScrollIndicator = false
                imageScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
                window.addSubview(imageScrollView)
                
                imageView.frame = CGRect(x: 0, y: 0, width: imageViewW, height: imageViewH)
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                imageScrollView.addSubview(imageView)
                
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.blackView.alpha = 1
                self.imageScrollView.alpha = 1
                self.imageView.alpha = 1
            }, completion: nil)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc private func handleDismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.blackView.alpha = 0
            self.imageScrollView.alpha = 0
            self.imageView.alpha = 0
        }, completion: { _ in
            self.blackView.removeFromSuperview()
            self.imageScrollView.removeFromSuperview()
            self.imageView.removeFromSuperview()
        })
    }
    
    
    // MARK: Lifecycle
    override init() {
        super.init()
        
    }
    
    deinit {
        print("ZoomImageController deinit")
    }
    
}
