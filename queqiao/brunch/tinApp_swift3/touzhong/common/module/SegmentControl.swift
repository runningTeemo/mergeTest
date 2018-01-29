//
//  SegmentControl.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

///// 左右分栏控件
//class SegmentControl: UIControl {
//    
//    /// 分段切换的反馈闭包
//    var respondSelect: ((idx: Int) -> ())?
//    
//    // 样式修改
//    var norTitleFont: UIFont = UIFont.systemFontOfSize(16)
//    var selTitleFont: UIFont = UIFont.systemFontOfSize(16)
//
//    var norTitleColor: UIColor = UIColor.grayColor()
//    var selTitleColor: UIColor = UIColor.orangeColor()
//    
//    var lineHeight: CGFloat = 3
//    var lineMargin: CGFloat = 1
//    
//    var norLineColor: UIColor = UIColor.grayColor()
//    var selLineColor: UIColor = UIColor.orangeColor()
//    
//    /// 更改样式后必须调用这个方法才能更新
//    func update() {
//        var i: Int = 0
//        for btn in btns {
//            btn.norTitlefont = norTitleFont
//            btn.dowTitlefont = selTitleFont
//            btn.norTitleColor = norTitleColor
//            btn.dowTitleColor = selTitleColor
//            btn.forceDown(i == selectIdx)
//            i += 1
//        }
//        i = 0
//        for line in lines {
//            if i != selectIdx {
//                line.backgroundColor = norLineColor
//            } else {
//                line.backgroundColor = selLineColor
//            }
//            i += 1
//        }
//        setNeedsLayout()
//        setNeedsDisplay()
//    }
//    
//    private var btns: [TitleButton]
//    private var lines: [UIView]
//    private var selectIdx: Int = 0
//    
//    /// 构造方法，title的个数决定有几个分段
//    required init(titles: String...) {
//        var btns = [TitleButton]()
//        var tag: Int = 0
//        for title in titles {
//            let btn = TitleButton()
//            btn.title = title
//            btn.norTitlefont = norTitleFont
//            btn.dowTitlefont = selTitleFont
//            btn.norTitleColor = norTitleColor
//            btn.dowTitleColor = selTitleColor
//            btn.norBgColor = UIColor.clearColor()
//            btn.dowBgColor = UIColor.clearColor()
//            btn.tag = tag
//            btns.append(btn)
//            tag += 1
//        }
//        self.btns = btns
//        
//        var lines = [UIView]()
//        for _ in 0..<titles.count {
//            let line = UIView()
//            line.backgroundColor = norLineColor
//            lines.append(line)
//        }
//        self.lines = lines
//        
//        super.init(frame: CGRectZero)
//        for btn in self.btns {
//            btn.addTarget(self, action: #selector(SegmentControl.btnClick(_:)), forControlEvents: .TouchUpInside)
//            addSubview(btn)
//        }
//        for line in lines {
//            addSubview(line)
//        }
//        backgroundColor = UIColor.whiteColor()
//        update()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func btnClick(btn: TitleButton) {
//        selectIdx = btn.tag
//        update()
//        respondSelect?(idx: selectIdx)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if btns.count <= 0 { return }
//        
//        let w = bounds.size.width
//        let h = bounds.size.height
//        let btnW = w / CGFloat(btns.count)
//        let lineW = (w - lineMargin * CGFloat(lines.count - 1)) / CGFloat(lines.count)
//        
//        var btnX: CGFloat = 0
//        var lineX: CGFloat = 0
//        for i in 0..<btns.count {
//            let btn = btns[i]
//            let line = lines[i]
//            btn.frame = CGRectMake(btnX, 0, btnW, h)
//            line.frame = CGRectMake(lineX, h - lineHeight, lineW, lineHeight)
//            btnX += btnW
//            lineX += lineW + lineMargin
//        }
//    }
//    
//}


/// 左右分栏控件(下面是一条线)
class SegmentControl: UIControl {
    
    /// 分段切换的反馈闭包
    var respondSelect: ((_ idx: Int) -> ())?
    
