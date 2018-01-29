//
//  UserDetailCells.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/14.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class UserDetailArticleItem {
    
    let model: Article
    
    fileprivate(set) var isNormalMode: Bool = true
    fileprivate(set) var cellHeight: CGFloat = 110

    fileprivate(set) var attachmentsAttriCache: NSAttributedString?
    fileprivate(set) var textAttriCache: NSAttributedString?
    fileprivate(set) var attachmentsBgColor: UIColor?

    let textAttriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: kClrDarkGray,
        NSParagraphStyleAttributeName: {
            let one = NSMutableParagraphStyle()
            one.lineSpacing = 2
            one.lineBreakMode = .byWordWrapping
            one.alignment = .justified
            return one
        }()
    ]
    
    init(model: Article) {
        self.model = model
        update()
    }
    
    func update() {
        
        if model.type == .normal {
            textAttriCache = StringTool.makeAttributeString(model.content, dic: textAttriDic)
            if model.pictures.count > 0 {
                attachmentsBgColor = UIColor.clear
                isNormalMode = true
            } else {
                isNormalMode = false
                attachmentsBgColor = HEX("#ededf1")
                attachmentsAttriCache = StringTool.makeAttributeString(model.content, dic: textAttriDic)
            }
        } else {
            isNormalMode = false

            let mAttr = NSMutableAttributedString()
            
            let titleDic = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: kClrDeepGray
            ]
            let contentDic = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: kClrDarkGray
            ]
            let space = StringTool.makeAttributeString("\n", dic: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 5)
                ])!
            
            if model.type == .project {
                attachmentsBgColor = HEX("#fffaf3")
                if let attachments = model.attachments as? ArticleProjectAttachments {
                    
                    let icon = AttributedStringTool.notNullAttributedImage(named: "iconXM", bounds: CGRect(x: 0, y: -5, width: 30, height: 18))
                    mAttr.append(icon)
                    mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.name, holderForNull: ""), dic: titleDic)!)
                    if model.broadcast == true {
                        let horn = AttributedStringTool.notNullAttributedImage(named: "hornSmall", bounds: CGRect(x: 0, y: -3, width: 25, height: 17))
                        mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                        mAttr.append(horn)
                    }
                    mAttr.append(StringTool.makeAttributeString("\n", dic: contentDic)!)
                    mAttr.append(space)
                    
                    let dealType = TinSearch(code: attachments.dealType, inKeys: kProjectDealTypeKeys)?.name
                    let currentRound: String?
                    if dealType == "并购收购" {
                        currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectMergeTypeKeys)?.name
                    } else {
                        currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectInvestTypeKeys)?.name
                    }
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(currentRound, holderForNull: ""), dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    
                    let investStockRatio = SafeUnwarp(attachments.investStockRatio, holderForNull: 0)
                    let investStockStr = StaticCellTools.doubleToCutZero(n: investStockRatio) + "%"
                    let money: String?
                    let amount = SafeUnwarp(attachments.currencyAmount, holderForNull: 0)
                    let n = StaticCellTools.numberToDecNumber(number: amount)
                    let currency = TinSearch(code: attachments.currency, inKeys: kCurrencyTypeKeys)?.name
                    if currency == "人民币" {
                        money = "¥" + n
                    } else if currency == "美元" {
                        money = "$" + n
                    } else if currency == "欧元" {
                        money = "€" + n
                    } else {
                        money = n
                    }
                    let moneyStr = SafeUnwarp(money, holderForNull: "") + " / " + investStockStr
                    mAttr.append(StringTool.makeAttributeString(moneyStr, dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: titleDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.location, holderForNull: ""), dic: contentDic)!)
                }
                
            } else if model.type == .activity {
                attachmentsBgColor = HEX("#f2f3ff")
                if let attachments = model.attachments as? ArticleActivityAttachments {
                    
                    let icon = AttributedStringTool.notNullAttributedImage(named: "iconHD", bounds: CGRect(x: 0, y: -5, width: 30, height: 18))
                    mAttr.append(icon)
                    mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.name, holderForNull: ""), dic: titleDic)!)
                    mAttr.append(StringTool.makeAttributeString("\n", dic: contentDic)!)
                    mAttr.append(space)
                    
                    let startDate = SafeUnwarp(DateTool.getSlashString(attachments.startTime), holderForNull: "")
                    let endDate = SafeUnwarp(DateTool.getSlashString(attachments.endTime), holderForNull: "")
                    let date = startDate + "-" + endDate
                    
                    mAttr.append(StringTool.makeAttributeString(date, dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    let count = "\(SafeUnwarp(attachments.peopleCount, holderForNull: 0))人"
                    mAttr.append(StringTool.makeAttributeString(count, dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.address, holderForNull: ""), dic: contentDic)!)
                }
                
            } else if model.type == .manpower {
                attachmentsBgColor = HEX("#f3faff")
                if let attachments = model.attachments as? ArticleManpowerAttachments {
                    
                    let icon = AttributedStringTool.notNullAttributedImage(named: "iconRC", bounds: CGRect(x: 0, y: -5, width: 30, height: 18))
                    mAttr.append(icon)
                    mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.duty, holderForNull: ""), dic: titleDic)!)
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    let salary = TinSearch(code: attachments.salary, inKeys: kManPowerSalaryKeys)?.name
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(salary, holderForNull: ""), dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString("\n", dic: contentDic)!)
                    mAttr.append(space)
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.companyName, holderForNull: ""), dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.address, holderForNull: ""), dic: contentDic)!)
                }
            }
            attachmentsAttriCache = mAttr
        }
        
        if !ArticleDetailHelper.canView(article: model) {
            attachmentsBgColor = HEX("#ededf1")
        }
        
        if isNormalMode {
            cellHeight = 110
        } else {
            var h = StringTool.size(attachmentsAttriCache, maxWidth: kScreenW - 80 - 10 - 12.5 - 10).height
            h += 20 + 10
            h += 20 + 10
            cellHeight = h
        }
    }
}

