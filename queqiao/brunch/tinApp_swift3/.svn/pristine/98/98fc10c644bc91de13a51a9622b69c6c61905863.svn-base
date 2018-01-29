//
//  InstitutionDetailHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionDetailHeadView: UIImageView {
    
    var model: InstitutionDataModel! {
        didSet {
            nameLabel.text = SafeUnwarp(model.shortCnName, holderForNull: "匿名公司")
            name1Label.text = SafeUnwarp(model.cnName, holderForNull: "匿名公司")
            imageIcon.fullPath = model.logoUrl
            segView.eventCount.text = SafeUnwarp(model.investmentCount, holderForNull:"0")
            segView.exsitCount.text = SafeUnwarp(model.exitCount, holderForNull: "0")
            followLabel.text = SafeUnwarp(model.followCount, holderForNull: "0")
        }
    }
    
    var respondCollect: (() -> ())?
    
    let imgH: CGFloat = 212 - 20
    let appendHeight: CGFloat = 1011
    
    var viewHeight: CGFloat { return appendHeight + imgH }
    
    lazy var imageIcon: RoundLogoView = {
        let one = RoundLogoView()
        one.defalutLogoImage = UIImage(named: "imgJG")
        return one
    }()
    
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 17)
        one.textColor = UIColor.white
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
    
    lazy var segView: InstitutionDetailSegView = {
        let one = InstitutionDetailSegView()
        return one
    }()
    
    lazy var attentionBtn: ImageFixButton = {
        let one = ImageFixButton()
        one.iconView.image = UIImage(named: "iconTzhyWhite")
        one.iconSize = CGSize(width: 20, height: 20)
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondCollect?()
            })
        return one
    }()
    //关注个数
    var followLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#FFFFFF")
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    func changeLikeImage(_ like:Bool){
        if like {
            attentionBtn.iconView.image = UIImage(named: "iconTzhyKeepSelect")
        }else{
            attentionBtn.iconView.image = UIImage(named: "iconTzhyWhite")
        }
    }
    func changeCollectionCount(collection:Bool,success:Bool){
        var  count = Tools.stringToInt(string: model.followCount)
        if success {
            if collection {
                count += 1
            }else{
                count -= 1
            }
        }else{
            if collection {
                count -= 1
            }else{
                count += 1
            }
        }
        if count < 0 {
            count = 0
        }
        model.followCount = "\(count)"
        followLabel.text = model.followCount
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        image = UIImage(named: "myDetailImgIOS")
        isUserInteractionEnabled = true
        
        addSubview(imageIcon)
        addSubview(nameLabel)
        addSubview(name1Label)
        addSubview(possitonLabel)
        addSubview(attentionBtn)
        addSubview(followLabel)
        addSubview(segView)
        
        imageIcon.IN(self).LEFT(25).BOTTOM(73).SIZE(66, 66).MAKE()
        nameLabel.RIGHT(imageIcon).OFFSET(15).TOP(-10).MAKE()
        name1Label.BOTTOM(nameLabel).OFFSET(5).LEFT.MAKE()
        possitonLabel.BOTTOM(name1Label).OFFSET(3).LEFT.MAKE()
        followLabel.BOTTOM(attentionBtn).CENTER.MAKE()
        followLabel.CENTER_Y.EQUAL(name1Label).MAKE()
        attentionBtn.IN(self).RIGHT(12.5).BOTTOM(90).SIZE(40, 40).MAKE()
        let maxTextWidth = kScreenW - 25 - 66 - 15 - 12.5 - 40
        nameLabel.WIDTH.EQUAL(maxTextWidth).MAKE()
        name1Label.WIDTH.EQUAL(maxTextWidth).MAKE()
        possitonLabel.WIDTH.EQUAL(maxTextWidth).MAKE()
        
        segView.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(55).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class InstitutionDetailSegView: UIView {
    
    var respondInvestEvents: (() -> ())?
    var respondExsitEvents: (() -> ())?
    var respondAnalyze: (() -> ())?

    lazy var eventTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "投资事件"
        one.textAlignment = .center
        return one
    }()
    lazy var eventCount: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "0"
        one.textAlignment = .center
        return one
    }()
    
    lazy var exsitTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "退出事件"
        one.textAlignment = .center
        return one
    }()
    lazy var exsitCount: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "0"
        one.textAlignment = .center
        return one
    }()
    
    lazy var analyseTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "投资分析"
        one.textAlignment = .center
        return one
    }()
    lazy var analyseIcon: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 18, height: 18)
        one.iconView.image = UIImage(named: "iconTZFX")
        one.isUserInteractionEnabled = false
        return one
    }()
    
    lazy var touchBg0: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrBlue
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondInvestEvents?()
        })
        return one
    }()
    lazy var touchBg1: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrBlue
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondExsitEvents?()
        })
        return one
    }()
    lazy var touchBg2: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrBlue
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondAnalyze?()
        })
        return one
    }()

    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(27, 36, 82, 76)
        addSubview(touchBg0)
        addSubview(touchBg1)
        addSubview(touchBg2)
        addSubview(eventTitle)
        addSubview(eventCount)
        addSubview(exsitTitle)
        addSubview(exsitCount)
        addSubview(analyseTitle)
        addSubview(analyseIcon)
        eventTitle.IN(self).LEFT.TOP(10).WIDTH(kScreenW / 3).MAKE()
        eventCount.IN(self).LEFT.BOTTOM(7).WIDTH(kScreenW / 3).MAKE()
        exsitTitle.IN(self).LEFT(kScreenW / 3).TOP(10).WIDTH(kScreenW / 3).MAKE()
        exsitCount.IN(self).LEFT(kScreenW / 3).BOTTOM(7).WIDTH(kScreenW / 3).MAKE()
        analyseTitle.IN(self).LEFT(kScreenW / 3 * 2).TOP(10).WIDTH(kScreenW / 3).MAKE()
        analyseIcon.IN(self).LEFT(kScreenW / 3 * 2).BOTTOM.WIDTH(kScreenW / 3).HEIGHT(35).MAKE()
        
        touchBg0.IN(self).LEFT.WIDTH(kScreenW / 3).TOP.BOTTOM.MAKE()
        touchBg1.IN(self).LEFT(kScreenW / 3).WIDTH(kScreenW / 3).TOP.BOTTOM.MAKE()
        touchBg2.IN(self).LEFT(kScreenW / 3 * 2).WIDTH(kScreenW / 3).TOP.BOTTOM.MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
