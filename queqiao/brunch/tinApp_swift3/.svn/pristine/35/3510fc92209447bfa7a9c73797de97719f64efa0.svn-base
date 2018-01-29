//
//  ArticleDetailSegView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndustryArticleDetailSegView: UIView {
    
    var respondA: (() -> ())?
    var respondB: (() -> ())?
    
    func hideB(_ t: Bool) {
        bBgBtn.isHidden = t
        bSegLine.isHidden = t
        bCountlabel.isHidden = t
        bCountlabel.isHidden = t
        bTitlelabel.isHidden = t
        centerBreak.isHidden = t
    }
    
    var titleA: String? {
        didSet {
            aTitlelabel.text = titleA
        }
    }
    var titleB: String? {
        didSet {
            bTitlelabel.text = titleB
        }
    }
    var countA: Int? {
        didSet {
            aCountlabel.text = "\(SafeUnwarp(countA, holderForNull: 0))"
        }
    }
    var countB: Int? {
        didSet {
            bCountlabel.text = "\(SafeUnwarp(countB, holderForNull: 0))"
        }
    }
    var currentTag: Int = 0 {
        didSet {
            if currentTag == 0 {
                aTitlelabel.textColor = kClrDeepGray
                aCountlabel.textColor = kClrDeepGray
                bTitlelabel.textColor = kClrLightGray
                bCountlabel.textColor = kClrLightGray
                aSegLine.isHidden = false
                bSegLine.isHidden = true
            } else {
                aTitlelabel.textColor = kClrLightGray
                aCountlabel.textColor = kClrLightGray
                bTitlelabel.textColor = kClrDeepGray
                bCountlabel.textColor = kClrDeepGray
                aSegLine.isHidden = true
                bSegLine.isHidden = false
            }
        }
    }
    
    lazy var aTitlelabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrLightGray
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var aCountlabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrLightGray
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var aBgBtn: UIButton = {
        let one = UIButton()
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondA?()
            self.currentTag = 0
        })
        return one
    }()
    
    lazy var bTitlelabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrLightGray
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var bCountlabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrLightGray
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var bBgBtn: UIButton = {
        let one = UIButton()
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondB?()
            self.currentTag = 1
        })
        return one
    }()
    
    let centerBreak = NewBreakLine
    let bottomBreak = NewBreakLine
    
    lazy var aSegLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrOrange
        return one
    }()
    lazy var bSegLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrOrange
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = kClrWhite
        
        addSubview(aBgBtn)
        addSubview(bBgBtn)
        
        addSubview(aTitlelabel)
        addSubview(aCountlabel)
        addSubview(centerBreak)
        addSubview(bTitlelabel)
        addSubview(bCountlabel)
        addSubview(bottomBreak)
        
        addSubview(aSegLine)
        addSubview(bSegLine)
        
        aBgBtn.IN(self).LEFT(12.5).TOP.BOTTOM.MAKE()
        centerBreak.RIGHT(aBgBtn).OFFSET(10).CENTER.SIZE(0.5, 14).MAKE()
        bBgBtn.RIGHT(aBgBtn).OFFSET(25).TOP.BOTTOM.MAKE()
        
        aTitlelabel.IN(aBgBtn).LEFT.CENTER.MAKE()
        aCountlabel.RIGHT(aTitlelabel).OFFSET(5).CENTER.MAKE()
        aCountlabel.RIGHT.EQUAL(aBgBtn).MAKE()
        
        bTitlelabel.IN(bBgBtn).LEFT.CENTER.MAKE()
        bCountlabel.RIGHT(bTitlelabel).OFFSET(5).CENTER.MAKE()
        bCountlabel.RIGHT.EQUAL(bBgBtn).MAKE()
        
        bottomBreak.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(1).MAKE()
        
        aSegLine.IN(aBgBtn).BOTTOM.LEFT.RIGHT.HEIGHT(2).MAKE()
        bSegLine.IN(bBgBtn).BOTTOM.LEFT.RIGHT.HEIGHT(2).MAKE()
        
        currentTag = 0
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

