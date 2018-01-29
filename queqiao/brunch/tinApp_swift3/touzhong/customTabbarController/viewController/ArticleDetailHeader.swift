//
//  ArticleDetailHeaderView.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndustryArticleDetailItem {
    
    let model: Article
    
    var isNeedsFolder: Bool = false
    var isFold: Bool = true
    
    fileprivate(set) var iconFramme: CGRect = CGRect.zero
    
    let titleAttriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16),
        NSForegroundColorAttributeName: HEX("#46689b"),
        ]
    fileprivate(set) var titleFramme: CGRect = CGRect.zero
    fileprivate(set) var titleAttri: NSAttributedString?

    let jobFont: UIFont = UIFont.systemFont(ofSize: 14)
    fileprivate(set) var jobFramme: CGRect = CGRect.zero
    fileprivate(set) var jobString: String?
    
    let roleFont: UIFont = UIFont.systemFont(ofSize: 9)
    fileprivate(set) var roleFramme: CGRect = CGRect.zero
    
    fileprivate(set) var speakerFramme: CGRect = CGRect.zero
    
    let industryFont: UIFont = UIFont.systemFont(ofSize: 12)
    fileprivate(set) var industryFrame: CGRect = CGRect.zero
    fileprivate(set) var industryText: String?
    
    let contentAttriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16),
        NSForegroundColorAttributeName: kClrDeepGray,
        NSParagraphStyleAttributeName: {
            let one = NSMutableParagraphStyle()
            one.lineSpacing = 2
            one.lineBreakMode = .byWordWrapping
            one.alignment = .justified
            return one
        }()
    ]
    let contentAttriDicSmall = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: kClrDeepGray,
        NSParagraphStyleAttributeName: {
            let one = NSMutableParagraphStyle()
            one.lineSpacing = 2
            one.lineBreakMode = .byWordWrapping
            one.alignment = .justified
            return one
        }()
    ]
    fileprivate(set) var topGrayFrame: CGRect = CGRect.zero
    
    fileprivate(set) var contentAttriStri: NSAttributedString?
    fileprivate(set) var contentFrame: CGRect = CGRect.zero
    fileprivate(set) var contentBackFrame: CGRect = CGRect.zero

    fileprivate(set) var attachmentsItem: QXTwoColLabelsItem?
    fileprivate(set) var attachmentsFrame: CGRect = CGRect.zero
    
    fileprivate(set) var folderFrame: CGRect = CGRect.zero
    
    fileprivate(set) var imagesItem: SpeedDialImagesItem?
    fileprivate(set) var imagesFrame: CGRect = CGRect.zero
    
    let dateFont: UIFont = UIFont.systemFont(ofSize: 12)
    fileprivate(set) var dateFrame: CGRect = CGRect.zero
    fileprivate(set) var dateString: String?
    
    fileprivate(set) var projectPointsBreakFrame: CGRect = CGRect.zero
    fileprivate(set) var projectPointsViewFrame: CGRect = CGRect.zero
    
    fileprivate(set) var breakFrame: CGRect = CGRect.zero
    fileprivate(set) var segFrame: CGRect = CGRect.zero
    
    fileprivate(set) var viewHeight: CGFloat = 200
    
    init(model: Article) {
        self.model = model
        update()
    }
    
    func update() {
        
        let tbMargin: CGFloat = 15
        let lrMargin: CGFloat = 12.5
        let iconSize = CGSize(width: 45, height: 45)
        
        topGrayFrame = CGRect(x: 0, y: 0, width: kScreenW, height: 10)
        
        var offsetY: CGFloat = 10 + tbMargin
        iconFramme = CGRect(x: lrMargin, y: offsetY, width: iconSize.width, height: iconSize.height)
        
        do {
            switch model.type {
            case .normal:
                industryText = model.industry.name
            case .manpower:
                industryText = "人才"
            case .activity:
                industryText = "活动"
            case .project:
                industryText = "项目"
            default:
                // 这种情况不应存在
                industryText = "全部"
            }
            var w = StringTool.size(industryText, font: industryFont).size.width + 10 * 2
            w = max(w, 40)
            let x = kScreenW - lrMargin - w
            industryFrame = CGRect(x: x, y: 15 + 10, width: w, height: 20)
        }
        
        do {
            var speakerSize = CGSize.zero
            if model.broadcast == true && model.type == .project {
                speakerSize = CGSize(width: 31, height: 18)
            }
            let roleType = TinSearch(code: model.user.roleType, inKeys: kUserRoleTypeKeys)?.name
            var roleW = StringTool.size(roleType, font: roleFont).size.width + 5 * 2
            var titleW = industryFrame.minX - iconFramme.maxX - 10 - 10
            if roleType != nil {
                titleW = titleW - 5 - roleW
            } else {
                roleW = 0
            }
            if speakerSize.width > 0 {
                titleW = titleW - 5 - speakerSize.width
            }
            
            let name = SafeUnwarp(model.user.realName, holderForNull: "匿名用户")
            var duty: String?
            if NotNullText(model.user.duty) {
                duty = model.user.duty!
            }
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
                let dutySizeAttri = StringTool.size(duty, attriDic: titleAttriDic).attriStr!
                mAttr.append(dutySizeAttri)
            }
            titleAttri = mAttr
            let titleSize = StringTool.size(titleAttri)
            let titleNeedsW = titleSize.width
            titleW = min(titleW, titleNeedsW + 5)
            
            titleFramme = CGRect(x: iconFramme.maxX + 10, y: tbMargin + 10, width: titleW, height: 20)
            roleFramme = CGRect(x: titleFramme.maxX + 5, y: tbMargin + 12.5, width: roleW, height: 14)
            
            var speakerX = roleFramme.maxX + 5
            if roleType == nil {
                speakerX -= 5
            }
            speakerFramme = CGRect(x: speakerX, y: tbMargin + 11, width: speakerSize.width, height: speakerSize.height)
            
            if model.type == .project {
                dateString = DateTool.getDateString(model.createDate)
                let dateW = StringTool.size(dateString, font: dateFont).size.width
                let margin: CGFloat = 22
                let maxJobW = kScreenW - iconFramme.maxX - 10 - lrMargin - margin - dateW
                
                let company = SafeUnwarp(model.user.company, holderForNull: "匿名公司")
                //let job = SafeUnwarp(model.user.duty, holderForNull: "匿名职位")
                jobString = company// + "/" + job
                var jobW = StringTool.size(jobString, font: jobFont).size.width
                jobW = min(jobW, maxJobW)
                
                jobFramme = CGRect(x: iconFramme.maxX + 10, y: titleFramme.maxY + 8, width: jobW, height: 15)
                dateFrame = CGRect(x: jobFramme.maxX + margin, y: titleFramme.maxY + 8, width: dateW, height: 15)
                
            } else {
                dateString = DateTool.getNature(model.createDate)
                jobFramme = CGRect.zero
                let dateW = kScreenW - iconFramme.maxX - 10 - lrMargin
                dateFrame = CGRect(x: titleFramme.minX, y: titleFramme.maxY + 8, width: dateW, height: 15)
            }
        }
        
        offsetY += iconFramme.height + 15
        let text: String?
        let pics: [Picture]
        do {
            attachmentsFrame = CGRect.zero
            switch model.type {
            case .normal:
                text = model.content
                pics = model.pictures
                
            case .activity:
                var labels = [QXTwoColLabel]()
                let attachments = model.attachments as! ArticleActivityAttachments
                let startDate = SafeUnwarp(DateTool.getSlashString(attachments.startTime), holderForNull: "")
                let endDate = SafeUnwarp(DateTool.getSlashString(attachments.endTime), holderForNull: "")
                let date = startDate + "-" + endDate
                let count = "\(SafeUnwarp(attachments.peopleCount, holderForNull: 0))人"
                
                labels.append(makeAttachLabel(title: "活动名称：", content: attachments.name, notDiv: true))
                labels.append(makeAttachLabel(title: "时间：", content: date, notDiv: true))
                labels.append(makeAttachLabel(title: "场馆：", content: attachments.venue, notDiv: true))
                labels.append(makeAttachLabel(title: "城市：", content: attachments.city, notDiv: false))
                labels.append(makeAttachLabel(title: "人数：", content: count, notDiv: false))
                labels.append(makeAttachLabel(title: "地址：", content: attachments.address, notDiv: true))
                labels.append(makeAttachLink(title: "报名链接：", content: attachments.registrationLink, notDiv: true))
                
                let item = QXTwoColLabelsItem()
                item.leftMargin = 12.5
                item.rightMargin = 12.5
                item.topMargin = 0
                item.bottomMargin = 0
                item.colMargin = 20
                item.rowMargin = 10
                item.totalWidth = kScreenW
                item.labels = labels
                attachmentsFrame = CGRect(x: 0, y: offsetY, width: kScreenW, height: item.viewHeight)
                self.attachmentsItem = item
                text = attachments.descri
                pics = model.pictures

            case.manpower:
                var labels = [QXTwoColLabel]()
                let attachments = model.attachments as! ArticleManpowerAttachments
                
                let round = TinSearch(code: attachments.round, inKeys: kProjectInvestTypeKeys)?.name
                let requiredAge = TinSearch(code: attachments.requiredAge, inKeys: kManPowerYearKeys)?.name
                let requiredDegree = TinSearch(code: attachments.requiredDegree, inKeys: kManPowerDegreeKeys)?.name
                let salary = TinSearch(code: attachments.salary, inKeys: kManPowerSalaryKeys)?.name
                
                labels.append(makeCompanyLink(title: "公司：", company: attachments.companyName, id: attachments.companyId, notDiv: true))
                labels.append(makeAttachLabel(title: "职位：", content: attachments.duty, notDiv: false))
                labels.append(makeAttachLabel(title: "公司轮次：", content: round, notDiv: false))
                labels.append(makeAttachLabel(title: "职位地点：", content: attachments.address, notDiv: false))
                labels.append(makeAttachLabel(title: "要求年限：", content: requiredAge, notDiv: false))
                labels.append(makeAttachLabel(title: "要求学历：", content: requiredDegree, notDiv: false))
                labels.append(makeAttachLabel(title: "职位薪资：", content: salary, notDiv: false))
                let item = QXTwoColLabelsItem()
                item.leftMargin = 12.5
                item.rightMargin = 12.5
                item.topMargin = 0
                item.bottomMargin = 0
                item.colMargin = 20
                item.rowMargin = 10
                item.totalWidth = kScreenW
                item.labels = labels
                attachmentsFrame = CGRect(x: 0, y: offsetY, width: kScreenW, height: item.viewHeight)
                self.attachmentsItem = item
                text = attachments.descri
                pics = model.pictures

            case.project:
                var labels = [QXTwoColLabel]()
                let attachments = model.attachments as! ArticleProjectAttachments
                
                
                let signedIssue: String?
                if TinSearch(code: attachments.userType, inKeys: kUserRoleTypeKeys)?.name == "FA" {
                    signedIssue = TinSearch(code: attachments.signedIssue, inKeys: kFAProjectSignedIssueKeys)?.name
                } else {
                    signedIssue = TinSearch(code: attachments.signedIssue, inKeys: kCompanySignedIssueKeys)?.name
                }
                let dealType = TinSearch(code: attachments.dealType, inKeys: kProjectDealTypeKeys)?.name
                let investStockRatio = SafeUnwarp(attachments.investStockRatio, holderForNull: 0)
                let commission = SafeUnwarp(attachments.commission, holderForNull: 0)

                let currentRound: String?
                if dealType == "并购收购" {
                    currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectMergeTypeKeys)?.name
                } else {
                    currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectInvestTypeKeys)?.name
                }
                let lastRound: String?
                if dealType == "并购收购" {
                    lastRound = TinSearch(code: attachments.lastRound, inKeys: kProjectMergeTypeKeys)?.name
                } else {
                    lastRound = TinSearch(code: attachments.lastRound, inKeys: kProjectInvestTypeKeys)?.name
                }
                
                let currency = TinSearch(code: attachments.currency, inKeys: kCurrencyTypeKeys)?.name
                
                let money: String?
                let n = StaticCellTools.doubleToNatureMoney(n: SafeUnwarp(attachments.currencyAmount, holderForNull: 0))
                if currency == "人民币" {
                    money = "¥" + n
                } else if currency == "美元" {
                    money = "$" + n
                } else if currency == "欧元" {
                    money = "€" + n
                } else {
                    money = n
                }
                var preferCurrency: String = ""
                if attachments.preferCurrency.count > 0 {
                    for i in attachments.preferCurrency {
                        if let name = TinSearch(code: i, inKeys: kCurrencyTypeKeys)?.name {
                            preferCurrency += name + "/"
                        }
                    }
                    if preferCurrency.characters.count > 1 {
                        preferCurrency = preferCurrency.substring(to: preferCurrency.index(preferCurrency.endIndex, offsetBy: -1))
                    }
                }
                
                var industries: String = ""
                if attachments.preferCurrency.count > 0 {
                    for i in attachments.industries {
                        if let name = i.name {
                            industries += name + " | "
                        }
                    }
                    if industries.characters.count > 3 {
                        industries = industries.substring(to: industries.index(industries.endIndex, offsetBy: -3))
                    }
                }
                
                if let signedIssue = signedIssue {
                    labels.append(makeAttachLabel(title: "签约情况：", content: signedIssue, notDiv: true))
                }
                labels.append(makeAttachLabel(title: "项目名称：", content: attachments.name, notDiv: true))
                labels.append(makeCompanyLink(title: "标的公司：", company: attachments.companyName, id: attachments.companyId, notDiv: true))
                labels.append(makeAttachLabel(title: "项目地点：", content: attachments.location, notDiv: false))
                labels.append(makeAttachLabel(title: "项目类型：", content: dealType, notDiv: false))
                labels.append(makeAttachLabel(title: "交易后股权比例：", content: "\(investStockRatio)%", notDiv: false))
                labels.append(makeAttachLabel(title: "本轮交易：", content: currentRound, notDiv: false))
                labels.append(makeAttachLabel(title: "交易金额：", content: money, notDiv: false))
                labels.append(makeAttachLabel(title: "币种偏好：", content: preferCurrency, notDiv: false))
                labels.append(makeAttachLabel(title: "行业分类：", content: industries, notDiv: true))
                labels.append(makeAttachLabel(title: "项目佣金：", content: "\(commission)%", notDiv: false))
                labels.append(makeAttachLabel(title: "上轮交易：", content: lastRound, notDiv: false))

                let item = QXTwoColLabelsItem()
                item.leftMargin = 12.5
                item.rightMargin = 12.5
                item.topMargin = 0
                item.bottomMargin = 0
                item.colMargin = 20
                item.rowMargin = 10
                item.totalWidth = kScreenW
                item.labels = labels
                attachmentsFrame = CGRect(x: 0, y: offsetY, width: kScreenW, height: item.viewHeight)
                self.attachmentsItem = item
                //text = attachments.descri
                text = nil
                pics = [Picture]()
                
            default:
                text = nil
                pics = [Picture]()
                break
            }
        }
        
        offsetY += attachmentsFrame.height + (model.type == .normal ? 0 : 10)
        do {
            let w: CGFloat
            if model.type == .normal {
                let w = kScreenW - lrMargin * 2
                let sizeAttr = StringTool.size(text, attriDic: contentAttriDic, maxWidth: w)
                contentAttriStri = sizeAttr.attriStr
                let heightOf3Lines = StringTool.size("测\n测\n测", attriDic: contentAttriDic, maxWidth: w).size.height
                if sizeAttr.size.height > heightOf3Lines + 5 {
                    isNeedsFolder = true
                } else {
                    isNeedsFolder = false
                }
                if isNeedsFolder && isFold {
                    contentFrame = CGRect(x: lrMargin, y: offsetY, width: w, height: heightOf3Lines)
                } else {
                    contentFrame = CGRect(x: lrMargin, y: offsetY, width: w, height: sizeAttr.size.height)
                }
                
            } else {
                w = kScreenW - lrMargin * 2 - 10 * 2
                let sizeAttr = StringTool.size(text, attriDic: contentAttriDicSmall, maxWidth: w)
                contentAttriStri = sizeAttr.attriStr
                let heightOf3Lines = StringTool.size("测\n测\n测", attriDic: contentAttriDicSmall, maxWidth: w).size.height
                if sizeAttr.size.height > heightOf3Lines + 5 {
                    isNeedsFolder = true
                } else {
                    isNeedsFolder = false
                }
                if isNeedsFolder && isFold {
                    contentFrame = CGRect(x: lrMargin + 10, y: offsetY + 10, width: w, height: heightOf3Lines)
                } else {
                    contentFrame = CGRect(x: lrMargin + 10, y: offsetY + 10, width: w, height: sizeAttr.size.height)
                }
            }
           
        }
        
        if model.type != .normal {
            offsetY += 10
        }
        offsetY += contentFrame.size.height
        do {
            if isNeedsFolder {
                if model.type == .normal {
                    folderFrame = CGRect(x: lrMargin, y: offsetY, width: 50, height: 30)
                } else {
                    folderFrame = CGRect(x: lrMargin + 10, y: offsetY, width: 50, height: 30)
                }
                contentBackFrame = CGRect(x: lrMargin, y: contentFrame.minY - 10, width: kScreenW - lrMargin * 2, height: folderFrame.maxY - contentFrame.minY + 10)
            } else {
                folderFrame = CGRect.zero
                
                if text != nil {
                    contentBackFrame = CGRect(x: lrMargin, y: contentFrame.minY - 10, width: kScreenW - lrMargin * 2, height: contentFrame.height + 10 * 2)
                } else {
                    contentBackFrame = CGRect.zero
                }
                
            }
            
        }
        
        if model.type == .normal {
            offsetY += text == nil ? 0 : (isNeedsFolder ? 10 + 30 : 10)
        } else {
            offsetY += text == nil ? 0 : (isNeedsFolder ? 10 + 30 : 20)
        }
        
        do {
            if pics.count > 0 {
                let item = SpeedDialImagesItem()
                item.xMargin = 5
                item.yMargin = 5
                let size = (kScreenW - lrMargin - lrMargin - 10 * 2) / 3
                item.itemSize = CGSize(width: size, height: size)
                item.pictures = pics
                item.update()
                imagesFrame = CGRect(x: lrMargin, y: offsetY, width: item.viewSize.width, height: item.viewSize.height)
                imagesItem = item
            } else {
                imagesItem = nil
                imagesFrame = CGRect.zero
            }
        }
        
        offsetY += imagesFrame.size.height + (pics.count > 0 ? 10 : 0)
        offsetY += 10
        
        do {
            projectPointsBreakFrame = CGRect.zero
            projectPointsViewFrame = CGRect.zero
            if model.type == .project {
                projectPointsBreakFrame = CGRect(x: 0, y: offsetY, width: kScreenW, height: 1)
                projectPointsViewFrame = CGRect(x: 0, y: offsetY + 1, width: kScreenW, height: ProjectPointsView.height)
                offsetY += (1 + ProjectPointsView.height)
            }
        }
        
        do {
            breakFrame = CGRect(x: 0, y: offsetY, width: kScreenW, height: 10)
            segFrame = CGRect(x: 0, y: offsetY + 10, width: kScreenW, height: 40)
        }
        
        let show = ArticleDetailHelper.checkListShow(article: model)
        showView = show.see
        
        viewHeight = segFrame.maxY
    }
    
    
    var tagComment: Bool = true
    var showView: Bool = true
    
    var commentItems: [IndustryArticleDetailCommentItem] = [IndustryArticleDetailCommentItem]()
    var commentLoadingStatus: LoadStatus = .loading
    var commentLastDate: String?
    var commentThereIsMore: Bool = true
    
    var agreeItems: [IndustryArticleDetailAgreeItem] = [IndustryArticleDetailAgreeItem]()
    var agreeLoadingStatus: LoadStatus = .loading
    var agreeLastDate: String?
    var agreeThereIsMore: Bool = true
    
    var viewItems: [IndustryArticleDetailViewItem] = [IndustryArticleDetailViewItem]()
    var viewLoadingStatus: LoadStatus = .loading
    var viewLastDate: String?
    var viewThereIsMore: Bool = true
    
    func makeAttachLabel(title: String?, content: String?, notDiv: Bool = false) -> QXTwoColLabel {
        let label = QXTwoColLabel()
        label.title = title
        label.content = content
        label.notDiv = notDiv
        label.titleAttriDic  = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: HEX("#666666")
        ]
        label.contentAttriDic = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: HEX("#333333")
        ]
        return label
    }
    func makeAttachLink(title: String?, content: String?, notDiv: Bool = false) -> QXTwoColLabel {
        let label = QXTwoColLabel()
        label.title = title
        label.content = content
        label.notDiv = notDiv
        label.titleAttriDic  = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: HEX("#666666")
        ]
        label.contentAttriDic = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: kClrBlue
        ]
        label.attachment = content
        return label
    }
    func makeCompanyLink(title: String?, company: String?, id: Int?, notDiv: Bool = false) -> QXTwoColLabel {
        let label = QXTwoColLabel()
        label.title = title
        label.notDiv = notDiv
        label.titleAttriDic  = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: HEX("#666666")
        ]
        let contentAttriDic = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: HEX("#333333")
        ]
        let bounds = CGRect(x: 0, y: -2, width: 13, height: 13)
        let mAtt = NSMutableAttributedString()
        if let company = company {
            let attr = NSAttributedString(string: company, attributes: contentAttriDic)
            mAtt.append(attr)
        }
        if let id = id {
            if id != 0 {
                label.attachment = id
                let attr = NSAttributedString(string: " ", attributes: contentAttriDic)
                mAtt.append(attr)
                let img = AttributedStringTool.notNullAttributedImage(named: "relevanceBlue", bounds: bounds)
                mAtt.append(img)
            }
        }
        label.attributedContent = mAtt
        return label
    }
    
}

