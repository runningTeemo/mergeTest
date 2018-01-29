//
//  UserDetailHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/14.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class UserDetailHeadView: UIImageView {
    
    var respondAdd: ((_ user: User) -> ())?
    var respondInfo: ((_ user: User) -> ())?
    var respondChat: ((_ user: User) -> ())?
    var respondOrganization: ((_ organization: Organization) -> ())?

    var respondTag: ((_ tag: Int) -> ())?
    
    var detail: UserDetail! {
        didSet {
            
            userIcon.iconView.fullPath = detail.user.avatar

            nameLabel.text = SafeUnwarp(detail.user.realName, holderForNull: "匿名用户")
            possitonLabel.text = SafeUnwarp(detail.user.duty, holderForNull: "匿名职位")
            
            do {
                let attriDic = [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                    NSForegroundColorAttributeName: HEX("#e6f0f8")
                ]
                let mAtt = NSMutableAttributedString()
                if detail.user.companyId != nil && detail.user.companyId != 0 {
                    let bounds = CGRect(x: 0, y: -1, width: 10, height: 10)
                    let img = AttributedStringTool.notNullAttributedImage(named: "relevance", bounds: bounds)
                    mAtt.append(img)
                    mAtt.append(NSAttributedString(string: " ", attributes: attriDic))
                }
                mAtt.append(NSAttributedString(string: SafeUnwarp(detail.user.company, holderForNull: "匿名公司"), attributes: attriDic))
                companyLabel.attributedText = mAtt
            }
            
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
            
            if detail.user.isMe() {
                handleBtn.title = "基本信息"
                handleBtn.isHidden = false
            } else {
                if let isFriend = detail.user.isFriend {
                    if isFriend {
                        handleBtn.title = "聊天"
                    } else {
                        handleBtn.title = "添加好友"
                    }
                    handleBtn.isHidden = false
                } else {
                    handleBtn.isHidden = true
                }
            }
        }
    }
    
    let imgH: CGFloat = 200
    let appendHeight: CGFloat = 1011
    
    var viewHeight: CGFloat { return appendHeight + imgH }
    
    lazy var userIcon: RoundUserIcon = {
        let one = RoundUserIcon()
        one.circleView.edgeWidth = 1
        return one
    }()
    
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 17)
        one.textColor = UIColor.white
        one.textAlignment = .center
        return one
    }()
    lazy var companyBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            if let name = self.detail!.user.company {
                if self.detail!.user.companyId != nil && self.detail!.user.companyId != 0 {
                    let organization = Organization()
                    organization.name = name
                    organization.type = self.detail!.user.companyType
                    organization.id = self.detail!.user.companyId
                    self.respondOrganization?(organization)
                }
            }
        })
        return one
    }()
    lazy var companyLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    
    lazy var possitonLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#e6f0f8")
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
            let detail = self.detail!
            if detail.user.isMe() {
                self.respondInfo?(detail.user)
            } else {
                if let isFriend = detail.user.isFriend {
                    if isFriend {
                        self.respondChat?(detail.user)
                    } else {
                        self.respondAdd?(detail.user)
                    }
                }
            }
            })
        return one
    }()
    
    lazy var segView: UserDetailSegView = {
        let one = UserDetailSegView()
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
        addSubview(companyBtn)
        
        userIcon.IN(self).LEFT(25).BOTTOM(70).SIZE(65, 65).MAKE()
        nameLabel.RIGHT(userIcon).OFFSET(15).TOP.MAKE()
        companyLabel.BOTTOM(nameLabel).OFFSET(8).LEFT.MAKE()
        possitonLabel.BOTTOM(companyLabel).OFFSET(3).LEFT.MAKE()
        
        handleBtn.IN(self).RIGHT(12.5).BOTTOM(90).SIZE(70, 30).MAKE()
        let maxTextWidth = kScreenW - 25 - 70 - 15 - 12.5 - 70 - 20
        nameLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth - 10 - 15).MAKE()
        companyLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        possitonLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        
        companyBtn.IN(companyLabel).LEFT(-5).RIGHT(-5).TOP(-5).BOTTOM(-5).MAKE()
        
        segView.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(55).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UserDetailSegView: UIView {
    
    var respondTag: ((_ tag: Int) -> ())?
    
    lazy var atriclesTitle: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "动态"
        return one
    }()
    lazy var articlesCount: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "0"
        return one
    }()
    
    lazy var attentionsTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "行业"
        return one
    }()
    lazy var attentionsCount: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
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
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "0"
        return one
    }()
    lazy var lineView: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#d61f26")
        return one
    }()
    
    lazy var btnBg0: UIButton = {
        let one = UIButton()
        one.tag = 0
        one.addTarget(self, action: #selector(UserDetailSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btnBg1: UIButton = {
        let one = UIButton()
        one.tag = 1
        one.addTarget(self, action: #selector(UserDetailSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btnBg2: UIButton = {
        let one = UIButton()
        one.tag = 2
        one.addTarget(self, action: #selector(UserDetailSegView.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    
    fileprivate(set) var idx: Int = 0
    func btnClick(_ sender: UIButton) {
        if idx == sender.tag { return }
        if sender.tag == 0 {
            lineView.REMOVE_CONSES()
            lineView.IN(btnBg0).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
            self.layoutIfNeeded()
            atriclesTitle.textColor = UIColor.white
            commentsTitle.textColor = RGBA(217, 217, 217, 255)
            attentionsTitle.textColor = RGBA(217, 217, 217, 255)

        } else if sender.tag == 1 {
            lineView.REMOVE_CONSES()
            lineView.IN(btnBg1).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
            self.layoutIfNeeded()
            atriclesTitle.textColor = RGBA(217, 217, 217, 255)
            commentsTitle.textColor = UIColor.white
            attentionsTitle.textColor = RGBA(217, 217, 217, 255)
        } else {
            lineView.REMOVE_CONSES()
            lineView.IN(btnBg2).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
            self.layoutIfNeeded()
            atriclesTitle.textColor = RGBA(217, 217, 217, 255)
            commentsTitle.textColor = RGBA(217, 217, 217, 255)
            attentionsTitle.textColor = UIColor.white
        }
        idx = sender.tag
        respondTag?(idx)
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(27, 36, 82, 76)
        addSubview(atriclesTitle)
        addSubview(articlesCount)
        addSubview(commentsTitle)
        addSubview(commentsCount)
        addSubview(attentionsTitle)
        addSubview(attentionsCount)
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

        commentsCount.CENTER_Y.EQUAL(btnBg1).OFFSET(8).MAKE()
        commentsCount.CENTER_X.EQUAL(btnBg1).MAKE()
        attentionsCount.CENTER_Y.EQUAL(btnBg2).OFFSET(8).MAKE()
        attentionsCount.CENTER_X.EQUAL(btnBg2).MAKE()
        
        atriclesTitle.CENTER_X.EQUAL(btnBg0).MAKE()
        commentsTitle.CENTER_X.EQUAL(btnBg1).MAKE()
        attentionsTitle.CENTER_X.EQUAL(btnBg2).MAKE()

        atriclesTitle.TOP.EQUAL(btnBg0).OFFSET(10).MAKE()
        commentsTitle.TOP.EQUAL(btnBg0).OFFSET(10).MAKE()
        attentionsTitle.TOP.EQUAL(btnBg0).OFFSET(10).MAKE()
        
        lineView.IN(btnBg0).BOTTOM.CENTER.SIZE((kScreenW / 3) - 40, 2).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
