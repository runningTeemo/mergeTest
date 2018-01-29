//
//  PersonageDetailHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PersonageDetailHeadView: UIImageView {
    
    var model: PersonageDataModel! {
        didSet {
            nameLabel.text = SafeUnwarp(model.cnName, holderForNull: "") + "(" + SafeUnwarp(model.enName, holderForNull: "") + ")"
            //公司名
            name1Label.text = SafeUnwarp(model.companyName, holderForNull: "")
            //职位
            name2Label.text = SafeUnwarp(model.duties, holderForNull: "")
            imageIcon.iconView.fullPath = model.imgUrl
            followLabel.text = model.followCount
        }
    }
    
    var respondCollect: (() -> ())?
    
    let imgH: CGFloat = 160
    let appendHeight: CGFloat = 1011
    
    var viewHeight: CGFloat { return appendHeight + imgH }
    
    lazy var imageIcon: RoundUserIcon = {
        let one = RoundUserIcon()
        one.iconView.contentMode = UIViewContentMode.scaleAspectFill
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
    //关注个数
    var followLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = MyColor.colorWithHexString("#FFFFFF")
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    lazy var name2Label: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(255, 255, 255, 153)
        one.font = UIFont.systemFont(ofSize: 12)
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
        image = UIImage(named: "dataPeopleImg")
        isUserInteractionEnabled = true
        
        addSubview(imageIcon)
        addSubview(nameLabel)
        addSubview(name1Label)
        addSubview(name2Label)
        addSubview(attentionBtn)
        addSubview(followLabel)
        
        imageIcon.IN(self).LEFT(25).BOTTOM(20).SIZE(65, 65).MAKE()
        nameLabel.RIGHT(imageIcon).OFFSET(15).TOP(-5).MAKE()
        name1Label.BOTTOM(nameLabel).OFFSET(5).LEFT.MAKE()
        name2Label.BOTTOM(name1Label).OFFSET(3).LEFT.MAKE()
        
        attentionBtn.IN(self).RIGHT(12.5).BOTTOM(50).SIZE(40, 40).MAKE()
        let maxTextWidth = kScreenW - 25 - 66 - 15 - 12.5 - 40
      //  let maxTextWidth = kScreenW - 25 - 70 - 15 - 12.5 - 64 - 20
        nameLabel.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth - 10 - 15).MAKE()
        name1Label.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        name2Label.WIDTH.LESS_THAN_OR_EQUAL(maxTextWidth).MAKE()
        followLabel.BOTTOM(attentionBtn).CENTER.MAKE()
        followLabel.CENTER_Y.EQUAL(name1Label).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