class IndustryArticleDetailHeaderView: UIView {
    
    var respondCompany: ((_ id: Int) -> ())?
    var respondUrl: ((_ url: String) -> ())?
    
    var item: IndustryArticleDetailItem! {
        didSet {
            iconView.iconView.fullPath = item.model.user.avatar
            titleLabel.attributedText = item.titleAttri

            speakerIcon.isHidden = !(item.model.broadcast == true)
            
            industryLabel.norTitlefont = item.industryFont
            industryLabel.dowTitlefont = item.industryFont
            let indName = SafeUnwarp(item.industryText, holderForNull: "")
            if indName.characters.count > 0 {
                industryLabel.title = indName
                industryLabel.isHidden = false
                switch item.model.type {
                case .normal:
                    industryLabel.isHidden = false
                    projectImage.isHidden = true
                    industryLabel.norBorderColor = HEX("#fda271")
                    industryLabel.dowBorderColor = HEX("#fda271")
                    industryLabel.norBgColor = UIColor.clear
                    industryLabel.dowBgColor = UIColor.clear
                    industryLabel.norTitleColor = HEX("#fda271")
                    industryLabel.dowTitleColor = HEX("#fda271")
                    industryBtn.isUserInteractionEnabled = true
                case .manpower:
                    industryLabel.isHidden = false
                    projectImage.isHidden = true
                    industryLabel.norBorderColor = HEX("#71bdfd")
                    industryLabel.dowBorderColor = HEX("#71bdfd")
                    industryLabel.norBgColor = HEX("#71bdfd")
                    industryLabel.dowBgColor = HEX("#71bdfd")
                    industryLabel.norTitleColor = kClrWhite
                    industryLabel.dowTitleColor = kClrWhite
                    industryBtn.isUserInteractionEnabled = false
                case .activity:
                    industryLabel.isHidden = false
                    projectImage.isHidden = true
                    industryLabel.norBorderColor = HEX("#7173fd")
                    industryLabel.dowBorderColor = HEX("#7173fd")
                    industryLabel.norBgColor = HEX("#7173fd")
                    industryLabel.dowBgColor = HEX("#7173fd")
                    industryLabel.norTitleColor = kClrWhite
                    industryLabel.dowTitleColor = kClrWhite
                    industryBtn.isUserInteractionEnabled = false
                case .project:
                    industryLabel.isHidden = true
                    projectImage.isHidden = false
                    industryBtn.isUserInteractionEnabled = false
                default:
                    industryLabel.isHidden = false
                    projectImage.isHidden = true
                    break
                }
                
            } else {
                industryLabel.title = nil
                industryLabel.isHidden = true
            }
            
            
            let roleType = TinSearch(code: item.model.user.roleType, inKeys: kUserRoleTypeKeys)?.name
            roleLabel.norTitlefont = item.roleFont
            if let roleType = roleType {
                if roleType == "企业" {
                    roleLabel.title = "企业"
                    roleLabel.norBorderColor = HEX("#70bbea")
                    roleLabel.dowBorderColor = HEX("#70bbea")
                    roleLabel.norTitleColor = HEX("#3c9cd9")
                    roleLabel.dowTitleColor = HEX("#3c9cd9")
                } else if roleType == "机构" {
                    roleLabel.title = "机构"
                    roleLabel.norBorderColor = HEX("#7ad7d6")
                    roleLabel.dowBorderColor = HEX("#7ad7d6")
                    roleLabel.norTitleColor = HEX("#4dc3c2")
                    roleLabel.dowTitleColor = HEX("#4dc3c2")
                } else if roleType == "FA" {
                    roleLabel.title = "FA"
                    roleLabel.norBorderColor = HEX("#f3d37e")
                    roleLabel.dowBorderColor = HEX("#f3d37e")
                    roleLabel.norTitleColor = HEX("#e2b94a")
                    roleLabel.dowTitleColor = HEX("#e2b94a")
                } else {
                    roleLabel.title = "其他"
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
            
            contentBg.isHidden = item.model.type == .normal
            contentLabel.attributedText = item.contentAttriStri
            attachmentsView.backgroundColor = UIColor.clear
            if item.model.type == .normal {
                attachmentsView.isHidden = true
            } else {
                if let labels = item.attachmentsItem?.labels {
                    for label in labels {
                        if label.title == "标的公司：" || label.title == "公司：" {
                            label.responder = { [unowned self] id in
                                if let id = id as? Int {
                                    if id != 0 {
                                        self.respondCompany?(id)
                                    }
                                }
                            }
                        } else if label.title == "报名链接：" {
                            label.responder = { [unowned self] url in
                                if let url = url as? String {
                                    self.respondUrl?(url)
                                }
                            }
                        } else {
                            label.responder = nil
                        }
                    }
                }
                attachmentsView.item = item.attachmentsItem
                attachmentsView.isHidden = false
            }
            
            folderLabel.isHidden = !item.isNeedsFolder
            
            imagesView.item = item.imagesItem
            imagesView.isHidden = (item.imagesItem == nil)
            
            dateLabel.font = item.dateFont
            dateLabel.text = item.dateString
            
            jobLabel.font = item.jobFont
            jobLabel.text = item.jobString
            
            projectPointsBreakView.isHidden = !(item.model.type == .project)
            projectPointsView.isHidden = !(item.model.type == .project)
            projectPointsView.article = item.model

            let show = ArticleDetailHelper.checkListShow(article: item.model)
            
            if show.agree && show.comment {
                if show.agreeIsAttention {
                    segView.titleA = "关注"
                } else {
                    segView.titleA = "点赞"
                }
                segView.hideB(false)
                segView.isUserInteractionEnabled = true
                
                segView.countA = item.model.agreeCount
                segView.countB = item.model.commentCount
                
                if item.tagComment {
                    segView.currentTag = 1
                } else {
                    segView.currentTag = 0
                }
                
            } else if show.see && show.comment {
                
                segView.titleA = "查看"
                segView.titleB = "评论"
                segView.hideB(false)
                segView.isUserInteractionEnabled = true
                
                let a = SafeUnwarp(item.model.applyViewCount, holderForNull: 0)
                let b = SafeUnwarp(item.model.acceptViewCount, holderForNull: 0)
                segView.countA = a + b
                segView.countB = item.model.commentCount
                
                if item.tagComment {
                    segView.currentTag = 1
                } else {
                    segView.currentTag = 0
                }
                
            } else if show.comment && show.count == 1 {
                segView.titleA = "评论"
                segView.hideB(true)
                segView.isUserInteractionEnabled = false
                segView.currentTag = 0
                segView.countA = item.model.commentCount
            }
        }
    }
    var respondItem: ((_ item: IndustryArticleItem) -> ())?
    var respondUser: ((_ user: User) -> ())?
    var respondIndustry: ((_ industry: Industry) -> ())?
    var respondFold: ((_ item: IndustryArticleDetailItem) -> ())?
    var respondPictures: ((_ idx: Int, _ pics: [Picture]) -> ())?
    
    var respondTag: ((_ tag: Int) -> ())?
    
    lazy var topGrayView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBackGray
        return one
    }()
    lazy var iconView: RoundUserIcon = {
        let one = RoundUserIcon()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.model.user)
        })
        return one
    }()
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    lazy var jobLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrLightGray
        return one
    }()
    lazy var roleLabel: BorderButton = {
        let one = BorderButton()
        one.isUserInteractionEnabled = false
        return one
    }()
    
    lazy var speakerIcon: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "hornSmall")
        return one
    }()
    
    lazy var industryLabel: BorderButton = {
        let one = BorderButton()
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var industryBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondIndustry?(self.item.model.industry)
        })
        return one
    }()
    
    lazy var projectImage: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "xmRight")
        return one
    }()
    
    lazy var attachmentsView: QXTwoColLabelsView = {
        let one = QXTwoColLabelsView()
        one.backgroundColor = HEX("#f4faff")
        return one
    }()
    
    lazy var contentBg: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#ededf1")
        one.layer.cornerRadius = 4
        return one
    }()
    lazy var contentLabel: Label = {
        let one = Label()
        one.numberOfLines = 0
        one.vertAligment = .top
        return one
    }()
    lazy var folderLabel: TitleButton = {
        let one = TitleButton()
        one.myTitleLabel.textAlignment = .left
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = HEX("#46689b")
        one.dowTitleColor = kClrLightGray
        one.norTitlefont = UIFont.systemFont(ofSize: 14)
        one.dowTitlefont = UIFont.systemFont(ofSize: 14)
        one.signal_event_touchUpInside.head({ [unowned self, unowned one] (signal) in
            self.item.isFold = !self.item.isFold
            self.item.update()
            self.respondFold?(self.item)
            if self.item.isFold {
                one.title = "展开"
            } else {
                one.title = "折叠"
            }
        })
        one.title = "展开"
        return one
    }()
    lazy var imagesView: SpeedDialImagesView = {
        let one = SpeedDialImagesView()
        one.respondIdx = { idx in
            let pic = self.item.model.pictures[idx]
            self.respondPictures?(idx, self.item.model.pictures)
        }
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.lightGray
        one.font = UIFont.systemFont(ofSize: 12)
        return one
    }()
    
    lazy var projectPointsBreakView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBackGray
        return one
    }()
    lazy var projectPointsView: ProjectPointsShowView = {
        let one = ProjectPointsShowView()
        return one
    }()
    
    lazy var breakView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBackGray
        return one
    }()
    
    lazy var segView: IndustryArticleDetailSegView = {
        let one = IndustryArticleDetailSegView()
        one.titleA = "点赞"
        one.titleB = "评论"
        one.countA = 0
        one.countB = 0
        one.currentTag = 1
        return one
    }()
    
    func handleLink(_ text: String) {
        if text.hasPrefix(kArticleLinkUser) {
            let id = text.substring(from: text.characters.index(text.startIndex, offsetBy: kArticleLinkUser.characters.count))
            for comment in item.model.comments {
                if comment.user.id == id {
                    respondUser?(comment.user)
                    return
                }
                if let user = comment.replyUser {
                    if user.id == id {
                        respondUser?(user)
                        return
                    }
                }
            }
            for agree in item.model.agrees {
                if agree.user.id == id {
                    respondUser?(agree.user)
                    return
                }
            }
        }
    }
    required init() {
        super.init(frame: CGRect.zero)
        clipsToBounds = true
        backgroundColor = kClrWhite
        addSubview(topGrayView)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(jobLabel)
        addSubview(roleLabel)
        addSubview(speakerIcon)
        
        addSubview(attachmentsView)
        addSubview(contentBg)
        addSubview(contentLabel)
        addSubview(folderLabel)
        addSubview(imagesView)
        addSubview(dateLabel)
        
        addSubview(projectImage)
        addSubview(industryLabel)
        addSubview(industryBtn)
        
        addSubview(projectPointsBreakView)
        addSubview(projectPointsView)
        
        addSubview(breakView)
        addSubview(segView)
        
        clipsToBounds = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topGrayView.frame = item.topGrayFrame
        iconView.frame = item.iconFramme
        titleLabel.frame = item.titleFramme
        jobLabel.frame = item.jobFramme
        roleLabel.frame = item.roleFramme
        speakerIcon.frame = item.speakerFramme

        industryLabel.frame = item.industryFrame
        industryBtn.frame = CGRect(x: industryLabel.frame.minX - 10, y: industryLabel.frame.minY - 10, width: industryLabel.frame.width + 20, height: industryLabel.frame.height + 20)
        
        attachmentsView.frame = item.attachmentsFrame
        contentLabel.frame = item.contentFrame
        folderLabel.frame = item.folderFrame
        imagesView.frame = item.imagesFrame
        dateLabel.frame = item.dateFrame
        
        projectPointsBreakView.frame = item.projectPointsBreakFrame
        projectPointsView.frame = item.projectPointsViewFrame

        breakView.frame = item.breakFrame
        segView.frame = item.segFrame
        
        projectImage.frame = CGRect(x: kScreenW - 23 - 7.5, y: item.topGrayFrame.maxY - 2.5, width: 23, height: 46)
        
        contentBg.frame = item.contentBackFrame
        
    }
}

