//
//  RoundRectSelectView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RoundRectSelectsItem {
    
    var models: [RoundRectSelectItem]?
    
    var itemXMargin: CGFloat = 10
    var itemYMargin: CGFloat = 10
    
    var maxWidth: CGFloat = UIScreen.main.bounds.size.width - 15 * 2

    fileprivate(set) var viewHeight: CGFloat = 0
    
    func update() {
        viewHeight = 0
        if let models = models {
            var offSetX: CGFloat = 0
            var offsetY: CGFloat = 0
            for model in models {
                let size = model.viewSize
                model.frame = CGRect(x: offSetX, y: offsetY, width: size.width, height: size.height)
                offSetX += (itemXMargin + size.width)
                if model.frame.maxX > maxWidth {
                    offSetX = 0
                    offsetY = offsetY + size.height + itemYMargin
                }
            }
            if let model = models.last {
                viewHeight = model.frame.maxY
            }
        }
    }

}

class RoundRectSelectsView: UIView {
    
    var respondSelectChange: ((_ selectIdxes: [Int]) -> ())?
    
    func selectAll() {
        if let item = item {
            if let models = item.models {
                for model in models {
                    model.isSelect = true
                }
            }
        }
        setNeedsDisplay()
    }
    
    func disSelectAll() {
        if let item = item {
            if let models = item.models {
                for model in models {
                    model.isSelect = false
                }
            }
        }
        setNeedsDisplay()
    }
    
    var item: RoundRectSelectsItem? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let item = item {
            if let models = item.models {
                for model in models {
                    let ctx = UIGraphicsGetCurrentContext()
                    let r = model.height / 2
                    
                    if model.isSelect {
                        let b = model.selBorderWidth / 2
                        let path = UIBezierPath(roundedRect: model.frame.insetBy(dx: b, dy: b), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: r, height: r))
                        ctx?.setLineWidth(model.selBorderWidth)
                        model.selBorderColor.setStroke()
                        ctx?.addPath(path.cgPath)
                        ctx?.strokePath()
                        model.selAttriTitle?.draw(in: model.selTitleFrame)
                    } else {
                        let b = model.norBorderWidth / 2
                        let path = UIBezierPath(roundedRect: model.frame.insetBy(dx: b, dy: b), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: r, height: r))
                        ctx?.setLineWidth(model.norBorderWidth)
                        model.norBorderColor.setStroke()
                        ctx?.addPath(path.cgPath)
                        ctx?.strokePath()
                        model.norAttriTitle?.draw(in: model.norTitleFrame)
                    }
                }
            }
        }
    }
    
    // 模拟touchUpInSide
    
    fileprivate var outOfRange = false
    fileprivate var touchModel: RoundRectSelectItem?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        outOfRange = false
        if let touch = touches.first {
            let point = touch.location(in: self)
            if let models = item?.models {
                for model in models {
                    if model.frame.contains(point) {
                        touchModel = model
                    }
                }
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if outOfRange { return }
        if let touch = touches.first {
            let point = touch.location(in: self)
            if let touchModel = touchModel {
                if !touchModel.frame.contains(point) {
                    outOfRange = true
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if outOfRange { return }
        if let touchModel = touchModel {
            touchModel.isSelect = !touchModel.isSelect
            setNeedsDisplay()
            var idxes = [Int]()
            if let item = item {
                if let models = item.models {
                    var idx: Int = 0
                    for model in models {
                        if model.isSelect {
                            idxes.append(idx)
                        }
                        idx += 1
                    }
                }
            }
            respondSelectChange?(idxes)
        }
    }
    
}


/// 圆角的label控件的配置item
class RoundRectSelectItem {
    
    // 业务
    var title: String?
    var isSelect: Bool = false
    
    // 样式
    var norTitleColor: UIColor = UIColor.gray
    var selTitleColor: UIColor = UIColor.orange
    
    var norTitleFont: UIFont = UIFont.systemFont(ofSize: 12 * kSizeRatio)
    var selTitleFont: UIFont = UIFont.systemFont(ofSize: 12 * kSizeRatio)
    
    var norBorderColor: UIColor = UIColor.gray
    var selBorderColor: UIColor = UIColor.orange
    var norBorderWidth: CGFloat = 0.6
    var selBorderWidth: CGFloat = 0.6
    
    var height: CGFloat = 30
    var minWidth: CGFloat = 50
    var lrMargin: CGFloat = 10 // 左右间距
    
    // 缓存属性
    fileprivate(set) var viewSize: CGSize = CGSize.zero
    fileprivate(set) var norTitleSize: CGSize = CGSize.zero
    fileprivate(set) var selTitleSize: CGSize = CGSize.zero
    fileprivate(set) var norAttriTitle: NSAttributedString?
    fileprivate(set) var norAttriDic: [String: AnyObject]?
    fileprivate(set) var selAttriTitle: NSAttributedString?
    fileprivate(set) var selAttriDic: [String: AnyObject]?
    
    var frame: CGRect = CGRect.zero
    var norTitleFrame: CGRect {
        let x = frame.minX + (frame.size.width - norTitleSize.width) / 2
        let y = frame.minY + (frame.size.height - norTitleSize.height) / 2
        return CGRect(x: x, y: y, width: norTitleSize.width, height: norTitleSize.height)
    }
    var selTitleFrame: CGRect {
        let x = frame.minX + (frame.size.width - selTitleSize.width) / 2
        let y = frame.minY + (frame.size.height - selTitleSize.height) / 2
        return CGRect(x: x, y: y, width: selTitleSize.width, height: selTitleSize.height)
    }
    
    func update() {
        norAttriDic = StringTool.makeAttributeDic(norTitleFont, color: norTitleColor)
        let norSizeAttriStr = StringTool.size(title, attriDic: norAttriDic)
        norAttriTitle = norSizeAttriStr.attriStr
        let width = norSizeAttriStr.size.width + lrMargin * 2
        viewSize = CGSize(width: max(width, minWidth), height: height)
        norTitleSize = norSizeAttriStr.size
        
        selAttriDic = StringTool.makeAttributeDic(selTitleFont, color: selTitleColor)
        let selSizeAttriStr = StringTool.size(title, attriDic: selAttriDic)
        selAttriTitle = selSizeAttriStr.attriStr
        selTitleSize = selSizeAttriStr.size
    }
    
}
