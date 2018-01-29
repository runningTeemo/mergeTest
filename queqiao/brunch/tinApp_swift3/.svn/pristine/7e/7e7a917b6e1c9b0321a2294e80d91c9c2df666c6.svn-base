//
//  Label.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum LabelVertAlignment {
    case center
    case top
    case bottom
}

/// label子类，可修改文字间隙， 可设置文字垂直对齐
class Label: UILabel {
    
    /// 垂直方向对齐方式
    var vertAligment: LabelVertAlignment = .center {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 设置文字的内边距（nil，表示默认）
    var insets: UIEdgeInsets?
    
    /// 重新调整文本位置
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch vertAligment {
        case .top:
            rect.origin.y = bounds.origin.y
        case .bottom:
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height
        default:
            break
        }
        return rect
    }
    
    /// 重绘
    override func drawText(in rect: CGRect) {
        let actualRect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        if let insets = insets {
            super.drawText(in: UIEdgeInsetsInsetRect(actualRect, insets))
        } else {
            super.drawText(in: actualRect)
        }
    }
    
}
