//
//  MeetingTagView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeetingTagView: UIView {
    
    var respondFilter: (() -> ())?
    var respondTag: ((_ tag: Int) -> ())?

    var viewHeight: CGFloat { return 45 }
    
    lazy var filterLabel: UILabel = {
        let one = UILabel()
        one.font = kFontNormal
        one.textColor = kClrDarkGray
        one.text = "筛选"
        return one
    }()
    lazy var filterIcon: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHyFilter")
        return one
    }()
    lazy var filterBreakLine = NewBreakLine
    lazy var filterBg: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrSlightGray
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondFilter?()
        })
        return one
    }()
    
    lazy var bottomBreakLine = NewBreakLine
    
    lazy var timeOrderLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        one.text = "时间排序"
        return one
    }()
    lazy var recommendLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        one.text = "推荐"
        return one
    }()
    lazy var hotLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        one.text = "热门"
        return one
    }()
    
    lazy var arrow1: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHySort")
        return one
    }()
    lazy var arrow2: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHySort")
        return one
    }()
    lazy var arrow3: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHySort")
        return one
    }()
    
    lazy var space1: UIView = {
        let one = UIView()
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var space2: UIView = {
        let one = UIView()
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    
    lazy var btn1: UIButton = {
        let one = UIButton()
        one.tag = 0
        one.addTarget(self, action: #selector(MeetingTagView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btn2: UIButton = {
        let one = UIButton()
        one.tag = 1
        one.addTarget(self, action: #selector(MeetingTagView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btn3: UIButton = {
        let one = UIButton()
        one.tag = 2
        one.addTarget(self, action: #selector(MeetingTagView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    fileprivate var myTag: Int = 0
    func btnClick(_ sender: UIButton) {
        chooseTag(sender.tag)
        if myTag != sender.tag {
            myTag = sender.tag
            respondTag?(sender.tag)
        }
    }
    
    func chooseTag(_ tag: Int) {
        timeOrderLabel.textColor = kClrDarkGray
        recommendLabel.textColor = kClrDarkGray
        hotLabel.textColor = kClrDarkGray
        arrow1.isHidden = true
        arrow2.isHidden = true
        arrow3.isHidden = true
        if tag == 0 {
            timeOrderLabel.textColor = kClrOrange
            arrow1.isHidden = false
        } else if tag == 1 {
            recommendLabel.textColor = kClrOrange
            arrow2.isHidden = false
        } else if tag == 2 {
            hotLabel.textColor = kClrOrange
            arrow3.isHidden = false
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        addSubview(bottomBreakLine)
        addSubview(filterBg)
        addSubview(filterLabel)
        addSubview(filterIcon)
        addSubview(filterBreakLine)
        bottomBreakLine.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(0.5).MAKE()
        filterBreakLine.IN(self).RIGHT(80).CENTER.SIZE(0.5, 15).MAKE()
        filterLabel.RIGHT(filterBreakLine).OFFSET(15).CENTER.MAKE()
        filterIcon.RIGHT(filterLabel).OFFSET(5).CENTER.SIZE(15, 15).MAKE()
        
        filterBg.LEFT.EQUAL(filterLabel).OFFSET(-5).MAKE()
        filterBg.TOP.EQUAL(filterLabel).OFFSET(-5).MAKE()
        filterBg.RIGHT.EQUAL(filterIcon).OFFSET(5).MAKE()
        filterBg.BOTTOM.EQUAL(filterLabel).OFFSET(5).MAKE()
        
        addSubview(timeOrderLabel)
        addSubview(arrow1)
        addSubview(space1)
        addSubview(recommendLabel)
        addSubview(arrow2)
        addSubview(space2)
        addSubview(hotLabel)
        addSubview(arrow3)
        
        timeOrderLabel.IN(self).LEFT(20).CENTER.MAKE()
        arrow1.RIGHT(timeOrderLabel).OFFSET(5).CENTER.SIZE(15, 15).MAKE()
        space1.RIGHT(arrow1).CENTER.HEIGHT(1).MAKE()
        recommendLabel.RIGHT(space1).CENTER.MAKE()
        arrow2.RIGHT(recommendLabel).OFFSET(5).CENTER.SIZE(15, 15).MAKE()
        space2.RIGHT(arrow2).CENTER.HEIGHT(1).MAKE()
        hotLabel.RIGHT(space2).CENTER.MAKE()
        arrow3.RIGHT(hotLabel).OFFSET(5).CENTER.SIZE(15, 15).MAKE()
        var space : CGFloat = 40
        if kScreenW < 330 {
            space = 20
        }
        arrow3.RIGHT.EQUAL(filterBreakLine).LEFT.OFFSET(-space).MAKE()
        space1.WIDTH.EQUAL(space2).WIDTH.MAKE()
        
        addSubview(btn1)
        addSubview(btn2)
        addSubview(btn3)
        btn1.IN(timeOrderLabel).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        btn2.IN(recommendLabel).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        btn3.IN(hotLabel).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        chooseTag(0)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