    // 样式修改
    var norTitleFont: UIFont = UIFont.systemFont(ofSize: 15)
    var selTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 15)
    
    var norTitleColor: UIColor = HEX("#666666")
    var selTitleColor: UIColor = HEX("#333333")
    
    var lineHeight: CGFloat = 1
    var lineColor: UIColor = HEX("#e1e1e1")
    
    var selLineHeight: CGFloat = 2
    var selLineColor: UIColor = kClrOrange
    
    /// 更改样式后必须调用这个方法才能更新
    func update() {
        var i: Int = 0
        for btn in btns {
            btn.norTitlefont = norTitleFont
            btn.dowTitlefont = selTitleFont
            btn.norTitleColor = norTitleColor
            btn.dowTitleColor = selTitleColor
            btn.forceDown(i == selectIdx)
            i += 1
        }
        line.backgroundColor = lineColor
        selLine.backgroundColor = selLineColor
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    fileprivate var btns: [TitleButton]
    lazy var line: UIView = {
        let one = UIView()
        return one
    }()
    lazy var selLine: UIView = {
        let one = UIView()
        return one
    }()
    
    var selectIdx: Int = 0
    
    /// 构造方法，title的个数决定有几个分段
    required init(titles: String...) {
        var btns = [TitleButton]()
        var tag: Int = 0
        for title in titles {
            let btn = TitleButton()
            btn.animate = false
            btn.title = title
            btn.norTitlefont = norTitleFont
            btn.dowTitlefont = selTitleFont
            btn.norTitleColor = norTitleColor
            btn.dowTitleColor = selTitleColor
            btn.norBgColor = UIColor.clear
            btn.dowBgColor = UIColor.clear
            btn.tag = tag
            btns.append(btn)
            tag += 1
        }
        self.btns = btns
        
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        for btn in self.btns {
            btn.addTarget(self, action: #selector(SegmentControl.btnClick(_:)), for: .touchUpInside)
            addSubview(btn)
        }
        addSubview(line)
        addSubview(selLine)
        update()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnClick(_ btn: TitleButton) {
        selectIdx = btn.tag
        UIView.animate(withDuration: 0.3, animations: {
            self.update()
        }) 
        respondSelect?(selectIdx)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if btns.count <= 0 { return }
        
        let w = bounds.size.width
        let h = bounds.size.height
        let btnW = w / CGFloat(btns.count)
        
        
        var btnX: CGFloat = 0
        for i in 0..<btns.count {
            let btn = btns[i]
            btn.frame = CGRect(x: btnX, y: 0, width: btnW, height: h)
            btnX += btnW
        }
        line.frame = CGRect(x: 0, y: h - lineHeight, width: w, height: lineHeight)
        
        let selX = btnW * CGFloat(selectIdx) + 15
        let selW = btnW - 15 * 2
        selLine.frame = CGRect(x: selX, y: h - selLineHeight, width: selW, height: selLineHeight)
    }
    
}

/// 左右分栏控件(dot样式)
class SegmentDotControl: UIControl {
    
    /// 分段切换的反馈闭包
    var respondSelect: ((_ idx: Int) -> ())?
    
    // 样式修改
    var norTitleFont: UIFont = UIFont.systemFont(ofSize: 20)
    var selTitleFont: UIFont = UIFont.systemFont(ofSize: 20)
    
    var norTitleColor: UIColor = HEX("#bdbdbd")
    var selTitleColor: UIColor = HEX("#d61f26")
    
    var lineHeight: CGFloat = 1
    var lineColor: UIColor = HEX("#c6c6c6")
    
    var dotSize: CGFloat = 15
    
    /// 更改样式后必须调用这个方法才能更新
    func update() {
        var i: Int = 0
        for btn in btns {
            btn.norTitlefont = norTitleFont
            btn.dowTitlefont = selTitleFont
            btn.norTitleColor = norTitleColor
            btn.dowTitleColor = selTitleColor
            btn.forceDown(i == selectIdx)
            i += 1
        }
        line.backgroundColor = lineColor
        
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    fileprivate var btns: [TitleButton]
    lazy var line: UIView = {
        let one = UIView()
        return one
    }()
    lazy var dot: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "loginTabSelect")
        return one
    }()
    var selectIdx: Int = 0 {
        didSet {
            update()
        }
    }
    
    /// 构造方法，title的个数决定有几个分段
    required init(titles: String...) {
        var btns = [TitleButton]()
        var tag: Int = 0
        for title in titles {
            let btn = TitleButton()
            btn.animate = false
            btn.title = title
            btn.norTitlefont = norTitleFont
            btn.dowTitlefont = selTitleFont
            btn.norTitleColor = norTitleColor
            btn.dowTitleColor = selTitleColor
            btn.norBgColor = UIColor.clear
            btn.dowBgColor = UIColor.clear
            btn.tag = tag
            btns.append(btn)
            tag += 1
        }
        self.btns = btns
        super.init(frame: CGRect.zero)
        for btn in self.btns {
            btn.addTarget(self, action: #selector(SegmentControl.btnClick(_:)), for: .touchUpInside)
            addSubview(btn)
        }
        addSubview(line)
        addSubview(dot)
        backgroundColor = UIColor.white
        update()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnClick(_ btn: TitleButton) {
        selectIdx = btn.tag
        respondSelect?(selectIdx)
        self.update()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if btns.count <= 0 { return }
        
        let w = bounds.size.width
        let h = bounds.size.height
        let btnW = w / CGFloat(btns.count)
        
        var btnX: CGFloat = 0
        for i in 0..<btns.count {
            let btn = btns[i]
            btn.frame = CGRect(x: btnX, y: 0, width: btnW, height: h)
            btnX += btnW
        }
        line.frame = CGRect(x: 0, y: h - lineHeight, width: w, height: lineHeight)
        
        let dotX = CGFloat(selectIdx) * btnW + btnW / 2 - dotSize / 2
        let dotY = line.frame.midY - dotSize / 2
        
        dot.frame = CGRect(x: dotX, y: dotY, width: dotSize, height: dotSize)
        
    }
    
}