class ProjectPointsShowView: ProjectPointsView {

    var respondSpot: ((_ article: Article) -> ())?
    var respondBrief: ((_ article: Article) -> ())?
    var respondPain: ((_ article: Article) -> ())?
    var respondMembers: ((_ article: Article) -> ())?
    var respondBussiness: ((_ article: Article) -> ())?
    var respondData: ((_ article: Article) -> ())?
    var respondMaketing: ((_ article: Article) -> ())?
    var respondExit: ((_ article: Article) -> ())?
    
    var article: Article? {
        didSet {
            
            if let article = article {
                if let attachments = article.attachments as? ArticleProjectAttachments {
                    
                    if NotNullText(attachments.spot) {
                        heightlightSpot(true)
                        spotBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightSpot(false)
                        spotBtn.isUserInteractionEnabled = false
                    }
                    
                    if NotNullText(attachments.brief) {
                        heightlightBrief(true)
                        briefBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightBrief(false)
                        briefBtn.isUserInteractionEnabled = false
                    }
                    
                    if NotNullText(attachments.pain) {
                        heightlightPain(true)
                        painBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightPain(false)
                        painBtn.isUserInteractionEnabled = false
                    }
                    
                    if NotNullText(attachments.members) {
                        heightlightMembers(true)
                        memebersBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightMembers(false)
                        memebersBtn.isUserInteractionEnabled = false
                    }
                    
                    if NotNullText(attachments.bussiness) {
                        heightlightBussiness(true)
                        bussinessBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightBussiness(false)
                        bussinessBtn.isUserInteractionEnabled = false
                    }
                    
                    if NotNullText(attachments.data) {
                        heightlightData(true)
                        dataBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightData(false)
                        dataBtn.isUserInteractionEnabled = false
                    }
                    
                    if NotNullText(attachments.marketing) {
                        heightlightMarketing(true)
                        marketingBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightMarketing(false)
                        marketingBtn.isUserInteractionEnabled = false
                    }
                    
                    if NotNullText(attachments.exit) {
                        heightlightExit(true)
                        exitBtn.isUserInteractionEnabled = true
                    } else {
                        heightlightExit(false)
                        exitBtn.isUserInteractionEnabled = false
                    }
                }
                
                if NotNullText((article.attachments as? ArticleProjectAttachments)?.spot) {
                    spotBtn.iconView.image = UIImage(named: "xmld_sel")
                    spotBtn.isUserInteractionEnabled = true
                    heightlightSpot(true)
                } else {
                    heightlightSpot(false)
                }
                
                if NullText((article.attachments as? ArticleProjectAttachments)?.spot) && article.pictures.count <= 0  {
                    heightlightBrief(false)
                    briefBtn.isUserInteractionEnabled = false
                } else {
                    heightlightBrief(true)
                    briefBtn.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    required init() {
        super.init()
        spotBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondSpot?(article)
            }
        }
        briefBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondBrief?(article)
            }
        }
        painBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondPain?(article)
            }
        }
        memebersBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondMembers?(article)
            }
        }
        bussinessBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondBussiness?(article)
            }
        }
        dataBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondData?(article)
            }
        }
        marketingBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondMaketing?(article)
            }
        }
        exitBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            if let article = self.article {
                self.respondExit?(article)
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

