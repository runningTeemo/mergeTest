//
//  MyCareerInfoHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyCareerInfoHeadView: UIView {
    
    var respondInfo: (() -> ())?
    
    var user: User? {
        didSet {
            
            userIcon.iconView.fullPath = user?.avatar
            nameLabel.title = SafeUnwarp(user?.realName, holderForNull: "匿名用户")
            
            if let author = user?.author {
                switch author {
                case .not:
                    roleBtn.title = "未认证"
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
                roleBtn.isHidden = false
            } else {
                roleBtn.isHidden = true
                roleBtn.title = nil
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
        }
    }
    
    let imgH: CGFloat = 170
    
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
        return one
    }()
    
    lazy var nameLabel: TitleButton = {
        let one = TitleButton()
        one.norTitlefont = UIFont.systemFont(ofSize: 17)
        one.dowTitlefont = UIFont.systemFont(ofSize: 17)
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = kClrWhite
        one.dowTitleColor = kClrWhite
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondInfo?()
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
    
    lazy var labelDuty: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = UIFont.systemFont(ofSize: 13)
        return one
    }()
    lazy var labelPhone: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = UIFont.systemFont(ofSize: 13)
        return one
    }()
    
    lazy var basicInfoBtn: BorderButton = {
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
        one.title = "基本信息"
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondInfo?()
        })
        return one
    }()

    required init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = HEX("#3aaaf1")
        
        addSubview(backImageView)
        addSubview(userIcon)
        addSubview(nameLabel)
        addSubview(roleBtn)
        addSubview(labelDuty)
        addSubview(labelPhone)
        
        //addSubview(basicInfoBtn)
        
        backImageView.IN(self).LEFT.TOP(kScreenH).RIGHT.BOTTOM.MAKE()
        
        userIcon.IN(self).LEFT(25).BOTTOM(20).SIZE(70, 70).MAKE()
        nameLabel.RIGHT(userIcon).OFFSET(15).TOP.MAKE()
        roleBtn.RIGHT(nameLabel).OFFSET(10).CENTER.MAKE()
        roleBtn.RIGHT.LESS_THAN_OR_EQUAL(self).OFFSET(-12.5).MAKE()
        
        labelDuty.BOTTOM(nameLabel).OFFSET(8).LEFT.MAKE()
        labelDuty.RIGHT.LESS_THAN_OR_EQUAL(self).OFFSET(-12.5).MAKE()

        labelPhone.BOTTOM(labelDuty).OFFSET(8).LEFT.MAKE()
        labelPhone.RIGHT.LESS_THAN_OR_EQUAL(self).OFFSET(-12.5).MAKE()

        //basicInfoBtn.IN(self).RIGHT(12.5).BOTTOM(50).SIZE(80, 30).MAKE()
        //let maxTextWidth = kScreenW - 25 - 70 - 15 - 12.5 - 80 - 20
        //nameLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth - 10 - 15).MAKE()
        //labelDuty.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        //labelPhone.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
