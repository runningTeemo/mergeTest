//
//  DataSummariseHotView.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/4.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class DataSummariseHotView: UIView {
    
    var respondInstitution: ((_ institution: TinSummariseInstitution) -> ())? {
        didSet {
            subViewA.respondInstitution = respondInstitution
            subViewB.respondInstitution = respondInstitution
        }
    }
    
    var summarise: TinDataSummarise? {
        didSet {
            if let summarise = summarise {
                subViewA.institutions = summarise.hotInstitutions
                subViewB.institutions = summarise.hotEnterpises
            }
        }
    }
    
    static let viewHeight: CGFloat = 80
    
    lazy var subViewA: DataSummariseHotSubView = {
        let one = DataSummariseHotSubView()
        one.titleLabel.text = "机构"
        one.btn0.title = "--"
        one.btn1.title = "--"
        one.btn2.title = "--"
        return one
    }()
    
    lazy var subViewB: DataSummariseHotSubView = {
        let one = DataSummariseHotSubView()
        one.titleLabel.text = "企业"
        one.btn0.title = "--"
        one.btn1.title = "--"
        one.btn2.title = "--"
        return one
    }()
    
    var breakLine = NewBreakLine
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = kClrWhite
        addSubview(subViewA)
        addSubview(subViewB)
        addSubview(breakLine)
        subViewA.IN(self).LEFT.RIGHT.TOP(12.5).HEIGHT(24).MAKE()
        subViewB.IN(self).LEFT.RIGHT.BOTTOM(15).HEIGHT(24).MAKE()
        breakLine.IN(self).LEFT.RIGHT.BOTTOM.HEIGHT(0.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DataSummariseHotSubView: UIView {
    
    var respondInstitution: ((_ institution: TinSummariseInstitution) -> ())?
    
    var institutions: [TinSummariseInstitution]? {
        didSet {
            if let institutions = institutions {
                
                if institutions.count == 0 {
                    btn0.isHidden = true
                    btn1.isHidden = true
                    btn2.isHidden = true
                } else if institutions.count == 1 {
                    btn0.isHidden = false
                    btn1.isHidden = true
                    btn2.isHidden = true
                    btn0.title = institutions[0].shortName
                } else if institutions.count == 2 {
                    btn0.isHidden = false
                    btn1.isHidden = false
                    btn2.isHidden = true
                    btn0.title = institutions[0].shortName
                    btn1.title = institutions[1].shortName
                } else {
                    btn0.isHidden = false
                    btn1.isHidden = false
                    btn2.isHidden = false
                    btn0.title = institutions[0].shortName
                    btn1.title = institutions[1].shortName
                    btn2.title = institutions[2].shortName
                }
            } else {
                btn0.isHidden = true
                btn1.isHidden = true
                btn2.isHidden = true
            }
        }
    }
    
    lazy var hotLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#d61f26")
        let fontName = UIFont.systemFont(ofSize: 15).fontName
        let c = 15 * Float(M_PI) / 180
        let transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(c)), d: 1, tx: 0, ty: 0)
        let desc = UIFontDescriptor(name: fontName, matrix: transform)
        one.font = UIFont(descriptor: desc, size: 9)
        one.layer.cornerRadius = 2
        one.layer.masksToBounds = true
        one.layer.borderColor = HEX("#d61f26").cgColor
        one.layer.borderWidth = 1
        one.text = "HOT"
        one.textAlignment = .center
        return one
    }()
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 12)
        one.textColor = HEX("#333333")
        one.text = "机构"
        return one
    }()
    
    var breakLine = NewBreakLine
    
    lazy var btn0: TitleButton = {
        let one = TitleButton()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitlefont = UIFont.systemFont(ofSize: 12)
        one.dowTitlefont = UIFont.systemFont(ofSize: 12)
        one.norTitleColor = HEX("#666666")
        one.dowTitleColor = HEX("#999999")
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondInstitution?(self.institutions![0])
        })
        return one
    }()
    lazy var btn1: TitleButton = {
        let one = TitleButton()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitlefont = UIFont.systemFont(ofSize: 12)
        one.dowTitlefont = UIFont.systemFont(ofSize: 12)
        one.norTitleColor = HEX("#666666")
        one.dowTitleColor = HEX("#999999")
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondInstitution?(self.institutions![1])
        })
        return one
    }()
    lazy var btn2: TitleButton = {
        let one = TitleButton()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitlefont = UIFont.systemFont(ofSize: 12)
        one.dowTitlefont = UIFont.systemFont(ofSize: 12)
        one.norTitleColor = HEX("#666666")
        one.dowTitleColor = HEX("#999999")
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondInstitution?(self.institutions![2])
        })
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        addSubview(hotLabel)
        addSubview(titleLabel)
        addSubview(breakLine)

        hotLabel.IN(self).LEFT(12.5).CENTER.SIZE(30, 15).MAKE()
        titleLabel.RIGHT(hotLabel).OFFSET(10).CENTER.WIDTH(30).MAKE()
        breakLine.RIGHT(titleLabel).OFFSET(10).CENTER.SIZE(1, 13).MAKE()
        
        addSubview(btn0)
        addSubview(btn1)
        addSubview(btn2)
        
        let x: CGFloat = 12.5 + 30 + 10 + 30 + 10
        let w: CGFloat = (kScreenW - x - 12.5) / 3
        
        btn0.IN(self).LEFT(x).TOP.BOTTOM.WIDTH(w).MAKE()
        btn1.IN(self).LEFT(x + w).TOP.BOTTOM.WIDTH(w).MAKE()
        btn2.IN(self).LEFT(x + w * 2).TOP.BOTTOM.WIDTH(w).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


