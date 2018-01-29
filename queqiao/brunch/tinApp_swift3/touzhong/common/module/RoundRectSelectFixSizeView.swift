//
//  RoundRectSelectFixSizeView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RectSelectsFixSizeItem: NSObject {
    
    var models: [RectSelectFixSizeItem]?
    
    var itemXMargin: CGFloat = 10
    var itemYMargin: CGFloat = 10
    
    var maxWidth: CGFloat = UIScreen.main.bounds.size.width - 15 * 2
    
    var mutiMode: Bool = false
    var selectLimit: Int?
    
    /// 这个参数决定第一个label的横跨多少个label
    var firstOneCrossCount: Int = 0
    
    /// 返回view的高度
    fileprivate(set) var viewHeight: CGFloat = 0
    
    /**
     算出view高度，每次必写
     
     - author: zerlinda
     - date: 16-09-01 10:09:01
     */
    func update() {
        viewHeight = 0
        if let models = models {
            var offSetX: CGFloat = 0
            var offsetY: CGFloat = 0
            var isFirst: Bool = true
            for model in models {
                var size = model.size
                if firstOneCrossCount > 0 && isFirst {
                    size = CGSize(width: size.width * CGFloat(firstOneCrossCount + 1) + itemXMargin * CGFloat(firstOneCrossCount), height: size.height)
                    isFirst = false
                }
                
                model.frame = CGRect(x: offSetX, y: offsetY, width: size.width, height: size.height)
                
                if model.frame.maxX > maxWidth {
                    offSetX = 0
                    offsetY = offsetY + size.height + itemYMargin
                    model.frame = CGRect(x: offSetX, y: offsetY, width: size.width, height: size.height)
                    offSetX += (itemXMargin + size.width)
                } else {
                    offSetX += (itemXMargin + size.width)
                }
                
//                
//                model.frame = CGRect(x: offSetX, y: offsetY, width: size.width, height: size.height)
//                offSetX += (itemXMargin + size.width)
//                if offSetX > maxWidth {
//                    offSetX = 0
//                    offsetY = offsetY + size.height + itemYMargin
//                }
            }
            if let model = models.last {
                viewHeight = model.frame.maxY
            }
        }
    }
    
}

class RectSelectsFixSizeView: UIView {
    
    var respondSelectChange: ((_ selectIdxes: [Int], _ lastIdx: Int) -> ())?
    var respondLimit: (() -> ())?

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
    
    var item: RectSelectsFixSizeItem? {
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
                    let r = model.cornerRadius
                    
                    if model.isSelect {
                        let b = model.selBorderWidth / 2
                        let path = UIBezierPath(roundedRect: model.frame.insetBy(dx: b, dy: b), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: r, height: r))
                        ctx?.setLineWidth(model.selBorderWidth)
                        if model.isFillMode {
                            model.selFillColor.setStroke()
                            model.selFillColor.setFill()
                            ctx?.addPath(path.cgPath)
                            ctx?.strokePath()
                            ctx?.addPath(path.cgPath)
                            ctx?.fillPath()
                        } else {
                            model.selBorderColor.setStroke()
                            ctx?.addPath(path.cgPath)
                            ctx?.strokePath()
                        }
                        model.selAttriTitle?.draw(in: model.selTitleFrame)
                        if model.showCornerImage {
                            let imgRcet = CGRect(x: model.frame.maxX - 20, y: model.frame.maxY - 20, width: 20, height: 20)
                            UIImage(named: "label_select")?.draw(in: imgRcet)
                        }
                    } else {
                        let b = model.norBorderWidth / 2
                        let path = UIBezierPath(roundedRect: model.frame.insetBy(dx: b, dy: b), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: r, height: r))
                        ctx?.setLineWidth(model.norBorderWidth)
                        if model.isFillMode {
                            model.norFillColor.setStroke()
                            model.norFillColor.setFill()
                            ctx?.addPath(path.cgPath)
                            ctx?.strokePath()
                            ctx?.addPath(path.cgPath)
                            ctx?.fillPath()
                        } else {
                            model.norBorderColor.setStroke()
                            ctx?.addPath(path.cgPath)
                            ctx?.strokePath()
                        }
                        model.norAttriTitle?.draw(in: model.norTitleFrame)
                    }
                }
            }
        }
    }
    
    // 模拟touchUpInSide
    
    fileprivate var outOfRange = false
    fileprivate var touchModel: RectSelectFixSizeItem?
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
            if let item = item {
                if item.mutiMode {
                    if touchModel.isSelect {
                        touchModel.isSelect = !touchModel.isSelect
                        setNeedsDisplay()
                        respondChange()
                    } else {
                        if !reachLimit() {
                            touchModel.isSelect = !touchModel.isSelect
                            setNeedsDisplay()
                            respondChange()
                        } else {
                            respondLimit?()
                        }
                    }
                } else {
                    disSelectAll()
                    touchModel.isSelect = true
                    respondChange()
                }
            }
        }
    }
    
    func respondChange() {
        if let idxes = getSelectIdxes() {
            if let idx = getTouchIdx() {
                respondSelectChange?(idxes, idx)
            }
        }
    }
    
    func reachLimit() -> Bool {
        if let item = item {
            if let limit = item.selectLimit {
                let c = SafeUnwarp(getSelectIdxes()?.count, holderForNull: 0)
                if c >= limit {
                    return true
                }
            }
        }
        return false
    }
    
    func getTouchIdx() -> Int? {
        if let item = item {
            if let models = item.models {
                if let model = touchModel {
                   let idx =  (models as NSArray).index(of: model)
                    return idx
                }
            }
        }
        return nil
    }
    
    func getSelectIdxes() -> [Int]? {
        if let item = item {
            var idxes = [Int]()
            if let models = item.models {
                var idx: Int = 0
                for model in models {
                    if model.isSelect {
                        idxes.append(idx)
                    }
                    idx += 1
                }
            }
            return idxes
        }
        return nil
    }
    
}


