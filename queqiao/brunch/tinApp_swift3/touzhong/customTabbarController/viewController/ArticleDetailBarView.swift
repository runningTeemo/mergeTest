//
//  ArticleDetailBarView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class ArticleDetailBarView: UIView, UITextFieldDelegate {
    
    var item: IndustryArticleDetailItem! {
        didSet {
            let agree = SafeUnwarp(item.model.isAgree, holderForNull: false)
            self.setAgree(agree)
         //   self.shareButton.forceDown(item.model.shareInfo == nil)//
            self.shareButton.forceDown(false)//分享到自己的好友圈
            let show = ArticleDetailHelper.checkListShow(article: item.model)

            if show.agree {
                self.agreeLabel.text = nil
            } else {
                self.agreeLabel.text = "\(SafeUnwarp(item.model.agreeCount, holderForNull: 0))"
            }
            
        }
    }
    
    var respondToComment: (() -> ())?
    var respondShare: (() -> ())?
    var respondAgree: (() -> ())?
    var respondComment: ((_ text: String) -> ())?
    var respondBeginEdit: (() -> Bool)?
    
    func setAgree(_ a: Bool) {
        
        let show = ArticleDetailHelper.checkListShow(article: item.model)

        if show.agreeIsAttention {
            if a {
                agreeButton.iconView.image = UIImage(named: "followSelect")
            } else {
                agreeButton.iconView.image = UIImage(named: "follow")
            }
        } else {
            if a {
                agreeButton.iconView.image = UIImage(named: "iconLikeSelect")
            } else {
                agreeButton.iconView.image = UIImage(named: "iconLike")
            }
            
        }
    }
    
    var viewHeight: CGFloat { return 48 }
    
    lazy var commentField: NewsDetailCommentField = {
        let one = NewsDetailCommentField()
        one.textField.delegate = self
        return one
    }()
    
    lazy var agreeButton: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 18, height: 18)
        one.iconView.image = UIImage(named: "followSelect")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondAgree?()
        })
        return one
    }()
    lazy var agreeLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrOrange
        one.text = "0"
        one.font = UIFont.systemFont(ofSize: 16)
        return one
    }()
    
    lazy var shareButton: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 18, height: 18)
        one.iconView.image = UIImage(named: "iconShare")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondShare?()
        })
        return one
    }()
    
    lazy var lineView = NewBreakLine
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        addSubview(commentField)
        addSubview(shareButton)
        addSubview(agreeButton)
        addSubview(agreeLabel)

        addSubview(lineView)
        
        self.HEIGHT.EQUAL(self.viewHeight).MAKE()
        commentField.IN(self).LEFT(12.5).CENTER.MAKE()
        
        lineView.IN(self).LEFT.RIGHT.TOP.HEIGHT(0.5).MAKE()
        
        shareButton.IN(self).RIGHT.TOP.BOTTOM.WIDTH(50).MAKE()
        agreeButton.IN(self).TOP.BOTTOM.WIDTH(40).MAKE()
        
        agreeButton.LEFT.EQUAL(commentField).RIGHT.OFFSET(5).MAKE()
        agreeLabel.RIGHT(agreeButton).CENTER.OFFSET(-5).MAKE()
        agreeLabel.RIGHT.EQUAL(shareButton).LEFT.MAKE()

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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let respondBeginEdit = respondBeginEdit {
            return respondBeginEdit()
        }
        return true
    }
    
}

