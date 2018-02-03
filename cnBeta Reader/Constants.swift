//
//  Constants.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/16/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

struct Constants {
    
    // MARK: - screen info
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    // MARK: - API
    static let API_URL_2 = "http://cloud.feedly.com/v3/streams/contents?streamId=feed%2Fhttp://rss.cnbeta.com/rss&count=100"
    
    // MARK: - Fetch limit
    static let FETCH_LIMIT = 20
    
    // MARK: - Fonts
    static let TITLE_FONT_DETAIL: UIFont = UIFont.init(name: "PingFangSC-Semibold", size: 22) ?? UIFont.systemFont(ofSize: 22)
    static let TITLE_FONT_FEED: UIFont = UIFont.init(name: "PingFangSC-Semibold", size: 20) ?? UIFont.systemFont(ofSize: 20)
    
    static let FEED_HEADER_FONT: UIFont = UIFont.init(name: "PingFangSC-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12)
    
    static let CONTENT_FONT_DETAIL_NORMAL: UIFont = UIFont.init(name: "PingFangSC-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
    static let CONTENT_FONT_FEED: UIFont = UIFont.init(name: "PingFangSC-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
    
    static let TIME_LABEL_FONT_DETAIL: UIFont = UIFont.init(name: "Avenir-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12)
    static let TIME_LABEL_FONT_FEED: UIFont = UIFont.init(name: "Avenir-Black", size: 12) ?? UIFont.systemFont(ofSize: 12)
    
    // MARK: - Colors
    static let TITLE_TEXT_COLOR: UIColor =  UIColor(red:0, green:0, blue:0, alpha:1.0)
    static let SUMMARY_TEXT_COLOR: UIColor = UIColor(red:0.45, green:0.46, blue:0.47, alpha:1.0)
    static let TIME_LABEL_TEXT_COLOR: UIColor = UIColor(red:0.95, green:0.43, blue:0.39, alpha:1.0)
    static let All_ICONS_COLOR: UIColor = UIColor(red:0.95, green:0.43, blue:0.39, alpha:1.0)
    static let SEPRATE_LINE_COLOR: UIColor = UIColor.rgb(230, green: 233, blue: 236, alpha: 1)
    static let DETAIL_TEXT_NORMAL_COLOR: UIColor = UIColor.rgb(115, green: 118, blue: 121, alpha: 1)
    static let DETAIL_TEXT_SUMM_COLOR: UIColor = UIColor.black
    
    // MARK: - Image Holder
    static let IMAGE_PLACEHOLDER: UIImage = UIImage(named: "image_placeholder")!
    
    // MARK: - Text style
    // feed summ style dictionary
    static let FEED_SUMM_STYLE: [NSAttributedStringKey : Any] = {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.alignment = .left
        paraStyle.minimumLineHeight = 22
        
        let dic = [NSAttributedStringKey.paragraphStyle: paraStyle, NSAttributedStringKey.kern: 0.2, NSAttributedStringKey.font: CONTENT_FONT_FEED] as [NSAttributedStringKey : Any]
        return dic
    }()
    
    static let FEED_TITLE_STYLE: [NSAttributedStringKey: Any] = {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.alignment = .left
        paraStyle.minimumLineHeight = 28
        
        let dic = [NSAttributedStringKey.paragraphStyle : paraStyle, NSAttributedStringKey.kern: 0.2, NSAttributedStringKey.font: TITLE_FONT_FEED] as [NSAttributedStringKey : Any] 
        return dic
    }()
    
    
    static let DETAIL_SUMM_STYLE: [NSAttributedStringKey : Any] = {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.alignment = .left
        paraStyle.minimumLineHeight = 26
        
        let dic = [NSAttributedStringKey.paragraphStyle: paraStyle, NSAttributedStringKey.kern: 0.16, NSAttributedStringKey.font: CONTENT_FONT_DETAIL_NORMAL] as [NSAttributedStringKey : Any]
        return dic
    }()
    
    static let DETAIL_NORMAL_STYLE: [NSAttributedStringKey : Any] = {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.alignment = .left
        paraStyle.minimumLineHeight = 26
        
        let dic = [NSAttributedStringKey.paragraphStyle: paraStyle, NSAttributedStringKey.kern: 0.16, NSAttributedStringKey.font: CONTENT_FONT_DETAIL_NORMAL] as [NSAttributedStringKey : Any]
        return dic
    }()
    
    static let DETAIL_TITLE_STYLE: [NSAttributedStringKey : Any] = {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.alignment = .left
        paraStyle.minimumLineHeight = 30
        
        let dic = [NSAttributedStringKey.paragraphStyle : paraStyle, NSAttributedStringKey.kern: 0.22, NSAttributedStringKey.font: TITLE_FONT_DETAIL] as [NSAttributedStringKey : Any]
        return dic
    }()
    
}
