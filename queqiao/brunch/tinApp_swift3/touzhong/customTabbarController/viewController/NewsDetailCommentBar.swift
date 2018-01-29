//
//  NewsDetailCommentBar.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsDetailCommentField: UIView {
    
    var viewHeight: CGFloat { return 32 }
    
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconNewsWrite")
        return one
    }()
    lazy var textField: UITextField = {
        let one = UITextField()
        one.placeholder = "写评论"
        one.tintColor = kClrDarkGray
        one.returnKeyType = .done
        one.enablesReturnKeyAutomatically = true
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
        layer.cornerRadius = 16
        layer.borderColor = kClrBreak.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
        
        addSubview(textField)
        addSubview(iconView)
        self.HEIGHT.EQUAL(self.viewHeight).MAKE()
        iconView.IN(self).LEFT(14).CENTER.SIZE(15, 15).MAKE()
        textField.IN(self).RIGHT(14).TOP.BOTTOM.MAKE()
        textField.LEFT.EQUAL(iconView).RIGHT.OFFSET(10).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NewsDetailCommentBar: UIView, UITextFieldDelegate {
    
    var respondToComment: (() -> ())?
    var respondCollect: (() -> ())?
    var respondComment: ((_ text: String) -> ())?
        
    func setCollect(_ b: Bool) {
        if b {
            collectButton.iconView.image = UIImage(named: "iconTzhyKeepSelect")
        } else {
            collectButton.iconView.image = UIImage(named: "iconTzhyKeep")
        }
    }
    
    func setCount(_ c: Int?) {
        if let c = c {
            commentLabel.text = "\(c)"
        } else {
            commentLabel.text = "0"
        }
    }
    
    var viewHeight: CGFloat { return 48 }

    lazy var commentField: NewsDetailCommentField = {
        let one = NewsDetailCommentField()
        one.textField.delegate = self
        return one
    }()
    
    lazy var commentIcon: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconNewsComment")
        return one
    }()
    lazy var commentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrOrange
        one.text = "0"
        one.font = UIFont.systemFont(ofSize: 16)
        return one
    }()
    lazy var commentBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondToComment?()
        })
        return one
    }()
    
    lazy var collectButton: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 18, height: 18)
        one.iconView.image = UIImage(named: "iconTzhyKeep")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondCollect?()
            })
        return one
    }()
    
    lazy var lineView = NewBreakLine
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        addSubview(commentField)
        addSubview(lineView)
        
        addSubview(commentIcon)
        addSubview(commentLabel)
        addSubview(commentBtn)
        
        addSubview(collectButton)
        self.HEIGHT.EQUAL(self.viewHeight).MAKE()
        commentField.IN(self).LEFT(12.5).RIGHT(130).CENTER.MAKE()
        
        lineView.IN(self).LEFT.RIGHT.TOP.HEIGHT(0.5).MAKE()
        
        collectButton.IN(self).RIGHT.TOP.BOTTOM.WIDTH(40).MAKE()
        commentIcon.RIGHT(commentField).OFFSET(14).CENTER.SIZE(18, 18).MAKE()
        commentLabel.RIGHT(commentIcon).OFFSET(6).CENTER.MAKE()
        commentLabel.RIGHT.LESS_THAN_OR_EQUAL(collectButton).LEFT.MAKE()
        
        commentBtn.LEFT.EQUAL(commentIcon).MAKE()
        commentBtn.RIGHT.EQUAL(commentLabel).MAKE()
        commentBtn.TOP.EQUAL(self).MAKE()
        commentBtn.BOTTOM.EQUAL(self).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if NotNullText(textField.text) {
            respondComment?(textField.text!)
        }
        return true
    }
    
}


class NewsCommentCommentBar: UIView, UITextFieldDelegate {
    
    var respondComment: ((_ text: String) -> ())?

    var viewHeight: CGFloat { return 48 }
    
    lazy var commentField: NewsDetailCommentField = {
        let one = NewsDetailCommentField()
        one.textField.delegate = self
        return one
    }()
    
    lazy var lineView = NewBreakLine
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        addSubview(commentField)
        addSubview(lineView)
        self.HEIGHT.EQUAL(self.viewHeight).MAKE()
        commentField.IN(self).LEFT(12.5).RIGHT(12.5).CENTER.MAKE()
        lineView.IN(self).LEFT.RIGHT.TOP.HEIGHT(0.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if NotNullText(textField.text) {
            respondComment?(textField.text!)
            return true
        }
        return false
    }
    
}

