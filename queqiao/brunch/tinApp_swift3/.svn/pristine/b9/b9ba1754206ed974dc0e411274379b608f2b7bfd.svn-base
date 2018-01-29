//
//  MeMainHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeMainHeadView: UIView {
    
    var respondInfo: (() -> ())?
    var respondAuthor: (() -> ())?
    var respondIndustry: (() -> ())?

    var isProfileComplete: Bool = false

    var user: User? {
        didSet {
            
            userIcon.iconView.fullPath = user?.avatar
            
            nameLabel.text = SafeUnwarp(user?.realName, holderForNull: "匿名用户")
            if let industry = user?.industry {
                labelIndustry.text = SafeUnwarp(industry.name, holderForNull: "匿名行业")
            } else {
                labelIndustry.text = "设置所属行业"
            }
            
            if let author = user?.author {
                switch author {
                case .not:
                    if isProfileComplete {
                        roleBtn.title = "去认证"
                    } else {
                        roleBtn.title = "完善资料"
                    }
                case .progressing:
                    if let name = TinSearch(code: user?.roleType, inKeys: kUserRoleTypeKeys)?.name {
                        roleBtn.title = "\(name)认证中"
                    } else {
                        roleBtn.title = "认证中"
                    }
                case .isAuthed:
                    if let name = TinSearch(code: user?.roleType, inKeys: kUserRoleTypeKeys)?.name {
                        roleBtn.title = name
                    } else {
                        roleBtn.title = "其他"
                    }
                case .failed:
                    if let name = TinSearch(code: user?.roleType, inKeys: kUserRoleTypeKeys)?.name {
                        roleBtn.title = "\(name)认证失败"
                    } else {
                        roleBtn.title = "认证失败"
                    }
                }
            } else {
                if isProfileComplete {
                    roleBtn.title = "去认证"
                } else {
                    roleBtn.title = "完善资料"
                }
            }
            
            labelDuty.text = SafeUnwarp(user?.position, holderForNull: "匿名职位")
            
            var m = "匿名电话"
            if let mobile = user?.mobile {
                if mobile.characters.count >= 11 {
                    let p = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 3))
                    let s = mobile.substring(from: mobile.characters.index(mobile.endIndex, offsetBy: -4))
                    m = p + "****" + s
                } else {
                    if mobile.characters.count > 0 {
                        m = mobile
                    }
                }
            }
            labelPhone.text = m
            
            roleBtnWidthCons.constant = roleBtn.intrinsicContentSize.width
            self.setNeedsLayout()
            self.layoutIfNeeded()
            a += 1
        }
    }
    
    var a = 1
    
    let imgH: CGFloat = 265 - 20
    
    var viewHeight: CGFloat { return kScreenH + imgH }
    
    lazy var backImageView: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "myTopImg")
        return one
    }()
    
    lazy var userIcon: RoundUserIcon = {
        let one = RoundUserIcon()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondInfo?()
        })
        one.circleView.edgeWidth = 2
        return one
    }()
    
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.boldSystemFont(ofSize: 16)
        one.textColor = UIColor.white
        one.textAlignment = .center
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    
    lazy var industryBtnBack: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondIndustry?()
            })
        return one
    }()

    lazy var roleBtn: BorderButton = {
        let one = BorderButton()
        one.isUserInteractionEnabled = false
        one.norBorderWidth = 0.3
        one.dowBorderWidth = 0.3
        one.norBorderColor = kClrWhite
        one.dowBorderColor = kClrWhite
        one.norTitlefont = UIFont.systemFont(ofSize: 10)
        one.dowTitlefont = UIFont.systemFont(ofSize: 10)
        one.norTitleColor = kClrWhite
        one.dowTitleColor = kClrWhite
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var nameBackView: UIView = {
        let one = UIView()
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    
    let capsuleHeight: CGFloat = 40
    let barFont: UIFont = UIFont.systemFont(ofSize: 13)
    let iconSize: CGSize = CGSize(width: 15, height: 15)
    
    lazy var capsuleView: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor(white: 1, alpha: 0.149)
        one.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        one.layer.borderWidth = 0.5
        one.layer.cornerRadius = self.capsuleHeight / 2
        one.clipsToBounds = true
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()

    lazy var iconPhone: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconMyTel")
        return one
    }()
    lazy var labelIndustry: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = self.barFont
        one.isUserInteractionEnabled = true
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    
    lazy var authorBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondAuthor?()
        })
        return one
    }()
    
    lazy var labelDuty: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = self.barFont
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var labelPhone: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = self.barFont
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var line1: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return one
    }()
    lazy var line2: UIView = {
        let one = UIView()
        one.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return one
    }()
    
    var roleBtnWidthCons: NSLayoutConstraint!
    required init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = HEX("#3aaaf1")
        addSubview(backImageView)
        addSubview(userIcon)
        
        addSubview(nameBackView)
        addSubview(nameLabel)
        addSubview(roleBtn)
        
        addSubview(capsuleView)
        addSubview(labelIndustry)
        addSubview(line1)
        addSubview(labelDuty)
        addSubview(line2)
        addSubview(iconPhone)
        addSubview(labelPhone)
        
        addSubview(authorBtn)
        addSubview(industryBtnBack)

        backImageView.IN(self).LEFT.TOP(kScreenH).RIGHT.BOTTOM.MAKE()
        
        var offsetY: CGFloat = kScreenH + 65 - 20
        userIcon.IN(self).TOP(offsetY).SIZE(90, 90).CENTER.MAKE()
        offsetY += 90 + 10
        nameBackView.IN(self).TOP(offsetY).CENTER.MAKE()
        nameLabel.IN(nameBackView).LEFT.TOP.BOTTOM.MAKE()
        roleBtn.IN(nameBackView).RIGHT.CENTER.MAKE()
        nameLabel.RIGHT.EQUAL(roleBtn).LEFT.OFFSET(-10).MAKE()
        
        industryBtnBack.LEFT.EQUAL(labelIndustry).MAKE()
        industryBtnBack.RIGHT.EQUAL(labelIndustry).MAKE()
        industryBtnBack.HEIGHT.EQUAL(40).MAKE()
        industryBtnBack.CENTER_Y.EQUAL(labelIndustry).MAKE()
        
        offsetY += 35
        capsuleView.IN(self).TOP(offsetY).CENTER.HEIGHT(capsuleHeight).MAKE()
        labelIndustry.IN(capsuleView).LEFT(capsuleHeight / 2).CENTER.MAKE()
        line1.RIGHT(labelIndustry).OFFSET(10).SIZE(1, 12).CENTER.MAKE()
        labelDuty.RIGHT(line1).OFFSET(10).HEIGHT(30).CENTER.MAKE()
        line2.RIGHT(labelDuty).OFFSET(10).SIZE(1, 12).CENTER.MAKE()
        iconPhone.RIGHT(line2).OFFSET(10).CENTER.SIZE(iconSize.width - 5, iconSize.height - 5).MAKE()
        labelPhone.RIGHT(iconPhone).OFFSET(5).CENTER.HEIGHT(30).MAKE()
        labelPhone.RIGHT.EQUAL(capsuleView).OFFSET(-capsuleHeight / 2).MAKE()
        
        authorBtn.LEFT.EQUAL(roleBtn).MAKE()
        authorBtn.RIGHT.EQUAL(roleBtn).MAKE()
        authorBtn.HEIGHT.EQUAL(40).MAKE()
        authorBtn.CENTER_Y.EQUAL(roleBtn).MAKE()
        
        roleBtnWidthCons = roleBtn.WIDTH.EQUAL(0).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