class UserDetailArticleCell: RootTableViewCell {
    
    var item: UserDetailArticleItem! {
        didSet {
            let article = item.model
            
            if let date = article.createDate {
                let d1 = DateTool.getSegDate(Date())!
                let d2 = DateTool.getSegDate(date)!
                if d1.day == d2.day {
                    dayLabel.text = "今天"
                    dayLabel.font = UIFont.systemFont(ofSize: 25)
                    monthLabel.text = nil
                } else if d1.day == d2.day + 1 {
                    dayLabel.text = "昨天"
                    dayLabel.font = UIFont.systemFont(ofSize: 25)
                    monthLabel.text = nil
                } else {
                    dayLabel.font = UIFont.systemFont(ofSize: 30)
                    dayLabel.text = String(format: "%02d", d2.day)
                    monthLabel.text = "\(d2.month)月"
                }
            } else {
                dayLabel.text = nil
                monthLabel.text = nil
            }
            
            if item.isNormalMode {
                contentLabel.attributedText = item.textAttriCache
                imagesView.pictures = item.model.pictures
                imageCountLabel.text = "共\(item.model.pictures.count)张"
                contentLabel.isHidden = false
                imagesView.isHidden = false
                imageCountLabel.isHidden = false
                attachmentBg.isHidden = true
            } else {
                contentLabel.isHidden = true
                imagesView.isHidden = true
                imageCountLabel.isHidden = true
                attachmentBg.isHidden = false
                attachmentLabel.attributedText = item.attachmentsAttriCache
                attachmentBg.backgroundColor = item.attachmentsBgColor
            }
        }
    }
    
