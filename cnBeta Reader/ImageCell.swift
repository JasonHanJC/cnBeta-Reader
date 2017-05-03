//
//  ImageCell.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 2/9/17.
//  Copyright © 2017 JasonH. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell, UIScrollViewDelegate {
    
    let imageScrollView = UIScrollView()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        imageScrollView.center = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        imageScrollView.bounces = false
        imageScrollView.backgroundColor = .clear
        imageScrollView.clipsToBounds = false
        imageScrollView.zoomScale = 1.0
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 3.0
        imageScrollView.bouncesZoom = false
        imageScrollView.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
        imageScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        imageScrollView.delegate = self
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(imageScrollView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageScrollView.addSubview(imageView)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    
}
