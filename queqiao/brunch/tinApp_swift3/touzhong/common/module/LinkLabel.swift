//
//  LineLabel.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LinkLabel: TYAttributedLabel, TYAttributedLabelDelegate {
    
    var lineSpacing: CGFloat = 5
    var respondLinkText: ((_ text: String) -> ())?
    
    init() {
        super.init(frame: CGRect.zero)
        delegate = self
        
        numberOfLines = 0
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 14)
        
        linkColor = UIColor.blue
        highlightedLinkColor = UIColor.orange
        highlightedLinkBackgroundColor = UIColor.lightGray
        characterSpacing = 3
        linesSpacing = 5
        
        textAlignment = .natural
        lineBreakMode = .byTruncatingTail
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clean() {
        super.setAttributedText(NSAttributedString())
    }
    
    func customAppend(_ image: UIImage, size: CGSize) {
        super.append(image, size: size)
    }
    
    func customAppend(_ text: String?, font: UIFont, color: UIColor) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = self.lineSpacing
        let dic = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: style
        ]
        let attiStr = NSAttributedString(string: text == nil ? "" : text!, attributes: dic)
        super.appendTextAttributedString(attiStr)
    }
    
    func customAppend(_ text: String?, link: String, font: UIFont, color: UIColor) {
        let t = text == nil ? "" : text!
        super.appendLink(withText: t, linkFont: font, linkColor: color, linkData: link)
        
    }
    
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        if let run = textStorage as? TYLinkTextStorage {
            let link = run.linkData as! String
            respondLinkText?(link)
        }
    }
    
}