    lazy var dayLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 30)
        one.textColor = kClrBlack
        return one
    }()
    lazy var monthLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 13)
        one.textColor = kClrBlack
        return one
    }()
    
    lazy var imagesView: FourImageView = {
        let one = FourImageView()
        return one
    }()
    lazy var imageCountLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.numberOfLines = 2
        return one
    }()
    lazy var attachmentBg: UIView = {
        let one = UIView()
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var attachmentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.numberOfLines = 4
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dayLabel)
        contentView.addSubview(monthLabel)
        contentView.addSubview(imagesView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(imageCountLabel)
        dayLabel.IN(contentView).LEFT(12.5).TOP(20).MAKE()
        monthLabel.RIGHT(dayLabel).BOTTOM(-5).MAKE()
        imagesView.IN(contentView).TOP(20).LEFT(80).SIZE(80, 80).MAKE()
        contentLabel.RIGHT(imagesView).OFFSET(10).TOP.MAKE()
        contentLabel.RIGHT.EQUAL(contentView).OFFSET(-12.5).MAKE()
        imageCountLabel.RIGHT(imagesView).OFFSET(10).BOTTOM.MAKE()
        
        contentView.addSubview(attachmentBg)
        attachmentBg.addSubview(attachmentLabel)
        attachmentLabel.IN(contentView).LEFT(80 + 10).TOP(20 + 10).RIGHT(12.5 + 10).MAKE()
        attachmentBg.IN(attachmentLabel).LEFT(-10).TOP(-10).RIGHT(-10).BOTTOM(-10).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UserDetailCirclesCell: RootTableViewCell {
    
    var item: RectSelectsFixSizeItem! {
        didSet {
            circlesView.item = item
        }
    }
    
    lazy var circlesView: RectSelectsFixSizeView = {
        let one = RectSelectsFixSizeView()
        one.isUserInteractionEnabled = false
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(circlesView)
        circlesView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP(20).BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UserDetailCommentItem {
    
    let model: Article
    let isMe: Bool
    
    fileprivate(set) var isNormalMode: Bool = true
    fileprivate(set) var cellHeight: CGFloat = 110
    
    let roleFont: UIFont = UIFont.systemFont(ofSize: 9)

    fileprivate(set) var titleAttriCache: NSAttributedString?
    fileprivate(set) var roleWidth: CGFloat = 0
    fileprivate(set) var role: String?

    fileprivate(set) var textAttriCache: NSAttributedString?
    fileprivate(set) var countAttriCache: NSAttributedString?
    fileprivate(set) var attachmentsAttriCache: NSAttributedString?
    fileprivate(set) var attachmentsBgColor: UIColor?
    
    let textAttriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: kClrDarkGray,
        NSParagraphStyleAttributeName: {
            let one = NSMutableParagraphStyle()
            one.lineSpacing = 2
            one.lineBreakMode = .byWordWrapping
            one.alignment = .justified
            return one
        }()
    ]
    
    init(model: Article, isMe: Bool) {
        self.model = model
        self.isMe = isMe
        update()
    }
    
    func update() {
        
        do {
            let name = SafeUnwarp(model.user.realName, holderForNull: "匿名用户")
            var duty: String?
            if NotNullText(model.user.duty) {
                duty = model.user.duty!
            }
            
            let titleAttriDic = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                NSForegroundColorAttributeName: HEX("#46689b"),
                ]
            let mAttr = NSMutableAttributedString()
            let nameAttri = StringTool.size(name, attriDic: titleAttriDic).attriStr!
            mAttr.append(nameAttri)
            if let duty = duty {
                let spaceAttri = StringTool.size("  ", attriDic: titleAttriDic).attriStr!
                mAttr.append(spaceAttri)
                let titleBreak = AttributedStringTool.notNullAttributedImage(named: "sx", bounds: CGRect(x: 0, y: 0, width: 1, height: 12))
                mAttr.append(titleBreak)
                let spaceAttri1 = StringTool.size("  ", attriDic: titleAttriDic).attriStr!
                mAttr.append(spaceAttri1)
                let dutyAttri = StringTool.size(duty, attriDic: titleAttriDic).attriStr!
                mAttr.append(dutyAttri)
            }
            titleAttriCache = mAttr
            
            let roleType = TinSearch(code: model.user.roleType, inKeys: kUserRoleTypeKeys)?.name
            roleWidth = StringTool.size(roleType, font: roleFont).size.width + 5 * 2
            if roleWidth <= 12 {
                roleWidth = 0
            }
            role = roleType
        }
        
        if model.type == .normal {
            textAttriCache = StringTool.makeAttributeString(model.content, dic: textAttriDic)
            if model.pictures.count > 0 {
                attachmentsBgColor = UIColor.clear
                isNormalMode = true
            } else {
                isNormalMode = false
                attachmentsBgColor = HEX("#ededf1")
                attachmentsAttriCache = StringTool.makeAttributeString(model.content, dic: textAttriDic)
            }
        } else {
            isNormalMode = false
            
            let mAttr = NSMutableAttributedString()
            
            let titleDic = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: kClrDeepGray
            ]
            let contentDic = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: kClrDarkGray
            ]
            let space = StringTool.makeAttributeString("\n", dic: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 5)
                ])!
            
            if model.type == .project {
                attachmentsBgColor = HEX("#fffaf3")
                if let attachments = model.attachments as? ArticleProjectAttachments {
                    
                    let icon = AttributedStringTool.notNullAttributedImage(named: "iconXM", bounds: CGRect(x: 0, y: -5, width: 30, height: 18))
                    mAttr.append(icon)
                    mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.name, holderForNull: ""), dic: titleDic)!)
                    if model.broadcast == true {
                        let horn = AttributedStringTool.notNullAttributedImage(named: "hornSmall", bounds: CGRect(x: 0, y: -3, width: 25, height: 17))
                        mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                        mAttr.append(horn)
                    }
                    mAttr.append(StringTool.makeAttributeString("\n", dic: contentDic)!)
                    mAttr.append(space)
                    
                    let dealType = TinSearch(code: attachments.dealType, inKeys: kProjectDealTypeKeys)?.name
                    let currentRound: String?
                    if dealType == "并购收购" {
                        currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectMergeTypeKeys)?.name
                    } else {
                        currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectInvestTypeKeys)?.name
                    }
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(currentRound, holderForNull: ""), dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    
                    let investStockRatio = SafeUnwarp(attachments.investStockRatio, holderForNull: 0)
                    let investStockStr = StaticCellTools.doubleToCutZero(n: investStockRatio) + "%"
                    let money: String?
                    let amount = SafeUnwarp(attachments.currencyAmount, holderForNull: 0)
                    let n = StaticCellTools.numberToDecNumber(number: amount)
                    let currency = TinSearch(code: attachments.currency, inKeys: kCurrencyTypeKeys)?.name
                    if currency == "人民币" {
                        money = "¥" + n
                    } else if currency == "美元" {
                        money = "$" + n
                    } else if currency == "欧元" {
                        money = "€" + n
                    } else {
                        money = n
                    }
                    let moneyStr = SafeUnwarp(money, holderForNull: "") + " / " + investStockStr
                    mAttr.append(StringTool.makeAttributeString(moneyStr, dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: titleDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.location, holderForNull: ""), dic: contentDic)!)
                }
                
            } else if model.type == .activity {
                attachmentsBgColor = HEX("#f2f3ff")
                if let attachments = model.attachments as? ArticleActivityAttachments {
                    
                    let icon = AttributedStringTool.notNullAttributedImage(named: "iconHD", bounds: CGRect(x: 0, y: -5, width: 30, height: 18))
                    mAttr.append(icon)
                    mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.name, holderForNull: ""), dic: titleDic)!)
                    mAttr.append(StringTool.makeAttributeString("\n", dic: contentDic)!)
                    mAttr.append(space)
                    
                    let startDate = SafeUnwarp(DateTool.getSlashString(attachments.startTime), holderForNull: "")
                    let endDate = SafeUnwarp(DateTool.getSlashString(attachments.endTime), holderForNull: "")
                    let date = startDate + "-" + endDate
                    
                    mAttr.append(StringTool.makeAttributeString(date, dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    let count = "\(SafeUnwarp(attachments.peopleCount, holderForNull: 0))人"
                    mAttr.append(StringTool.makeAttributeString(count, dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.address, holderForNull: ""), dic: contentDic)!)
                }
                
            } else if model.type == .manpower {
                attachmentsBgColor = HEX("#f3faff")
                if let attachments = model.attachments as? ArticleManpowerAttachments {
                    
                    let icon = AttributedStringTool.notNullAttributedImage(named: "iconRC", bounds: CGRect(x: 0, y: -5, width: 30, height: 18))
                    mAttr.append(icon)
                    mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.duty, holderForNull: ""), dic: titleDic)!)
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    let salary = TinSearch(code: attachments.salary, inKeys: kManPowerSalaryKeys)?.name
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(salary, holderForNull: ""), dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString("\n", dic: contentDic)!)
                    mAttr.append(space)
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.companyName, holderForNull: ""), dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString("  ", dic: contentDic)!)
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.address, holderForNull: ""), dic: contentDic)!)
                }
            }
            attachmentsAttriCache = mAttr
        }
        
        do {
            let mAttri = NSMutableAttributedString()
            mAttri.append(StringTool.makeAttributeString((isMe ? "您" : "") + "参与过 ", dic: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: kClrGray
                ])!)
            mAttri.append(StringTool.makeAttributeString("\(SafeUnwarp(model.userCommentCount, holderForNull: 0))", dic: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: kClrOrange
                ])!)
            mAttri.append(StringTool.makeAttributeString( " 条评论", dic: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: kClrGray
                ])!)
            countAttriCache = mAttri
        }
        
        if !ArticleDetailHelper.canView(article: model) {
            attachmentsBgColor = HEX("#ededf1")
        }
        
        if isNormalMode {
            cellHeight = CGFloat(20 + 45 + 10 + 60 + 10 + 15 + 20 + 10)
        } else {
            var h = StringTool.size(attachmentsAttriCache, maxWidth: kScreenW - 12.5 - 10 - 12.5 - 10).height
            h += 20 + 45 + 10 + 10
            h += 10 + 10 + 15 + 20 + 10
            cellHeight = h
        }
    }
}

