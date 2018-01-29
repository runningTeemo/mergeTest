//
//  NSAttributedString_ext.swift
//  tinCRM
//
//  Created by Richard.q.x on 16/8/3.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    func qx_shortAttributedString(width: CGFloat, dots: NSAttributedString) -> NSAttributedString {
        
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let origeWidth = self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).width
        let dotsWidth = dots.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).width
        if origeWidth <= width {
            return self
        } else {
            
            let charCount = self.string.characters.count
            if charCount == 0 {
                return NSAttributedString()
            }
            let shortCount = Int(CGFloat(charCount) * (width / origeWidth))
            if shortCount <= 0 || shortCount > string.characters.count - 1 {
                return NSAttributedString()
            }
            var attri = attributedSubstring(from: NSMakeRange(0, shortCount))
            
            while attri.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).width > width - dotsWidth {
                let shortCount = attri.string.characters.count - 1
                if shortCount <= 0 {
                    return NSAttributedString()
                }
                attri = attri.attributedSubstring(from: NSMakeRange(0, shortCount))
            }
            
            let mAttri = NSMutableAttributedString()
            mAttri.append(attri)
            mAttri.append(dots)
            return mAttri
        }
    }
    
}
