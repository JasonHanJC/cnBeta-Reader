//
//  Constants.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/16/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

struct Constants {
    
    // MARK: screen info
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    // api
    static let API_URL = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.cnbeta.com/rss&num=100"
    
    static let API_URL_2 = "http://cloud.feedly.com/v3/streams/contents?streamId=feed%2Fhttp%3A%2F%2Fwww.cnbeta.com%2Frss.xml&count=100"
    
    // fetch number
    static let FETCH_LIMIT = 20
    
    // font size
    static let TITLE_FONT_SIZE_DETAIL: CGFloat = 21.0
    static let TITLE_FONT_SIZE: CGFloat = 21.0
    
    static let CONTENT_FONT_SIZE_DETAIL: CGFloat = 18.0
    static let CONTENT_FONT_SIZE: CGFloat = 18.0
    
    static let TIME_FONT_SIZE_DETAIL: CGFloat = 13.0
    static let TIME_FONT_SIZE: CGFloat = 12.0
}
