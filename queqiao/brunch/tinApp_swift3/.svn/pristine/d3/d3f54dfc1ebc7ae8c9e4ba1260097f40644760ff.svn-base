//
//  RoundRectSelectButton.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

struct RoundRectSelectButtonItem {
    
    // 业务
    var title: String?
    var isSelect: Bool = false
    
    // 样式
    var norTitleColor: UIColor = UIColor.gray
    var selTilteColor: UIColor = UIColor.orange
    
    var norTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var selTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    var norBorderColor: UIColor = UIColor.gray
    var selBorderColor: UIColor = UIColor.orange
    var norBorderWidth: CGFloat = 1
    var selBorderWidth: CGFloat = 1
    
    var height: CGFloat = 35
    var minWidth: CGFloat = 50
    var lrMargin: CGFloat = 10 // 左右间距
    
    // 缓存属性
    private(set) var viewSize: CGSize = CGSize.zero
    private(set) var norAttriTitle: NSAttributedString?
    private(set) var norAttriDic: [String: AnyObject]?
    private(set) var selAttriTitle: NSAttributedString?
    private(set) var selAttriDic: [String: AnyObject]?

    mutating func update() {
        norAttriDic = StringTool.makeAttributeDic(norTitleFont, color: norTitleColor)
        let norSizeAttriStr = StringTool.size(title, attriDic: norAttriDic)
        norAttriTitle = norSizeAttriStr.attriStr
        let width = norSizeAttriStr.size.width + lrMargin * 2
        
        viewSize = CGSize(width: max(width, minWidth), height: height)
        
        selAttriDic = StringTool.makeAttributeDic(selTitleFont, color: selTilteColor)
        let selSizeAttriStr = StringTool.size(title, attriDic: selAttriDic)
        selAttriTitle = selSizeAttriStr.attriStr
    }
    
}

class RoundRectSelectLabel: UILabel {
    
    var item: RoundRectSelectButtonItem? {
        didSet {
            if let item = item {
                layer.cornerRadius = item.height / 2
                if item.isSelect {
                    attributedText = item.selAttriTitle
                    layer.borderColor = item.selBorderColor.cgColor
                    layer.borderWidth = item.selBorderWidth
                } else {
                    attributedText = item.norAttriTitle
                    layer.borderColor = item.norBorderColor.cgColor
                    layer.borderWidth = item.norBorderWidth
                }
            }
        }
    }
    
}
