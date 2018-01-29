//
//  ToLoginView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ToLoginView: UIView {
    
    var respondLogin: (() -> ())?
    var respondRegist: (() -> ())?

    lazy var scrollView: UIScrollView = {
        let one = UIScrollView()
        one.showsVerticalScrollIndicator = false
        one.backgroundColor = UIColor.white
        one.alwaysBounceVertical = true
        return one
    }()
    
    lazy var imageView: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "loginTopImg")
        return one
    }()
    
    lazy var tipLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrLightGray
        one.font = kFontNormal
        one.textAlignment = .center
        one.text = "一键登录后，可以查看更多内容"
        return one
    }()
    
    lazy var registBtn: TitleButton = {
        let one = TitleButton()
        one.title = "注  册"
        one.cornerRadius = 5
        one.norTitleColor = UIColor.white
        one.dowTitleColor = UIColor.white
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondRegist?()
        })
        return one
    }()

    lazy var loginBtn: TitleButton = {
        let one = TitleButton()
        one.title = "登  录"
        one.norBgColor = kClrBackGray
        one.dowBgColor = kClrOrange
        one.norTitleColor = HEX("#666666")
        one.dowTitleColor = HEX("#666666")
        one.norBgColor = HEX("#e9e9e9")
        one.dowBgColor = HEX("#dcdcdc")
        one.cornerRadius = 5
        _=one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondLogin?()
        })
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(scrollView)
        scrollView.addSubview(tipLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(loginBtn)
        scrollView.addSubview(registBtn)
        
        _=scrollView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        var topMargin: CGFloat = 0
        let imgH = kScreenW * 362 / 750
        _=imageView.IN(scrollView).LEFT.TOP.SIZE(kScreenW, imgH).MAKE()
        topMargin += imgH
        _=tipLabel.IN(scrollView).LEFT(15).WIDTH(kScreenW - 15 * 2).TOP(topMargin).HEIGHT(100).MAKE()
        topMargin += 100
        _=registBtn.IN(scrollView).LEFT(15).WIDTH(kScreenW - 15 * 2).TOP(topMargin).HEIGHT(kSizBtnHeight).MAKE()
        
        _=loginBtn.BOTTOM(registBtn).LEFT.RIGHT.OFFSET(12.5).HEIGHT(kSizBtnHeight).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
