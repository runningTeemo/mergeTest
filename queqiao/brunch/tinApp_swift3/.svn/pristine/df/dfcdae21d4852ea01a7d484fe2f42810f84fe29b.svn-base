//
//  IndexViewSeeMoreFooterView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/10.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndexViewSeeMoreFooterView: UIView {
    
    var responder: (() -> ())?
    
    func show() {
        frame = CGRect(x: 0, y: 0, width: kScreenW, height: 55)
    }
    func hide() {
        frame = CGRect(x: 0, y: 0, width: kScreenW, height: 10)
    }
    
    lazy var btn: TitleButton = {
        let one = TitleButton()
        one.norBgColor = HEX("#f5f7f7")
        one.dowBgColor = kClrBackGray
        one.norTitlefont = UIFont.systemFont(ofSize: 12)
        one.dowTitlefont = UIFont.systemFont(ofSize: 12)
        one.norTitleColor = HEX("#999999")
        one.dowTitleColor = HEX("#999999")
        one.layer.cornerRadius = 5
        one.clipsToBounds = true
        one.title = "点击查看更多"
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.responder?()
        })
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(btn)
        btn.IN(self).LEFT(20).RIGHT(20).TOP(10).BOTTOM(10).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
