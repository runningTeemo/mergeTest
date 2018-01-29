//
//  DataSummariseMarkView.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/6.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class DataSummariseMarkView: UIView {
    
    var bubblePrefix: String = ""
    var bubbleSurfix: String? = nil

    var respondInstitutions: ((_ institutions: [TinSummariseInstitution]) -> ())?
    var respondInstitution: ((_ institution: TinSummariseInstitution) -> ())?

    private(set) var amountEntry: TinAmountSummariseChartEntry?
    private(set) var industryEntry: TinIndustrySummariseChartEntry?
    private(set) var roundEntry: TinRoundSummariseChartEntry?
    
    func handleMore() {
        if let amountEntry = amountEntry {
            respondInstitution?(amountEntry.institution)
        } else if let industryEntry = industryEntry {
            respondInstitutions?(industryEntry.institutions)
        } else if let roundEntry = roundEntry {
            respondInstitutions?(roundEntry.institutions)
        }
    }
    
    let attriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 9),
        NSForegroundColorAttributeName: UIColor.white
    ]
    func update(amountEntry: TinAmountSummariseChartEntry, atPoint: CGPoint) {
        self.amountEntry = amountEntry
        self.industryEntry = nil
        self.roundEntry = nil
        
        let mAttri = NSMutableAttributedString()
        let name = amountEntry.institution.shortName
        mAttri.append(NSAttributedString(string: SafeUnwarp(name, holderForNull: ""), attributes: attriDic))
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))
        mAttri.append(NSAttributedString(string: "次数：\(amountEntry.count)次", attributes: attriDic))
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))
        if amountEntry.amount <= 0 {
            mAttri.append(NSAttributedString(string: "金额：N/A", attributes: attriDic))
        } else if amountEntry.amount < 10000 {
            mAttri.append(NSAttributedString(string: "金额：\(Int(amountEntry.amount))万美元", attributes: attriDic))
        } else {
            mAttri.append(NSAttributedString(string: String(format: "%.1f亿美元", amountEntry.amount / 10000), attributes: attriDic))
        }
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))

        let size = mAttri.boundingRect(with: CGSize(width: 9999, height: 9999), options: .usesLineFragmentOrigin, context: nil).size
        let w = size.width + 10 * 2
        let h = size.height + 10 + 5 + 25 - 9
        self.frame = CGRect(x: atPoint.x - w / 2, y: atPoint.y - h, width: w, height: h)
        labelBack.frame = CGRect(x: 0, y: 0, width: w, height: h - 5)
        arrow.frame = CGRect(x: labelBack.frame.midX - 5, y: labelBack.frame.maxY - 1, width: 10, height: 5)
        label.frame = CGRect(x: 10, y: 10, width: size.width, height: size.height)
        label.attributedText = mAttri
        moreLabel.frame = CGRect(x: 10, y: label.frame.maxY - 9, width: w - 10 * 2, height: 25)

    }
    
    func update(industryEntry: TinIndustrySummariseChartEntry, atPoint: CGPoint) {
        self.industryEntry = industryEntry
        self.roundEntry = nil
        self.amountEntry = nil
        
        let mAttri = NSMutableAttributedString()
        mAttri.append(NSAttributedString(string: SafeUnwarp(industryEntry.name, holderForNull: ""), attributes: attriDic))
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))
        mAttri.append(NSAttributedString(string: "次数：\(industryEntry.count)次", attributes: attriDic))
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))
        if industryEntry.amount <= 0 {
            mAttri.append(NSAttributedString(string: "金额：N/A", attributes: attriDic))
        } else if industryEntry.amount < 10000 {
            mAttri.append(NSAttributedString(string: "金额：\(Int(industryEntry.amount))万美元", attributes: attriDic))
        } else {
            mAttri.append(NSAttributedString(string: String(format: "%.1f亿美元", industryEntry.amount / 10000), attributes: attriDic))
        }
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))

        let size = mAttri.boundingRect(with: CGSize(width: 9999, height: 9999), options: .usesLineFragmentOrigin, context: nil).size
        let w = size.width + 10 * 2
        let h = size.height + 10 + 5 + 25 - 9
        self.frame = CGRect(x: atPoint.x - w / 2, y: atPoint.y - h, width: w, height: h)
        labelBack.frame = CGRect(x: 0, y: 0, width: w, height: h - 5)
        arrow.frame = CGRect(x: labelBack.frame.midX - 5, y: labelBack.frame.maxY - 1, width: 10, height: 5)
        label.frame = CGRect(x: 10, y: 10, width: size.width, height: size.height)
        label.attributedText = mAttri
        moreLabel.frame = CGRect(x: 10, y: label.frame.maxY - 9, width: w - 10 * 2, height: 25)

    }
    
    func update(roundEntry: TinRoundSummariseChartEntry, atPoint: CGPoint) {
        self.roundEntry = roundEntry
        self.industryEntry = nil
        self.amountEntry = nil
        
        let mAttri = NSMutableAttributedString()
        let name = TinSearch(code: roundEntry.round, inKeys: kDataRoundKeys)?.name
        mAttri.append(NSAttributedString(string: SafeUnwarp(name, holderForNull: ""), attributes: attriDic))
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))
        mAttri.append(NSAttributedString(string: "次数：\(roundEntry.count)次", attributes: attriDic))
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))
        if roundEntry.amount <= 0 {
            mAttri.append(NSAttributedString(string: "金额：N/A", attributes: attriDic))
        } else if roundEntry.amount < 10000 {
            mAttri.append(NSAttributedString(string: "金额：\(Int(roundEntry.amount))万美元", attributes: attriDic))
        } else {
            mAttri.append(NSAttributedString(string: String(format: "%.1f亿美元", roundEntry.amount / 10000), attributes: attriDic))
        }
        mAttri.append(NSAttributedString(string: "\n", attributes: attriDic))

        let size = mAttri.boundingRect(with: CGSize(width: 9999, height: 9999), options: .usesLineFragmentOrigin, context: nil).size
        let w = size.width + 10 * 2
        let h = size.height + 10 + 5 + 25 - 9
        self.frame = CGRect(x: atPoint.x - w / 2, y: atPoint.y - h, width: w, height: h)
        labelBack.frame = CGRect(x: 0, y: 0, width: w, height: h - 5)
        arrow.frame = CGRect(x: labelBack.frame.midX - 5, y: labelBack.frame.maxY - 1, width: 10, height: 5)
        label.frame = CGRect(x: 10, y: 10, width: size.width, height: size.height)
        label.attributedText = mAttri
        moreLabel.frame = CGRect(x: 10, y: label.frame.maxY - 9, width: w - 10 * 2, height: 25)
    }
    
    lazy var label: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 9)
        one.textColor = UIColor.white
        one.numberOfLines = 0
        one.textAlignment = .left
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var labelBack: UIButton = {
        let one = UIButton()
        one.backgroundColor = HEX("#696969")
        one.layer.cornerRadius = 2
        one.clipsToBounds = true
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.handleMore()
        })
        return one
    }()

    lazy var arrow: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconTZSJ")
        one.isUserInteractionEnabled = false
        return one
    }()
    
    lazy var moreLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrLightGray
        one.font = UIFont.systemFont(ofSize: 9)
        one.text = "more"
        one.textAlignment = .center
        one.isUserInteractionEnabled = false
        return one
    }()

    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        addSubview(labelBack)
        addSubview(label)
        addSubview(arrow)
        addSubview(moreLabel)        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