class UserDetailCommentCell: RootTableViewCell {
    
    var item: UserDetailCommentItem! {
        didSet {
            
            let article = item.model
            
            iconView.iconView.fullPath = article.user.avatar
            titleLabel.attributedText = item.titleAttriCache
            roleWidthCons?.constant = item.roleWidth
            
            if let roleType = item.role {
                roleLabel.norTitlefont = item.roleFont
                roleLabel.title = item.role
                if roleType == "企业" {
                    roleLabel.norBorderColor = HEX("#70bbea")
                    roleLabel.dowBorderColor = HEX("#70bbea")
                    roleLabel.norTitleColor = HEX("#3c9cd9")
                    roleLabel.dowTitleColor = HEX("#3c9cd9")
                } else if roleType == "机构" {
                    roleLabel.norBorderColor = HEX("#7ad7d6")
                    roleLabel.dowBorderColor = HEX("#7ad7d6")
                    roleLabel.norTitleColor = HEX("#4dc3c2")
                    roleLabel.dowTitleColor = HEX("#4dc3c2")
                } else if roleType == "FA" {
                    roleLabel.norBorderColor = HEX("#f3d37e")
                    roleLabel.dowBorderColor = HEX("#f3d37e")
                    roleLabel.norTitleColor = HEX("#e2b94a")
                    roleLabel.dowTitleColor = HEX("#e2b94a")
                } else {
                    roleLabel.norBorderColor = HEX("#a4aff0")
                    roleLabel.dowBorderColor = HEX("#a4aff0")
                    roleLabel.norTitleColor = HEX("#707fd7")
                    roleLabel.dowTitleColor = HEX("#707fd7")
                }
                roleLabel.isHidden = false
            } else {
                roleLabel.title = nil
                roleLabel.isHidden = true
            }

            if item.model.type == .project {
                dateLabel.text = DateTool.getDateString(item.model.createDate)
                companyLabel.text = SafeUnwarp(item.model.user.company, holderForNull: "匿名公司")
                companyLeftCons?.constant = 10
            } else {
                dateLabel.text = DateTool.getDateString(item.model.createDate)
                companyLabel.text = nil
                companyLeftCons?.constant = -20
            }
            
            if item.isNormalMode {
                imageContentLabel.attributedText = item.textAttriCache
                imagesView.pictures = item.model.pictures
                imageContentLabel.isHidden = false
                imageContent.isHidden = false
                imagesView.isHidden = false
                attachmentBg.isHidden = true
            } else {
                imageContentLabel.isHidden = true
                imageContent.isHidden = true
                imagesView.isHidden = true
                attachmentBg.isHidden = false
                attachmentLabel.attributedText = item.attachmentsAttriCache
                attachmentBg.backgroundColor = item.attachmentsBgColor
            }
            
            countLabel.attributedText = item.countAttriCache
        }
    }
    