/// RectSelect控件的配置item
class RectSelectFixSizeItem {
    
    // 业务
    var title: String?
    var isSelect: Bool = false
    
    // 样式
    var norTitleColor: UIColor = HEX("#666666")
    var selTitleColor: UIColor = HEX("#d61f26")
    
    var norTitleFontSize: CGFloat = 12 * kSizeRatio
    var selTitleFontSize: CGFloat = 12 * kSizeRatio
    
    var norBorderColor: UIColor = HEX("#a5abaf")
    var selBorderColor: UIColor = HEX("#d61f26")
    var norBorderWidth: CGFloat = 0.6
    var selBorderWidth: CGFloat = 0.6
    
    var cornerRadius: CGFloat = 2
    
    var size: CGSize = CGSize(width: 100, height: 30)
    var lrMinMargin: CGFloat = 3 // 左右间距
    
    var showCornerImage: Bool = true
    
    // 填充样式
    var isFillMode: Bool = true
    var norFillColor: UIColor = HEX("#f2f2f2")
    var selFillColor: UIColor = HEX("#f9e8dc")
    
    // 缓存属性
    fileprivate(set) var norTitleSize: CGSize = CGSize.zero
    fileprivate(set) var selTitleSize: CGSize = CGSize.zero
    fileprivate(set) var norAttriDic: [String: AnyObject]?
    fileprivate(set) var selAttriDic: [String: AnyObject]?
    fileprivate(set) var norAttriTitle: NSAttributedString?
    fileprivate(set) var selAttriTitle: NSAttributedString?
    
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
        if let norFontSize = StringTool.fitFontSize(title, fontSize: norTitleFontSize, toMeetWidth: size.width - lrMinMargin * 2) {
            norAttriDic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: norFontSize), color: norTitleColor)
            let norSizeAttriStr = StringTool.size(title, attriDic: norAttriDic)
            norAttriTitle = norSizeAttriStr.attriStr
            norTitleSize = norSizeAttriStr.size
        }
        if let selFontSize = StringTool.fitFontSize(title, fontSize: selTitleFontSize, toMeetWidth: size.width - lrMinMargin * 2) {
            selAttriDic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: selFontSize), color: selTitleColor)
            let selSizeAttriStr = StringTool.size(title, attriDic: selAttriDic)
            selAttriTitle = selSizeAttriStr.attriStr
            selTitleSize = selSizeAttriStr.size
        }
    }
    
}
