//
//  DataSummariseIndexView.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/4.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class DataSummariseIndexView: UIView {
    
    static let viewHeight: CGFloat = 33
    
    var respondIdx: ((_ idx: Int) -> ())?
    
    func setWeek() {
        weekLabel.textColor = HEX("#333333")
        monthLabel.textColor = HEX("#999999")
        yearLabel.textColor = HEX("#999999")
        weekArrow.isHidden = false
        monthArrow.isHidden = true
        yearArrow.isHidden = true
    }
    func setMonth() {
        weekLabel.textColor = HEX("#999999")
        monthLabel.textColor = HEX("#333333")
        yearLabel.textColor = HEX("#999999")
        weekArrow.isHidden = true
        monthArrow.isHidden = false
        yearArrow.isHidden = true
    }
    func setYear() {
        weekLabel.textColor = HEX("#999999")
        monthLabel.textColor = HEX("#999999")
        yearLabel.textColor = HEX("#333333")
        weekArrow.isHidden = true
        monthArrow.isHidden = true
        yearArrow.isHidden = false
    }
    
    lazy var weekBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.setWeek()
            self.respondIdx?(0)
        })
        return one
    }()
    lazy var monthBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.setMonth()
            self.respondIdx?(1)
        })
        return one
    }()
    lazy var yearBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.setYear()
            self.respondIdx?(2)
        })
        return one
    }()
    
    lazy var weekLabel: UILabel = {
        let one = UILabel()
        one.text = "近周"
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrWhite
        one.textAlignment = .center
        return one
    }()
    
    lazy var monthLabel: UILabel = {
        let one = UILabel()
        one.text = "近月"
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrWhite
        one.textAlignment = .center
        return one
    }()
    
    lazy var yearLabel: UILabel = {
        let one = UILabel()
        one.text = "近年"
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrWhite
        one.textAlignment = .center
        return one
    }()
    
    lazy var weekArrow: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "chartTopSelect")
        return one
    }()
    lazy var monthArrow: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "chartTopSelect")
        return one
    }()
    lazy var yearArrow: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "chartTopSelect")
        return one
    }()
    
    lazy var bottomShadow: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "chartTopShadow")
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = HEX("#eaeeef")
        
        addSubview(bottomShadow)
        
        addSubview(weekLabel)
        addSubview(monthLabel)
        addSubview(yearLabel)
        
        addSubview(weekBtn)
        addSubview(monthBtn)
        addSubview(yearBtn)
        
        addSubview(weekArrow)
        addSubview(monthArrow)
        addSubview(yearArrow)

        bottomShadow.IN(self).LEFT.RIGHT.BOTTOM(-9).HEIGHT(14).MAKE()
        
        weekBtn.IN(self).LEFT.TOP.BOTTOM.WIDTH(kScreenW / 3).MAKE()
        monthBtn.IN(self).LEFT(kScreenW / 3).TOP.BOTTOM.WIDTH(kScreenW / 3).MAKE()
        yearBtn.IN(self).LEFT(kScreenW / 3 * 2).TOP.BOTTOM.WIDTH(kScreenW / 3).MAKE()
        
        weekLabel.IN(weekBtn).LEFT.RIGHT.BOTTOM(5).TOP.MAKE()
        monthLabel.IN(monthBtn).LEFT.RIGHT.BOTTOM(5).TOP.MAKE()
        yearLabel.IN(yearBtn).LEFT.RIGHT.BOTTOM(5).TOP.MAKE()
        
        weekArrow.IN(weekBtn).BOTTOM(-9).CENTER.SIZE(28, 22).MAKE()
        monthArrow.IN(monthBtn).BOTTOM(-9).CENTER.SIZE(28, 22).MAKE()
        yearArrow.IN(yearBtn).BOTTOM(-9).CENTER.SIZE(28, 22).MAKE()
        
        self.clipsToBounds = true
        
        setWeek()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