    lazy var iconView: RoundUserIcon = {
        let one = RoundUserIcon()
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    lazy var jobLabel: UILabel = {
        let one = UILabel()
        one.textColor = HEX("#999999")
        return one
    }()
    lazy var roleLabel: BorderButton = {
        let one = BorderButton()
        one.isUserInteractionEnabled = false
        return one
    }()
    
    lazy var companyLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontTip
        one.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        return one
    }()
    
    lazy var attachmentBg: UIView = {
        let one = UIView()
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var attachmentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = kFontNormal
        one.numberOfLines = 4
        return one
    }()
    
    lazy var imagesView: FourImageView = {
        let one = FourImageView()
        return one
    }()
    lazy var imageContentLabel: UILabel = {
        let one = UILabel()
        one.numberOfLines = 2
        return one
    }()
    lazy var imageContent: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#ededf1")
        return one
    }()

    lazy var countLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    
    lazy var bottomView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBackGray
        return one
    }()
    
    var roleWidthCons: NSLayoutConstraint?
    var companyLeftCons: NSLayoutConstraint?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(roleLabel)
        contentView.addSubview(jobLabel)

        contentView.addSubview(companyLabel)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(attachmentBg)
        attachmentBg.addSubview(attachmentLabel)
        
        contentView.addSubview(imagesView)
        contentView.addSubview(imageContent)
        contentView.addSubview(imageContentLabel)
        
        contentView.addSubview(bottomView)
        contentView.addSubview(countLabel)
        
        iconView.IN(contentView).LEFT(12.5).TOP(20).SIZE(45, 45).MAKE()
        titleLabel.RIGHT(iconView).OFFSET(10).TOP.MAKE()
        roleLabel.RIGHT(titleLabel).OFFSET(5).HEIGHT(14).CENTER.MAKE()
        roleLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        roleWidthCons = jobLabel.WIDTH.EQUAL(0).MAKE()
        
        companyLeftCons = companyLabel.LEFT.EQUAL(iconView).RIGHT.OFFSET(10).MAKE()
        companyLabel.BOTTOM.EQUAL(iconView).MAKE()
        dateLabel.RIGHT(companyLabel).OFFSET(30).MAKE()
        dateLabel.BOTTOM.EQUAL(iconView).MAKE()
        dateLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()

        attachmentLabel.IN(contentView).LEFT(12.5 + 10).TOP(20 + 45 + 10 + 10).RIGHT(12.5 + 10).MAKE()
        attachmentBg.IN(attachmentLabel).LEFT(-10).TOP(-10).RIGHT(-10).BOTTOM(-10).MAKE()
        
        imagesView.IN(contentView).LEFT(12.5).TOP(20 + 45 + 10).SIZE(60, 60).MAKE()
        imageContent.IN(contentView).RIGHT(12.5).TOP(20 + 45 + 10).MAKE()
        imageContent.RIGHT(imagesView).BOTTOM.MAKE()
        imageContentLabel.IN(imageContent).LEFT(10).TOP(10).RIGHT(10).MAKE()

        bottomView.IN(contentView).BOTTOM.LEFT.RIGHT.HEIGHT(10).MAKE()
        countLabel.IN(contentView).BOTTOM(10 + 20).RIGHT(12.5).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
