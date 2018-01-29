//
//  IndustryArticleHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndustryArticleHeadView: UIImageView {
    
    var model: Circle! {
        didSet {
            nameLabel.text = SafeUnwarp(model.industry.name, holderForNull: "匿名行业")
            //name1Label.text = SafeUnwarp(model.industry.cnName, holderForNull: "匿名公司")
            imageIcon.iconView.fullPath = model.industry.icon
            segView.memberCount.text = "\(SafeUnwarp(model.userCount, holderForNull: 0))"
            segView.articleCount.text = "\(SafeUnwarp(model.articleCount, holderForNull: 0))"
            
            if checkIsParty(industry: model.industry) {
                segView.handleBtn.forceDown(false)
                segView.handleTitle.text = "所属行业"
                
            } else {
                segView.handleBtn.forceDown(false)
                if let attention = model.isAttentioned {
                    if attention {
                        segView.handleTitle.text = "取消关注"
                    } else {
                        segView.handleTitle.text = "加关注"
                    }
                } else {
                    segView.handleBtn.forceDown(true)
                }
            }

        }
    }
    
    /// 检测是否为所属行业
    func checkIsParty(industry: Industry) -> Bool {
        if !Account.sharedOne.isLogin {
            return false
        }
        let me = Account.sharedOne.user
        if let _industry = me.industry {
            if _industry.id == industry.id {
                return true
            }
        }
        return false
    }
    
    var respondAttention: ((_ attention: Bool) -> ())?
    var respondParty: (() -> ())?
    
    let imgH: CGFloat = 200
    let appendHeight: CGFloat = 1011
    
    var viewHeight: CGFloat { return appendHeight + imgH }
    
    lazy var imageIcon: RoundImageIcon = {
        let one = RoundImageIcon()
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
    lazy var name1Label: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(255, 255, 255, 153)
        one.font = UIFont.systemFont(ofSize: 12)
        return one
    }()

    lazy var segView: IndustryArticleHeadSegView = {
        let one = IndustryArticleHeadSegView()
        one.respondAttention = { [unowned self] in
            self.handleAttention()
        }
        return one
    }()
    
    func handleAttention() {
        
        if checkIsParty(industry: model.industry) {
            respondParty?()
            
        } else {
            if let attention = model.isAttentioned {
                if attention {
                    respondAttention?(false)
                } else {
                    respondAttention?(true)
                }
            }
        }
    }

    required init() {
        super.init(frame: CGRect.zero)
        image = UIImage(named: "myDetailImgIOS")
        isUserInteractionEnabled = true
        
        addSubview(imageIcon)
        addSubview(nameLabel)
        addSubview(name1Label)
        addSubview(segView)
        
        imageIcon.IN(self).LEFT(25).BOTTOM(70).SIZE(65, 65).MAKE()
        nameLabel.RIGHT(imageIcon).OFFSET(15).TOP(-10).MAKE()
        name1Label.BOTTOM(nameLabel).OFFSET(5).LEFT.MAKE()
        
        let maxTextWidth = kScreenW - 25 - 70 - 15 - 12.5 - 64 - 20
        nameLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth - 10 - 15).MAKE()
        name1Label.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        
        segView.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(55).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class IndustryArticleHeadSegView: UIView {
    
    var respondMember: (() -> ())?
    var respondAttention: (() -> ())?

    lazy var memberTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "成员"
        one.textAlignment = .center
        return one
    }()
    lazy var memberCount: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "0"
        one.textAlignment = .center
        return one
    }()
    
    lazy var memberBtn: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrBlue
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondMember?()
        })
        return one
    }()
    
    lazy var articleTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "动态"
        one.textAlignment = .center
        return one
    }()
    lazy var articleCount: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "0"
        one.textAlignment = .center
        return one
    }()
    
    lazy var handleBtn: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrBlue
        one.dowBgColor = UIColor.clear
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondAttention?()
            })
        return one
    }()
    lazy var handleView: UIView = {
        let one = UIView()
        return one
    }()
    
    lazy var handleIcon: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconLoveWhiteB")
        return one
    }()
    
    lazy var handleTitle: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 15)
        one.text = "加关注"
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(27, 36, 82, 76)
        
        addSubview(memberBtn)
        addSubview(memberTitle)
        addSubview(memberCount)
        addSubview(articleTitle)
        addSubview(articleCount)
        
        addSubview(handleView)
        addSubview(handleBtn)
        addSubview(handleIcon)
        addSubview(handleTitle)

        articleTitle.IN(self).LEFT.TOP(10).WIDTH(kScreenW / 3).MAKE()
        articleCount.IN(self).LEFT.BOTTOM(7).WIDTH(kScreenW / 3).MAKE()
        memberTitle.IN(self).LEFT(kScreenW / 3).TOP(10).WIDTH(kScreenW / 3).MAKE()
        memberCount.IN(self).LEFT(kScreenW / 3).BOTTOM(7).WIDTH(kScreenW / 3).MAKE()
        memberBtn.IN(self).LEFT(kScreenW / 3).BOTTOM.TOP.WIDTH(kScreenW / 3).MAKE()
        handleBtn.IN(self).LEFT(kScreenW / 3 * 2).BOTTOM.WIDTH(kScreenW / 3).TOP.MAKE()
        
        handleView.IN(handleBtn).CENTER.TOP.BOTTOM.MAKE()
        handleIcon.IN(handleView).LEFT.CENTER.SIZE(18, 18).MAKE()
        handleTitle.IN(handleView).RIGHT.CENTER.MAKE()
        handleIcon.RIGHT.EQUAL(handleTitle).LEFT.OFFSET(-10).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

