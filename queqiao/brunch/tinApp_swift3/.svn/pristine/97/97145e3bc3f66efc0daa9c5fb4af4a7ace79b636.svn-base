//
//  AttributedStringTool.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/21.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class AttributedStringTool {
    
    class func notNullAttributedString(text: String?, font: UIFont, color: UIColor) -> NSAttributedString {
        if let text = text {
            let dic = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color
            ]
            return NSAttributedString(string: text, attributes: dic)
        }
        return NSAttributedString()
    }
    
    class func notNullAttributedImage(named: String, bounds: CGRect) -> NSAttributedString {
        return notNullAttributedImage(image: UIImage(named: named), bounds: bounds)
    }
    
    class func notNullAttributedImage(image: UIImage?, bounds: CGRect) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        return NSAttributedString(attachment: attachment)
    }
    
    class func calcSize(attributedString: NSAttributedString?, maxWidth: CGFloat) -> CGSize {
        if let attributedString = attributedString {
            return attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
        }
        return CGSize.zero
    }
    
    class func lineSpaceAttributedString(height: CGFloat) -> NSAttributedString {
        return notNullAttributedString(text: "\n", font: UIFont.systemFont(ofSize: height), color: UIColor.clear)
    }
    
}
