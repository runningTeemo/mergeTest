//
//  ArticleBubbleTitleView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleBubbleTitle: RootBubbleItem {
    
    var title: String?
    
    var font = UIFont.boldSystemFont(ofSize: 16)
    var textColor = kClrDeepGray
    var tbMargin: CGFloat = 7
    
    override var height: CGFloat {
        let height = StringTool.size(title, font: font, maxWidth: kBubbleContentWidth).size.height
        return height + tbMargin * 2
    }
}

class ArticleBubbleTitleView: UIView {
    
    var item: ArticleBubbleTitle! {
        didSet {
            label.font = item.font
            label.textColor = item.textColor
            label.text = item.title
        }
    }
    
    private lazy var label: UILabel = {
        let one = UILabel()
        one.numberOfLines = 0
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(label)
        label.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
