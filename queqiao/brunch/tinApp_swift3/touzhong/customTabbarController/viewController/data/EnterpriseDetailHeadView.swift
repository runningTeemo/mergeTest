//
//  EnterpriseDetailHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class EnterpriseDetailHeadView: UIImageView {
    
    var model: EnterpriseDataModel! {
        didSet {
            nameLabel.text = SafeUnwarp(model.shortCnName, holderForNull: "匿名公司")
            name1Label.text = SafeUnwarp(model.cnName, holderForNull: "匿名公司")
            imageIcon.fullPath = model.logoUrl
            if let countStr = model.followCount {
                let countNSStr = countStr as NSString
                let count = countNSStr.integerValue
                if count>999 {
                    followLabel.text = "999+"
                }else{
                    followLabel.text = "\(count)"
                }
            }
            if model.list == "0" {
               listLabel.isHidden = true
            }else{
               listLabel.isHidden = false
                listLabel.text = "上市"
            }
        }
    }
    var respondCollect: (() -> ())?
    var attentionViewModel:AttentionViewModel = AttentionViewModel(){
        didSet{
           // print(attentionViewModel.model?.interest)
            attentionBtn.forceDown(false)
            changeLikeImage((attentionViewModel.model?.interest)!)
        }
    }
    
    let imgH: CGFloat = 212 - 55
    let appendHeight: CGFloat = 1011
    
    var viewHeight: CGFloat { return appendHeight + imgH }
    
    lazy var imageIcon: RoundLogoView = {
        let one = RoundLogoView()
        one.defalutLogoImage = UIImage(named: "imgQY")
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
    
//    lazy var segView: EnterpriseDetailSegView = {
//        let one = EnterpriseDetailSegView()
//        return one
//    }()
    
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
    //是否上市
    var listLabel:UILabel = {
       let label = UILabel()
        label.backgroundColor = mainBlueColor
        label.textColor = MyColor.colorWithHexString("#FFFFFF")
        label.font = UIFont.systemFont(ofSize: 9)
        label.layer.cornerRadius = 12.5
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = MyColor.colorWithHexString("#FFFFFF").cgColor
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
      //  addSubview(segView)
        addSubview(listLabel)
        addSubview(followLabel)
        
        _=imageIcon.IN(self).LEFT(25).BOTTOM(73 - 55).SIZE(66, 66).MAKE()
        _=nameLabel.RIGHT(imageIcon).OFFSET(15).TOP(-10).MAKE()
        _=name1Label.BOTTOM(nameLabel).OFFSET(5).LEFT.MAKE()
        _=possitonLabel.BOTTOM(name1Label).OFFSET(3).LEFT.MAKE()
        _=attentionBtn.IN(self).RIGHT(12.5).SIZE(40, 40).MAKE()
        _=attentionBtn.CENTER_Y.EQUAL(nameLabel).MAKE()
        let maxTextWidth = kScreenW - 25 - 66 - 15 - 12.5 - 40
        _=nameLabel.WIDTH.EQUAL(maxTextWidth).MAKE()
        _=name1Label.WIDTH.EQUAL(maxTextWidth).MAKE()
        _=possitonLabel.WIDTH.EQUAL(maxTextWidth).MAKE()
        _=followLabel.BOTTOM(attentionBtn).CENTER.MAKE()
        _=followLabel.CENTER_Y.EQUAL(name1Label).MAKE()
        let offsetX:CGFloat = CGFloat(33*sqrt(2)/2)
        _=listLabel.CENTER_X.EQUAL(imageIcon).CENTER_X.OFFSET(offsetX).MAKE()
        _=listLabel.CENTER_Y.EQUAL(imageIcon).CENTER_Y.OFFSET(offsetX).MAKE()
        _=listLabel.WIDTH.EQUAL(25).MAKE()
        _=listLabel.HEIGHT.EQUAL(25).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class EnterpriseDetailSegView: UIView {
    
    var respondTag: ((_ tag: Int) -> ())?
    
//    lazy var viewTitle: UILabel = {
//        let one = UILabel()
//        one.textColor = RGBA(217, 217, 217, 255)
//        one.font = UIFont.systemFont(ofSize: 11)
//        one.text = "浏览"
//        one.textAlignment = .center
//        return one
//    }()
//    lazy var viewCount: UILabel = {
//        let one = UILabel()
//        one.font = UIFont.systemFont(ofSize: 16)
//        one.textColor = kClrWhite
//        one.text = "0"
//        one.textAlignment = .center
//        return one
//    }()
    
    lazy var attentionsTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 11)
        one.text = "关注"
        one.textAlignment = .center
        return one
    }()
    lazy var attentionsCount: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 16)
        one.textColor = kClrWhite
        one.text = "0"
        one.textAlignment = .center
        return one
    }()
    
    lazy var typeTitle: UILabel = {
        let one = UILabel()
        one.textColor = RGBA(217, 217, 217, 255)
        one.font = UIFont.systemFont(ofSize: 15)
        one.text = "-"
        one.textAlignment = .center
        one.backgroundColor = mainBlueColor
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = RGBA(27, 36, 82, 76)
//        addSubview(viewTitle)
//        addSubview(viewCount)
        addSubview(attentionsTitle)
        addSubview(attentionsCount)
        addSubview(typeTitle)
        attentionsTitle.IN(self).LEFT.TOP(10).WIDTH(kScreenW / 3 * 2).MAKE()
        attentionsCount.IN(self).LEFT.BOTTOM(7).WIDTH(kScreenW / 3 * 2).MAKE()
//        attentionsTitle.IN(self).LEFT(kScreenW / 3).TOP(10).WIDTH(kScreenW / 3).MAKE()
//        attentionsCount.IN(self).LEFT(kScreenW / 3).BOTTOM(7).WIDTH(kScreenW / 3).MAKE()
        typeTitle.IN(self).LEFT(kScreenW / 3 * 2).BOTTOM.WIDTH(kScreenW / 3).TOP.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

