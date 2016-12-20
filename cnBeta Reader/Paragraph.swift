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

struct Paragraph {
    
    var type: ParagraphType?
    var alignment: ParagraphAlignment?
    var textStyle: TextStyle?
    var paragraphString: String?
    var paragraphHeight: CGFloat?
    
    init(type: ParagraphType, content: String, alignment: ParagraphAlignment, textStyle: TextStyle = .normal) {
        self.type = type
        self.paragraphString = content
        self.alignment = alignment
        self.textStyle = textStyle
        
        if type == .title {
            self.paragraphHeight = computeHeight(string: content ,fontSize: Constants.TITLE_FONT_SIZE_DETAIL)
        } else if (type == .text) || (type == .summary) {
            self.paragraphHeight = computeHeight(string: content ,fontSize: Constants.CONTENT_FONT_SIZE_DETAIL)
        } else {
            self.paragraphHeight = Constants.SCREEN_WIDTH / 4 * 3 + 8 + 8;
        }
    }
    
    private func computeHeight(string: String, fontSize: CGFloat) -> CGFloat {
        let size = CGSize(width: Constants.SCREEN_WIDTH - 8 - 8, height: CGFloat(FLT_MAX))
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: string).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        return CGFloat(ceilf(Float(estimatedFrame.size.height)) + 20)
    }
}
