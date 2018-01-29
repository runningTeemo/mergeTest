//
//  ProjectPointsView.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/9.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class ProjectPointsView: UIView {
    
    func heightlightSpot(_ h: Bool) {
        h ? (spotBtn.iconView.image = UIImage(named: "xmld_sel")) : (spotBtn.iconView.image = UIImage(named: "xmld"))
    }
    func heightlightBrief(_ h: Bool) {
        h ? (briefBtn.iconView.image = UIImage(named: "cpgk_sel")) : (briefBtn.iconView.image = UIImage(named: "cpgk"))
    }
    func heightlightPain(_ h: Bool) {
        h ? (painBtn.iconView.image = UIImage(named: "hytd_sel")) : (painBtn.iconView.image = UIImage(named: "hytd"))
    }
    func heightlightMembers(_ h: Bool) {
        h ? (memebersBtn.iconView.image = UIImage(named: "cstd_sel")) : (memebersBtn.iconView.image = UIImage(named: "cstd"))
    }
    func heightlightBussiness(_ h: Bool) {
        h ? (bussinessBtn.iconView.image = UIImage(named: "syms_sel")) : (bussinessBtn.iconView.image = UIImage(named: "syms"))
    }
    func heightlightData(_ h: Bool) {
        h ? (dataBtn.iconView.image = UIImage(named: "yysj_sel")) : (dataBtn.iconView.image = UIImage(named: "yysj"))
    }
    func heightlightMarketing(_ h: Bool) {
        h ? (marketingBtn.iconView.image = UIImage(named: "scqk_sel")) : (marketingBtn.iconView.image = UIImage(named: "scqk"))
    }
    func heightlightExit(_ h: Bool) {
        h ? (exitBtn.iconView.image = UIImage(named: "tcqk_sel")) : (exitBtn.iconView.image = UIImage(named: "tcfa"))
    }
    
    static let height: CGFloat = tbMargin * 2 + inMargin + btnH * 2
    
    static let inMargin: CGFloat = 10
    static let btnW = (kScreenW - inMargin * 3 - 12.5 * 2) / 4
    static let btnH = btnW * 161 / 300
    static let tbMargin: CGFloat = 20
    
    lazy var spotBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    lazy var briefBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    lazy var painBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    lazy var memebersBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    lazy var bussinessBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    lazy var dataBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    lazy var marketingBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    lazy var exitBtn: ImageButton = {
        let one = ImageButton()
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        addSubview(spotBtn)
        addSubview(briefBtn)
        addSubview(painBtn)
        addSubview(memebersBtn)
        
        addSubview(bussinessBtn)
        addSubview(dataBtn)
        addSubview(marketingBtn)
        addSubview(exitBtn)
        
        
        heightlightSpot(false)
        heightlightBrief(false)
        heightlightPain(false)
        heightlightMembers(false)
        heightlightBussiness(false)
        heightlightData(false)
        heightlightMarketing(false)
        heightlightExit(false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inMargin = ProjectPointsView.inMargin
        let btnW = ProjectPointsView.btnW
        let btnH = ProjectPointsView.btnH
        let tbMargin = ProjectPointsView.tbMargin
        
        briefBtn.frame = CGRect(x: 12.5, y: tbMargin, width: btnW, height: btnH)
        spotBtn.frame = CGRect(x: 12.5 + (btnW + inMargin) * 1, y: tbMargin, width: btnW, height: btnH)
        painBtn.frame = CGRect(x: 12.5 + (btnW + inMargin) * 2, y: tbMargin, width: btnW, height: btnH)
        memebersBtn.frame = CGRect(x: 12.5 + (btnW + inMargin) * 3, y: tbMargin, width: btnW, height: btnH)
        
        let y2 = tbMargin + btnH + inMargin
        bussinessBtn.frame = CGRect(x: 12.5, y: y2, width: btnW, height: btnH)
        dataBtn.frame = CGRect(x: 12.5 + (btnW + inMargin) * 1, y: y2, width: btnW, height: btnH)
        marketingBtn.frame = CGRect(x: 12.5 + (btnW + inMargin) * 2, y: y2, width: btnW, height: btnH)
        exitBtn.frame = CGRect(x: 12.5 + (btnW + inMargin) * 3, y: y2, width: btnW, height: btnH)
    }
    
}
