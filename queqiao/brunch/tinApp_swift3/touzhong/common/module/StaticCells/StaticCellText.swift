//
//  StaticCellText.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellTextItem: StaticCellBaseItem {
    
    var text: String?
    var attriText: NSAttributedString? // 设置富文本，则直接使用富文本的样式
    
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    var textColor: UIColor = UIColor.black
    
    var topMargin: CGFloat = 0
    var bottomMargin: CGFloat = 0

    // 缓存属性
    fileprivate(set) var attriDic: [String: AnyObject]?
    fileprivate(set) var attriContent: NSAttributedString?
    
    func update() {
        let textMaxWidth = totalWidth - kStaticCellLeftMargin - kStaticCellRightMargin
        if let attriText = attriText {
            let size = StringTool.size(attriText, maxWidth: textMaxWidth)
            cellHeight = size.height + topMargin + bottomMargin + 1
            attriContent = attriText
            
        } else {
            attriDic = StringTool.makeAttributeDic(textFont, color: textColor)
            let norSizeAttriStr = StringTool.size(text, attriDic: attriDic, maxWidth: textMaxWidth)
            attriContent = norSizeAttriStr.attriStr
            cellHeight = norSizeAttriStr.size.height + topMargin + bottomMargin + 1
        }
    }
    
}

class StaticCellTextCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellTextItem {
            label.attributedText = item.attriContent
            topCons?.constant = item.topMargin
            bottomCons?.constant = -item.bottomMargin
        }
    }
    
    var topCons: NSLayoutConstraint?
    var bottomCons: NSLayoutConstraint?
    lazy var label: Label = {
        let one = Label()
        one.insets = UIEdgeInsets.zero
        one.textAlignment = .left
        one.numberOfLines = 0
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.IN(contentView).LEFT(kStaticCellLeftMargin).RIGHT(kStaticCellRightMargin).MAKE()
        topCons = label.TOP.EQUAL(contentView).MAKE()
        bottomCons = label.BOTTOM.EQUAL(contentView).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
