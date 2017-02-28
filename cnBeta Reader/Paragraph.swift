//
//  Paragraph.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/19/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

enum ParagraphType: Int {
    case title = 0
    case summary = 1
    case text = 2
    case image = 3
    case video = 4
}

enum TextStyle: Int {
    case normal = 0
    case strong = 1
}

enum ParagraphAlignment: Int {
    case alignmentLeft = 0
    case alignmentCenter = 1
    case alignmentRight = 2
}

class Paragraph: NSObject, NSCoding {
    
    var type: ParagraphType?
    var alignment: ParagraphAlignment?
    var textStyle: TextStyle?
    var paragraphString: String?
    var paragraphHeight: Float?
    
    init(type: ParagraphType, content: String, alignment: ParagraphAlignment, textStyle: TextStyle = .normal) {
        super.init()
        self.type = type
        self.paragraphString = content
        self.alignment = alignment
        self.textStyle = textStyle
        self.paragraphHeight = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = ParagraphType(rawValue: (aDecoder.decodeObject(forKey: "type") as! NSNumber).intValue)
        alignment = ParagraphAlignment(rawValue: (aDecoder.decodeObject(forKey: "alignment") as! NSNumber).intValue)
        textStyle = TextStyle(rawValue: (aDecoder.decodeObject(forKey: "style") as! NSNumber).intValue)
        paragraphString = aDecoder.decodeObject(forKey: "paragraphString") as! String?
        paragraphHeight = (aDecoder.decodeObject(forKey: "height") as! NSNumber).floatValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(NSNumber.init(value: (type?.rawValue)!) , forKey: "type")
        aCoder.encode(NSNumber.init(value: (alignment?.rawValue)!), forKey: "alignment")
        aCoder.encode(NSNumber.init(value: (textStyle?.rawValue)!), forKey: "style")
        aCoder.encode(paragraphString, forKey: "paragraphString")
        aCoder.encode(NSNumber.init(value: paragraphHeight!), forKey: "height")
    }
}
