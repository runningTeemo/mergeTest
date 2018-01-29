//
//  QXTwoColLabelsView.swift
//  TwoColTextViewDemo
//
//  Created by Richard.q.x on 2016/11/15.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import UIKit

/// the number result in the number of reuseLabels created
let QXTwoColLabelsMaxCount: Int = 30

/// the base data entity
class QXTwoColLabel {
    
    var title: String?
    var content: String?
    var attributedContent: NSAttributedString?
    
    var responder: ((_ attachent: Any?) -> ())?
    
    var notDiv: Bool = false
    
    var attachment: Any?
    
    var titleAttriDic: [String: AnyObject] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: UIColor.black
    ]
    var contentAttriDic: [String: AnyObject] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: UIColor.gray
    ]
    
    func sizeAttri(maxWidth: CGFloat?) -> (size: CGSize, attri: NSAttributedString?) {
        if title == nil && content == nil {
            return (CGSize.zero, nil)
        }
        let mAttri = NSMutableAttributedString()
        if let title = title {
            let attri = NSAttributedString(string: title, attributes: titleAttriDic)
            mAttri.append(attri)
        }
        
        if let attributedContent = attributedContent {
            mAttri.append(attributedContent)
        } else {
            if let content = content {
                let attri = NSAttributedString(string: content, attributes: contentAttriDic)
                mAttri.append(attri)
            }
        }
        
        if let maxWidth = maxWidth {
            var size = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
            size = mAttri.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
            return (size, mAttri)
        } else {
            var size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            size = mAttri.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
            return (size, mAttri)
        }
    }
    
}

/// the viewModel
class QXTwoColLabelsItem {
    
    var labels: [QXTwoColLabel]? {
        didSet {
            update()
        }
    }
    
    var topMargin: CGFloat = 0
    var bottomMargin: CGFloat = 0
    var leftMargin: CGFloat = 0
    var rightMargin: CGFloat = 0
    var colMargin: CGFloat = 20
    var rowMargin: CGFloat = 10
    var totalWidth: CGFloat = UIScreen.main.bounds.width
    
    var crossLineContentAlignTitle: Bool = true
    
    private(set) var viewHeight: CGFloat = 0
    private(set) var attriFrames = [(attri: NSAttributedString?, frame: CGRect)]()
    func update() {
        
        attriFrames.removeAll()
        
        if let labels = labels {
            
            let divMaxWidth: CGFloat = (totalWidth - leftMargin - colMargin - rightMargin) / 2
            let notDivWidth: CGFloat = totalWidth - leftMargin - rightMargin
            var anchorX: CGFloat = leftMargin
            var anchorY: CGFloat = topMargin
            var isLeft: Bool = true
            var line: Int = 0
            var lastLabelInfo: (height: CGFloat, line: Int)!
            
            for i in 0..<labels.count {
                
                let label = labels[i]
                
                let sizeAttri = label.sizeAttri(maxWidth: notDivWidth)
                
                // div
                if sizeAttri.size.width <= divMaxWidth && !label.notDiv  {
                    let frame = CGRect(x: anchorX, y: anchorY, width: sizeAttri.size.width, height: sizeAttri.size.height)
                    let attriFrame = (sizeAttri.attri, frame)
                    attriFrames.append(attriFrame)
                    if isLeft {
                        anchorX += divMaxWidth + colMargin
                        isLeft = false
                        lastLabelInfo = (sizeAttri.size.height, line)
                    } else {
                        anchorX = leftMargin
                        if lastLabelInfo.line == line {
                            anchorY += max(lastLabelInfo.height, sizeAttri.size.height) + rowMargin
                        } else {
                            anchorY += sizeAttri.size.height + rowMargin
                        }
                        lastLabelInfo = (sizeAttri.size.height, line)
                        line += 1
                        isLeft = true
                    }
                    
                    // not div
                } else {
                    anchorX = leftMargin
                    if isLeft {
                        let frame = CGRect(x: anchorX, y: anchorY, width: sizeAttri.size.width, height: sizeAttri.size.height)
                        let attriFrame = (sizeAttri.attri, frame)
                        attriFrames.append(attriFrame)
                    } else {
                        anchorY += sizeAttri.size.height + rowMargin
                        line += 1
                        let frame = CGRect(x: anchorX, y: anchorY, width: sizeAttri.size.width, height: sizeAttri.size.height)
                        let attriFrame = (sizeAttri.attri, frame)
                        attriFrames.append(attriFrame)
                    }
                    anchorY += sizeAttri.size.height + rowMargin
                    line += 1
                    isLeft = true
                }
                
            }
            
            if let frame = attriFrames.last?.frame {
                viewHeight = frame.maxY + bottomMargin
            } else {
                viewHeight = topMargin + bottomMargin
            }
            
        }
        
    }
    
}

/// the view
class QXTwoColLabelsView: UIView {
    
    var item: QXTwoColLabelsItem? {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
            layoutSubviews()
        }
    }
    
    lazy var labels: [QXTwoColTouchLabel] = {
        var one = [QXTwoColTouchLabel]()
        for i in 0..<QXTwoColLabelsMaxCount {
            let label = QXTwoColTouchLabel()
            label.tag = i
            one.append(label)
        }
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        for label in labels {
            addSubview(label)
        }
        backgroundColor = UIColor.yellow
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for label in labels {
            label.isHidden = true
        }
        if let item = item {
            for i in 0..<item.attriFrames.count {
                let label = labels[i]
                let attriFrame = item.attriFrames[i]
                label.isHidden = false
                label.attributedText = attriFrame.attri
                label.frame = attriFrame.frame
                label.model = item.labels?[i]
            }
        }
    }
    
}

class QXTwoColTouchLabel: UILabel {
    
    var model: QXTwoColLabel? {
        didSet {
            if let model = model {
                isUserInteractionEnabled = model.responder != nil
            }
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        numberOfLines = 0
        isUserInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 模拟touchUpInSide
    fileprivate var outOfRange = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        outOfRange = false
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if outOfRange {
            return
        }
        if let touch = touches.first {
            let point = touch.location(in: self)
            if !bounds.contains(point) {
                outOfRange = true
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if outOfRange {
            return
        }
        if let model = model {
            model.responder?(model.attachment)
        }
    }
    
}
