//
//  IndexViewNewsView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndexViewNewsView: ButtonBack {
    
    var news: [News] = [News]() {
        didSet {
            contentView.titleA = news.first?.title
            self.contentClipView.layoutIfNeeded()
            tryToPage()
            if news.count > 1 {
                remove()
                fire()
            }
        }
    }
    fileprivate(set) var currentIndex: Int = 0
    
    var viewHeight: CGFloat { return 45 }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        // 斜体
        let fontName = UIFont.systemFont(ofSize: 15).fontName
        let c = 15 * Float(M_PI) / 180
        let transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(c)), d: 1, tx: 0, ty: 0)
        let desc = UIFontDescriptor(name: fontName, matrix: transform)
        one.font = UIFont(descriptor: desc, size: 16)
        one.textColor = HEX("#d61f26")
        one.text = "投融动态"
        return one
    }()
    
    fileprivate var contentTopCons: NSLayoutConstraint!
    lazy var contentView: NewsContentView = {
        let one = NewsContentView()
        return one
    }()
    lazy var contentClipView: UIView = {
        let one = UIView()
        one.clipsToBounds = true
        one.backgroundColor = UIColor.clear
        one.addSubview(self.contentView)
        self.contentView.IN(one).LEFT.RIGHT.HEIGHT(50).MAKE()
        self.contentTopCons = self.contentView.TOP.EQUAL(one).MAKE()
        return one
    }()
    
    lazy var breakLine: UIView = NewBreakLine
    
    lazy var arrow: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconListMore")
        return one
    }()
    
    required init() {
        super.init()
        norBgColor = kClrWhite
        dowBgColor = kClrLightGray
        
        addSubview(titleLabel)
        addSubview(breakLine)
        addSubview(contentClipView)
        addSubview(arrow)
        titleLabel.IN(self).LEFT(10).WIDTH(65).CENTER.MAKE()
        breakLine.RIGHT(titleLabel).OFFSET(10).CENTER.SIZE(1, 12).MAKE()
        let contentClipW = kScreenW - 65 - 10 - 10 - 1 - 10 - 30 - 10
        contentClipView.RIGHT(breakLine).OFFSET(10).SIZE(contentClipW, 25).CENTER.MAKE()
        arrow.IN(self).RIGHT(15).CENTER.SIZE(15, 15).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var timer: QXTimer?
    func fire() {
        let timer = QXTimer(duration: 2)
        timer.loop = { [unowned self] t in
            self.timerLoop()
        }
        self.timer = timer
    }
    func timerLoop() {
        tryToPage()
    }
    func remove() {
        timer?.remove()
        timer = nil
    }
    
    /// 采用A,B两个页面来回切换的方式实现错觉轮播
    func tryToPage() {
        if news.count < 2 { return }
        if currentIndex == news.count - 1 {
            currentIndex = -1
            contentView.titleA = news.last!.title
            contentView.titleB = news.first!.title
        } else {
            contentView.titleA = news[currentIndex].title
            contentView.titleB = news[currentIndex + 1].title
        }
        UIView.animate(withDuration: 1, animations: { 
            self.contentTopCons.constant = -25
            self.contentClipView.layoutIfNeeded()
            }, completion: { (_) in
                let a = self.contentView.titleA
                self.contentView.titleA = self.contentView.titleB
                self.contentView.titleB = a
                self.contentTopCons.constant = 0
                self.contentClipView.layoutIfNeeded()
        }) 
        currentIndex += 1
    }
    
}

class NewsContentView: UIView {
    
    var titleA: String? {
        didSet {
            contentLabelA.text = titleA
        }
    }
    var titleB: String? {
        didSet {
            contentLabelB.text = titleB
        }
    }
    
    fileprivate lazy var contentLabelA: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.gray
        return one
    }()
    
    fileprivate lazy var contentLabelB: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.gray
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(contentLabelA)
        addSubview(contentLabelB)
        contentLabelA.IN(self).LEFT.RIGHT.TOP.MAKE()
        contentLabelA.HEIGHT.EQUAL(self).RATIO(0.5).MAKE()
        contentLabelB.IN(self).LEFT.RIGHT.BOTTOM.MAKE()
        contentLabelB.HEIGHT.EQUAL(self).RATIO(0.5).MAKE()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
