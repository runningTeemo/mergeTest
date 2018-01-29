//
//  MyNewsHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class MyNewsHeadView: UIImageView {
    
    var respondAdd: ((_ user: User) -> ())?
    var respondUser: ((_ user: User) -> ())?
    var respondTag: ((_ tag: Int) -> ())?

    var detail: UserDetail! {
        didSet {
            nameLabel.text = SafeUnwarp(detail.user.nickName, holderForNull: "匿名用户")
            companyLabel.text = SafeUnwarp(detail.user.company, holderForNull: "匿名公司")
            possitonLabel.text = SafeUnwarp(detail.user.position, holderForNull: "匿名职位")
            segView.articlesCount.text = "0"
            segView.attentionsCount.text = "0"
            segView.commentsCount.text = "0"
            if let c = detail.articlesCount {
                segView.articlesCount.text = "\(c)"
            }
            if let c = detail.circlesCount {
                segView.attentionsCount.text = "\(c)"
            }
            if let c = detail?.commentsCount {
                segView.commentsCount.text = "\(c)"
            }
        }
    }
    
    let imgH: CGFloat = 200
    let appendHeight: CGFloat = 1011
    
    var viewHeight: CGFloat { return appendHeight + imgH }
    
    lazy var userIcon: RoundUserIcon = {
        let one = RoundUserIcon()
        return one
    }()
    
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 17)
        one.textColor = UIColor.white
        one.textAlignment = .center
        return one
    }()
    lazy var companyLabel: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(255, 255, 255, 153)
        one.font = UIFont.systemFont(ofSize: 12)
        return one
    }()
    
    lazy var possitonLabel: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(255, 255, 255, 153)
        one.font = UIFont.systemFont(ofSize: 12)
        return one
    }()
    
    lazy var handleBtn: BorderButton = {
        let one = BorderButton()
        one.norBorderColor = UIColor(white: 1, alpha: 0.3)
        one.dowBorderColor = UIColor(white: 1, alpha: 0.1)
        one.norBorderWidth = 0.5
        one.dowBorderWidth = 0.5
        one.norTitleColor = kClrWhite
        one.dowTitleColor = kClrWhite
        one.norBgColor = UIColor(white: 1, alpha: 0.149)
        one.dowBgColor = UIColor(white: 1, alpha: 0.1)
        one.norTitlefont = UIFont.systemFont(ofSize: 14)
        one.dowTitlefont = UIFont.systemFont(ofSize: 14)
        one.cornerRadius = 15
        one.title = "加好友"
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            //self.respondInfo?()
            })
        return one
    }()
    
    lazy var segView: MyNewsSegView = {
        let one = MyNewsSegView()
        one.respondTag = { [unowned self] tag in
            self.respondTag?(tag)
        }
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        image = UIImage(named: "myDetailImgIOS")
        isUserInteractionEnabled = true

        addSubview(userIcon)
        addSubview(nameLabel)
        addSubview(companyLabel)
        addSubview(possitonLabel)
        addSubview(handleBtn)
        addSubview(segView)
        
        userIcon.IN(self).LEFT(25).BOTTOM(70).SIZE(65, 65).MAKE()
        nameLabel.RIGHT(userIcon).OFFSET(15).TOP.MAKE()
        companyLabel.BOTTOM(nameLabel).OFFSET(8).LEFT.MAKE()
        possitonLabel.BOTTOM(companyLabel).OFFSET(3).LEFT.MAKE()
        
        handleBtn.IN(self).RIGHT(12.5).BOTTOM(90).SIZE(64, 30).MAKE()
        let maxTextWidth = kScreenW - 25 - 70 - 15 - 12.5 - 64 - 20
        nameLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth - 10 - 15).MAKE()
        companyLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        possitonLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        
        segView.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(55).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MyNewsSegView: UIView {
    
    var respondTag: ((_ tag: Int) -> ())?
    
    let countNorFont = UIFont.systemFont(ofSize: 16)
    let countSelFont = UIFont.systemFont(ofSize: 30)

    lazy var atriclesTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "动态"
        return one
    }()
    lazy var articlesCount: UILabel = {
        let one = UILabel()
        one.font = self.countSelFont
        one.textColor = kClrWhite
        one.text = "0"
        return one
    }()
    
    lazy var attentionsTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "关注行业"
        return one
    }()
    lazy var attentionsCount: UILabel = {
        let one = UILabel()
        one.font = self.countNorFont
        one.textColor = kClrWhite
        one.text = "0"
        return one
    }()
    
    lazy var commentsTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "评论"
        return one
    }()
    lazy var commentsCount: UILabel = {
        let one = UILabel()
        one.font = self.countNorFont
        one.textColor = kClrWhite
        one.text = "0"
        return one
    }()
    lazy var lineView: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#f75b49")
        return one
    }()
    
    lazy var btnBg0: UIButton = {
        let one = UIButton()
        one.tag = 0
        one.addTarget(self, action: #selector(MyNewsSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btnBg1: UIButton = {
        let one = UIButton()
        one.tag = 1
        one.addTarget(self, action: #selector(MyNewsSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btnBg2: UIButton = {
        let one = UIButton()
        one.tag = 2
        one.addTarget(self, action: #selector(MyNewsSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    
    fileprivate(set) var idx: Int = 0
    func btnClick(_ sender: UIButton) {
        if idx == sender.tag { return }
        if sender.tag == 0 {
            lineView.REMOVE_CONSES()
            lineView.IN(btnBg0).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
            articlesCount.font = countSelFont
            attentionsCount.font = countNorFont
            commentsCount.font = countNorFont
            atriclesTitleTopCons?.constant = 5
            attentionsTitleTopCons?.constant = 10
            commentsTitleTopCons?.constant = 10
            self.layoutIfNeeded()
        } else if sender.tag == 1 {
            lineView.REMOVE_CONSES()
            lineView.IN(btnBg1).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
            articlesCount.font = countNorFont
            attentionsCount.font = countSelFont
            commentsCount.font = countNorFont
            atriclesTitleTopCons?.constant = 10
            attentionsTitleTopCons?.constant = 5
            commentsTitleTopCons?.constant = 10
            self.layoutIfNeeded()
        } else {
            lineView.REMOVE_CONSES()
            lineView.IN(btnBg2).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
            articlesCount.font = countNorFont
            attentionsCount.font = countNorFont
            commentsCount.font = countSelFont
            atriclesTitleTopCons?.constant = 10
            attentionsTitleTopCons?.constant = 10
            commentsTitleTopCons?.constant = 5
            self.layoutIfNeeded()
        }
        idx = sender.tag
        respondTag?(idx)
    }
    
    fileprivate var atriclesTitleTopCons: NSLayoutConstraint?
    fileprivate var attentionsTitleTopCons: NSLayoutConstraint?
    fileprivate var commentsTitleTopCons: NSLayoutConstraint?
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(27, 36, 82, 76)
        addSubview(atriclesTitle)
        addSubview(articlesCount)
        addSubview(attentionsTitle)
        addSubview(attentionsCount)
        addSubview(commentsTitle)
        addSubview(commentsCount)
        addSubview(btnBg0)
        addSubview(btnBg1)
        addSubview(btnBg2)
        addSubview(lineView)
        
        btnBg0.IN(self).LEFT.TOP.BOTTOM.MAKE()
        btnBg1.IN(self).TOP.BOTTOM.MAKE()
        btnBg2.IN(self).RIGHT.TOP.BOTTOM.MAKE()
        btnBg1.LEFT.EQUAL(btnBg0).RIGHT.MAKE()
        btnBg1.RIGHT.EQUAL(btnBg2).LEFT.MAKE()
        btnBg0.WIDTH.EQUAL(btnBg1).MAKE()
        btnBg1.WIDTH.EQUAL(btnBg2).MAKE()
        
        articlesCount.CENTER_Y.EQUAL(btnBg0).OFFSET(8).MAKE()
        articlesCount.CENTER_X.EQUAL(btnBg0).MAKE()
        attentionsCount.CENTER_Y.EQUAL(btnBg1).OFFSET(8).MAKE()
        attentionsCount.CENTER_X.EQUAL(btnBg1).MAKE()
        commentsCount.CENTER_Y.EQUAL(btnBg2).OFFSET(8).MAKE()
        commentsCount.CENTER_X.EQUAL(btnBg2).MAKE()

        atriclesTitle.CENTER_X.EQUAL(btnBg0).MAKE()
        attentionsTitle.CENTER_X.EQUAL(btnBg1).MAKE()
        commentsTitle.CENTER_X.EQUAL(btnBg2).MAKE()

        atriclesTitleTopCons = atriclesTitle.TOP.EQUAL(btnBg0).OFFSET(5).MAKE()
        attentionsTitleTopCons = attentionsTitle.TOP.EQUAL(btnBg0).OFFSET(10).MAKE()
        commentsTitleTopCons = commentsTitle.TOP.EQUAL(btnBg0).OFFSET(10).MAKE()
        
        lineView.IN(btnBg0).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

