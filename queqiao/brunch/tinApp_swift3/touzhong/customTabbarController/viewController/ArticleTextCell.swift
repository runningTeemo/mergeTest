//
//  ArticleTextCell.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleBubbleText: RootBubbleItem {
    
    var text: String? {
        didSet {
            let sa = StringTool.size(text, attriDic: attriDic, maxWidth: kBubbleContentWidth - 12.5 * 2)
            attriText = sa.attriStr
            _height = sa.size.height + tbMargin * 2
        }
    }
    
    private(set) var attriText: NSAttributedString?
    private(set) var _height: CGFloat = 0

    var tbMargin: CGFloat = 5
    var attriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: kClrDeepGray,
        NSParagraphStyleAttributeName: {
            let one = NSMutableParagraphStyle()
            one.lineSpacing = 2
            one.lineBreakMode = .byWordWrapping
            one.alignment = .justified
            return one
        }()
    ]

    override var height: CGFloat {
        return _height
    }
}

class ArticleTextCell: RootTableViewCell {
    
    var item: ArticleBubbleText! {
        didSet {
            label.attributedText = item.attriText
        }
    }
    
    private lazy var label: UILabel = {
        let one = UILabel()
        one.numberOfLines = 0
        return one
    }()
    required init() {
        super.init(style: .default, reuseIdentifier: "ArticleTextCell")
        addSubview(label)
        label.IN(self).LEFT(12.5).RIGHT(12.5).TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
