//
//  CircleDetailHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CircleDetailHeadView: UIImageView {
    
    var model: Circle! {
        didSet {
            //nameLabel.text = SafeUnwarp(model.shortCnName, holderForNull: "匿名公司")
            //name1Label.text = SafeUnwarp(model.cnName, holderForNull: "匿名公司")
            //imageIcon.iconView.fullPath = model.logoUrl
        }
    }
    
    let imgH: CGFloat = 200
    let appendHeight: CGFloat = 1011
    
    var viewHeight: CGFloat { return appendHeight + imgH }
    
    lazy var imageIcon: RoundImageIcon = {
        let one = RoundImageIcon()
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
    
    lazy var possitonLabel: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(255, 255, 255, 153)
        one.font = UIFont.systemFont(ofSize: 12)
        return one
    }()
    
    lazy var segView: CircleDetailHeadSegView = {
        let one = CircleDetailHeadSegView()
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        image = UIImage(named: "myDetailImgIOS")
        isUserInteractionEnabled = true
        
        addSubview(imageIcon)
        addSubview(nameLabel)
        addSubview(name1Label)
        addSubview(possitonLabel)
        addSubview(segView)
        
        imageIcon.IN(self).LEFT(25).BOTTOM(70).SIZE(65, 65).MAKE()
        nameLabel.RIGHT(imageIcon).OFFSET(15).TOP(-10).MAKE()
        name1Label.BOTTOM(nameLabel).OFFSET(5).LEFT.MAKE()
        possitonLabel.BOTTOM(name1Label).OFFSET(3).LEFT.MAKE()
        
        let maxTextWidth = kScreenW - 25 - 70 - 15 - 12.5 - 64 - 20
        nameLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth - 10 - 15).MAKE()
        name1Label.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        possitonLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        
        segView.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(55).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CircleDetailHeadSegView: UIView {
    
    lazy var memberTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "成员"
        return one
    }()
    lazy var memberCount: UILabel = {
        let one = UILabel()
        one.font = kFontSubTitle
        one.textColor = kClrWhite
        one.text = "0"
        return one
    }()
    
    lazy var articlesTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "帖子"
        return one
    }()
    lazy var articlesCount: UILabel = {
        let one = UILabel()
        one.font = kFontSubTitle
        one.textColor = kClrWhite
        one.text = "0"
        return one
    }()
    
    lazy var attentionBg: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrBlue
        one.dowBgColor = UIColor.clear
        return one
    }()
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconLoveWhiteB")
        return one
    }()
    lazy var attentionLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "关注"
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(27, 36, 82, 76)
        addSubview(memberTitle)
        addSubview(memberCount)
        addSubview(articlesTitle)
        addSubview(articlesCount)
        addSubview(attentionBg)
        addSubview(iconView)
        addSubview(attentionLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

