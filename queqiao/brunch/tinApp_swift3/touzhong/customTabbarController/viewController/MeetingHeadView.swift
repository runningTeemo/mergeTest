//
//  MeetingHeadView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeetingHeadView: UIView {
    
    var viewHeight: CGFloat {
        return bannerView.viewHeight + 10 + tinMeettingView.viewHeight + 10 + tagView.viewHeight
    }
    lazy var bannerView: MeetingBannerView = {
        let one = MeetingBannerView()
        return one
    }()
    lazy var tinMeettingView: TouInMeetingNewsView = {
        let one = TouInMeetingNewsView()
        one.label1.text = ""
        one.label2.text = ""
        return one
    }()
    lazy var tagView: MeetingTagView = {
        let one = MeetingTagView()
        one.btn3.isHidden = true
        one.hotLabel.isHidden = true
        one.arrow3.isHidden = true
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrBackGray
        addSubview(bannerView)
        addSubview(tinMeettingView)
        addSubview(tagView)
        bannerView.IN(self).LEFT.TOP.SIZE(kScreenW, bannerView.viewHeight).MAKE()
        tinMeettingView.BOTTOM(bannerView).OFFSET(10).LEFT.RIGHT.HEIGHT(tinMeettingView.viewHeight).MAKE()
        tagView.BOTTOM(tinMeettingView).OFFSET(10).LEFT.RIGHT.HEIGHT(tagView.viewHeight).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
