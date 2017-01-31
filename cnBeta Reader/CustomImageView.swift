//
//  CustomImageView.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/16/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

let imageCaches: NSCache<NSString, UIImage> = {
    let imageCache = NSCache<NSString, UIImage>()
    imageCache.countLimit = 40
    return imageCache
}()

typealias loadImageCompletion = (Bool) -> Void

class CustomImageView: UIImageView {
    
    var imageURLString: String?
    
    func loadImageWithURLString(_ urlString: String?, completion:@escaping loadImageCompletion) {
        
        if let urlStr = urlString {
            imageURLString = urlStr
        
            if let imageFromCache = imageCaches.object(forKey: urlStr as NSString ) {
                self.image = imageFromCache
                completion(true)
                return
            }
        
            let url = URL(string: urlStr)
        
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                let imageToCache = UIImage(data: data!)
                
                imageCaches.setObject(imageToCache!, forKey: urlStr as NSString)
            
                DispatchQueue.main.async(execute: {
                    if self.imageURLString == urlString {
                        self.image = imageToCache
                        completion(true)
                    }
                })
            
            }).resume()
        }
    }
}
