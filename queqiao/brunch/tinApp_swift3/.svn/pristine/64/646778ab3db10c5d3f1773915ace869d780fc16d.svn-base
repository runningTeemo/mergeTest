//
//  IndustryArticleCell.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

let kLinkLabelForCalc: LinkLabel = LinkLabel()
let kArticleLinkMore: String = "more:"
let kArticleLinkUser: String = "user:"
let kArticleLinkComment: String = "comment:"
let kArticleLinkAgree: String = "agree"

class IndustryArticleItem {
    
    let model: Article
    
    var isNeedsFolder: Bool = false
    var isFold: Bool = true
    
    var canAgree: Bool = true
    var canView: Bool = true

    fileprivate(set) var iconFramme: CGRect = CGRect.zero
    
    let titleAttriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16),
        NSForegroundColorAttributeName: HEX("#46689b"),
    ]
    fileprivate(set) var titleFramme: CGRect = CGRect.zero
    fileprivate(set) var titleAttri: NSAttributedString?

    let jobFont: UIFont = UIFont.systemFont(ofSize: 12)
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
    fileprivate(set) var contentAttriStri: NSAttributedString?
    fileprivate(set) var contentFrame: CGRect = CGRect.zero
    
    fileprivate(set) var projectFrame: CGRect = CGRect.zero
    fileprivate(set) var projectAttriStri: NSAttributedString?

    fileprivate(set) var projectDescFrame: CGRect = CGRect.zero
    fileprivate(set) var projectDescAttriStri: NSAttributedString?
    let projectDescAttriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 12),
        NSForegroundColorAttributeName: kClrDeepGray,
        NSParagraphStyleAttributeName: {
            let one = NSMutableParagraphStyle()
            one.lineSpacing = 2
            one.lineBreakMode = .byWordWrapping
            one.alignment = .justified
            return one
        }()
    ]
    
    fileprivate(set) var attachmentsItem: QXTwoColLabelsItem?
    fileprivate(set) var attachmentsFrame: CGRect = CGRect.zero

    fileprivate(set) var folderFrame: CGRect = CGRect.zero
    
    fileprivate(set) var imagesItem: SpeedDialImagesItem?
    fileprivate(set) var imagesFrame: CGRect = CGRect.zero

    let dateFont: UIFont = UIFont.systemFont(ofSize: 12)
    fileprivate(set) var dateFrame: CGRect = CGRect.zero
    fileprivate(set) var dateString: String?
    
    fileprivate(set) var agreeBtnFrame: CGRect = CGRect.zero
    fileprivate(set) var commentBtnFrame: CGRect = CGRect.zero
    fileprivate(set) var shareBtnFrame: CGRect = CGRect.zero
    fileprivate(set) var viewBtnFrame: CGRect = CGRect.zero
    let toolBtnFont: UIFont = UIFont.systemFont(ofSize: 13)
    fileprivate(set) var agreeText: String?
    fileprivate(set) var commentText: String?
    fileprivate(set) var shareText: String?
    fileprivate(set) var viewText: String?

    var agreesAttriCache: NSAttributedString?
    var commentsAttriCache: NSAttributedString?
    let norColor: UIColor = HEX("#333333")
    let linkColor: UIColor = HEX("#46689b")
    let commentFont: UIFont = UIFont.systemFont(ofSize: 14)
    let agreeFont: UIFont = UIFont.systemFont(ofSize: 14)
    fileprivate(set) var agreesFrame: CGRect = CGRect.zero
    fileprivate(set) var commentsFrame: CGRect = CGRect.zero
    
    fileprivate(set) var lineFrame: CGRect = CGRect.zero
    fileprivate(set) var topLineFrame: CGRect = CGRect.zero
    
    fileprivate(set) var cellHeight: CGFloat = 200
    
    init(model: Article) {
        self.model = model
        update()
    }
    
    func checkOrAppendByName(agree: Agree) {
        var notExsit: Bool = true
        for _agree in model.agrees {
            if SafeUnwarp(agree.user.realName, holderForNull: "") == SafeUnwarp(_agree.user.realName, holderForNull: "") {
                notExsit = false
            }
        }
        if notExsit {
            model.agrees.insert(agree, at: 0)
        }
        update()
    }
    
    func checkOrRemoveByName(agree: Agree) {
        var idx: Int?
        for i in 0..<model.agrees.count {
            let _agree = model.agrees[i]
            if SafeUnwarp(agree.user.realName, holderForNull: "") == SafeUnwarp(_agree.user.realName, holderForNull: "") {
                idx = i
            }
        }
        if let i = idx {
            model.agrees.remove(at: i)
        }
        update()
    }
    
    func append(comment: Comment) {
        model.comments.insert(comment, at: 0)
        update()
    }
    
    func update() {
        
        let tbMargin: CGFloat = 15
        let lrMargin: CGFloat = 12.5
        let iconSize = CGSize(width: 45, height: 45)

        var offsetY: CGFloat = 0
        
        topLineFrame = CGRect(x: 0, y: 0, width: kScreenW, height: 10)
        
        iconFramme = CGRect(x: lrMargin, y: tbMargin + 10, width: iconSize.width, height: iconSize.height)
        
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
                // 正常不存在
                industryText = "全部"
            }
            var w = StringTool.size(industryText, font: industryFont).size.width + 10 * 2
            w = max(w, 40)
            let x = kScreenW - lrMargin - w
            industryFrame = CGRect(x: x, y: tbMargin + 10, width: w, height: 20)
        }
        do {
            var speakerSize = CGSize.zero
            if model.broadcast == true {
                speakerSize = CGSize(width: 25, height: 17)
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
                let dutyAttri = StringTool.size(duty, attriDic: titleAttriDic).attriStr!
                mAttr.append(dutyAttri)
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
                jobString = company //+ "/" + job
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
        
        offsetY += iconFramme.maxY + 15
        let text: String?
        let pics: [Picture]
        do {
            attachmentsFrame = CGRect.zero
            projectFrame = CGRect.zero
            projectDescFrame = CGRect.zero
            projectDescAttriStri = nil
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
                labels.append(makeAttachLabel(title: "活动：", content: attachments.name, notDiv: true))
                labels.append(makeAttachLabel(title: "时间：", content: date, notDiv: true))
                labels.append(makeAttachLabel(title: "场馆：", content: attachments.venue, notDiv: true))
                labels.append(makeAttachLabel(title: "地址：", content: attachments.address, notDiv: true))
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
                text = nil
                pics = [Picture]()

            case.manpower:
                var labels = [QXTwoColLabel]()
                let attachments = model.attachments as! ArticleManpowerAttachments
                let round = TinSearch(code: attachments.round, inKeys: kProjectInvestTypeKeys)?.name
                let requiredAge = TinSearch(code: attachments.requiredAge, inKeys: kManPowerYearKeys)?.name
                let requiredDegree = TinSearch(code: attachments.requiredDegree, inKeys: kManPowerDegreeKeys)?.name
                let salary = TinSearch(code: attachments.salary, inKeys: kManPowerSalaryKeys)?.name
                
                labels.append(makeAttachLabel(title: "公司：", content: attachments.companyName, notDiv: true))
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
                text = nil
                pics = [Picture]()

            case.project:
                
                let attachments = model.attachments as! ArticleProjectAttachments
                
                let dealType = TinSearch(code: attachments.dealType, inKeys: kProjectDealTypeKeys)?.name
                let investStockRatio = SafeUnwarp(attachments.investStockRatio, holderForNull: 0)
                let investStockStr = StaticCellTools.doubleToCutZero(n: investStockRatio) + "%"

                let currentRound: String?
                if dealType == "并购收购" {
                    currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectMergeTypeKeys)?.name
                } else {
                    currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectInvestTypeKeys)?.name
                }

                let currency = TinSearch(code: attachments.currency, inKeys: kCurrencyTypeKeys)?.name
                
                let money: String?
                let amount = SafeUnwarp(attachments.currencyAmount, holderForNull: 0)
                let n = StaticCellTools.numberToDecNumber(number: amount)
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
                            industries += name + " "
                        }
                    }
                    if industries.characters.count > 1 {
                        industries = industries.substring(to: industries.index(industries.endIndex, offsetBy: -1))
                    }
                }
                
                let titleDic = [
                    NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
                    NSForegroundColorAttributeName: kClrDeepGray
                ]
                let contentDic = [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                    NSForegroundColorAttributeName: kClrDarkGray
                ]

                let bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
                
                let title = makeProjectAttri(text: "\(SafeUnwarp(attachments.name, holderForNull: ""))\n", attriDic: titleDic)
                let locationIcon = AttributedStringTool.notNullAttributedImage(named: "xmdz", bounds: bounds)
                let location = makeProjectAttri(text: "  \(SafeUnwarp(attachments.location, holderForNull: ""))\t\t", attriDic: contentDic)
                let roundIcon = AttributedStringTool.notNullAttributedImage(named: "xmlx", bounds: bounds)
                let round = makeProjectAttri(text: "  \(SafeUnwarp(currentRound, holderForNull: ""))\n", attriDic: contentDic)
                let moneyIcon = AttributedStringTool.notNullAttributedImage(named: "xmgm", bounds: bounds)
                let moneyStr = makeProjectAttri(text: "  \(SafeUnwarp(money, holderForNull: "")) / \(investStockStr)\n", attriDic: contentDic)
                let industryIcon = AttributedStringTool.notNullAttributedImage(named: "xmhy", bounds: bounds)
                let industry = makeProjectAttri(text: "  \(industries)", attriDic: contentDic)
                
                let mAttr = NSMutableAttributedString()
                mAttr.append(title)
                mAttr.append(AttributedStringTool.lineSpaceAttributedString(height: 10))
                mAttr.append(locationIcon)
                mAttr.append(location)
                mAttr.append(roundIcon)
                mAttr.append(round)
                mAttr.append(AttributedStringTool.lineSpaceAttributedString(height: 10))
                mAttr.append(moneyIcon)
                mAttr.append(moneyStr)
                mAttr.append(AttributedStringTool.lineSpaceAttributedString(height: 10))
                mAttr.append(industryIcon)
                mAttr.append(industry)
                
                projectAttriStri = mAttr
                let w: CGFloat = kScreenW - lrMargin * 2
                let size = AttributedStringTool.calcSize(attributedString: mAttr, maxWidth: w)
                projectFrame = CGRect(x: lrMargin, y: offsetY, width: w, height: size.height)
                projectDescFrame = CGRect(x: lrMargin, y: projectFrame.maxY + 10, width: kScreenW - lrMargin * 2, height: 54)
                
                let descri = (model.attachments as? ArticleProjectAttachments)?.brief
                projectDescAttriStri = StringTool.makeHighlightAttriText(text: descri, prefix: "<hlt>", suffix: "</hlt>", norAttriDic: projectDescAttriDic, higAttriDic: projectDescAttriDic)
                
                self.attachmentsItem = nil
                text = nil
                pics = [Picture]()

            default:
                text = nil
                pics = [Picture]()
            }
        }
        
        if model.type == .project {
            offsetY += projectFrame.height + 10 + projectDescFrame.height + 10
        } else {
            offsetY += attachmentsFrame.height + (model.type == .normal ? 0 : 10)
        }
        do {
            let w = kScreenW - lrMargin * 2
            contentAttriStri = StringTool.makeHighlightAttriText(text: text, prefix: "<hlt>", suffix: "</hlt>", norAttriDic: contentAttriDic, higAttriDic: contentAttriDic)
            let size = StringTool.size(contentAttriStri, maxWidth: w)
            let heightOf3Lines = StringTool.size("测\n测\n测", attriDic: contentAttriDic, maxWidth: w).size.height
            if size.height > heightOf3Lines + 5 {
                isNeedsFolder = true
            } else {
                isNeedsFolder = false
            }
            if isNeedsFolder && isFold {
                contentFrame = CGRect(x: lrMargin, y: offsetY, width: w, height: heightOf3Lines)
            } else {
                contentFrame = CGRect(x: lrMargin, y: offsetY, width: w, height: size.height)
            }
        }
        
        offsetY += contentFrame.size.height
        do {
            if isNeedsFolder {
                folderFrame = CGRect(x: lrMargin, y: offsetY, width: 50, height: 30)
            } else {
                folderFrame = CGRect.zero
            }
        }
        
        offsetY += text == nil ? 0 : (isNeedsFolder ? 10 + 30 : 10)
        do {
            if pics.count > 0 {
                let item = SpeedDialImagesItem()
                item.xMargin = 5
                item.yMargin = 5
                let size = (kScreenW - lrMargin * 2 - 10 * 2) / 3
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
        
        offsetY += imagesFrame.size.height + (imagesItem != nil ? 10 : 0)
        if imagesItem != nil {
            offsetY += 10
        } else if model.type != .normal {
            offsetY += 5
        }
        do {
            agreeText = nil
            commentText = nil
            shareText = nil
            viewText = nil

            if let c = model.agreeCount {
                if c > 0 {
                    if c <= 999 {
                        agreeText = "\(c)"
                    } else {
                        agreeText = "999+"
                    }
                } else {
                    if model.type == .normal {
                        agreeText = "点赞"
                    } else {
                        agreeText = "关注"
                    }
                }
            } else {
                if model.type == .normal {
                    agreeText = "点赞"
                } else {
                    agreeText = "关注"
                }
            }
            
            if let c = model.commentCount {
                if c > 0 {
                    if c <= 999 {
                        commentText = "\(c)"
                    } else {
                        commentText = "999+"
                    }
                } else {
                    commentText = "评论"
                }
            } else {
                commentText = "评论"
            }
            
            shareText = "分享"
            
            let a = SafeUnwarp(model.applyViewCount, holderForNull: 0)
            let b = SafeUnwarp(model.acceptViewCount, holderForNull: 0)

            if model.user.isMe() { // 自己可以看通过的和总数
                viewText = "\(b)/\(a + b)"
            } else { // 默认显示总查看数
                viewText = "\(a + b)"
            }
            // 公开项目显示总条数
            if let attachments = model.attachments as? ArticleProjectAttachments {
                if let t = attachments.detailPublic {
                    if t {
                        viewText = "\(a + b)"
                    }
                }
            }
            
            let btnMiniW: CGFloat = 60
            let btnH: CGFloat = 30
            
            let agreeW = max(StringTool.size(agreeText, font: toolBtnFont).size.width + 15 + 5 + 10 * 2, btnMiniW)
            let commentW = max(StringTool.size(commentText, font: toolBtnFont).size.width + 15 + 5 + 10 * 2, btnMiniW)
            let shareW = max(StringTool.size(shareText, font: toolBtnFont).size.width + 15 + 5 + 10 * 2, btnMiniW)
            let viewW = max(StringTool.size(viewText, font: toolBtnFont).size.width + 15 + 5 + 10 * 2, btnMiniW)

            agreeBtnFrame = CGRect(x: lrMargin, y: offsetY + 2.5, width: agreeW, height: btnH)
            commentBtnFrame = CGRect(x: agreeBtnFrame.maxX + 10, y: offsetY + 2.5, width: commentW, height: btnH)
            
            shareBtnFrame = CGRect(x: kScreenW - lrMargin - shareW, y: offsetY + 2.5, width: shareW, height: btnH)
            viewBtnFrame = CGRect(x: kScreenW - lrMargin - viewW, y: offsetY + 2.5, width: viewW, height: btnH)
        }
        
        offsetY += 30 + 15
        do {
            lineFrame = CGRect(x: 0, y: offsetY, width: kScreenW, height: 0.5)
        }
        
        offsetY += 10
        do {
            if let attr = makeAgreeAttriStri() {
                if model.type == .normal {
                    agreesAttriCache = attr
                    kLinkLabelForCalc.setAttributedText(attr)
                    let maxWidth = kScreenW - lrMargin * 2
                    kLinkLabelForCalc.frame = CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
                    kLinkLabelForCalc.sizeToFit()
                    let size = kLinkLabelForCalc.frame.size
                    agreesFrame = CGRect(x: lrMargin, y: offsetY, width: size.width, height: size.height)
                } else {
                    agreesFrame = CGRect.zero
                }
            } else {
                agreesFrame = CGRect.zero
            }
        }
        
        offsetY += agreesFrame.size.height + tbMargin
        
        if model.type == .project || model.agrees.count <= 0 {
            offsetY = lineFrame.minY
        }
        
//        if model.type == .normal {
//            offsetY += agreesFrame.size.height + (model.comments.count > 0 && model.agrees.count > 0 ? 10 : 0)
//        }
//        do {
//            if let attr = makeCommentsAttriStri() {
//                if model.type != .project {
//                    commentsAttriCache = attr
//                    kLinkLabelForCalc.setAttributedText(attr)
//                    let maxWidth = kScreenW - lrMargin * 2
//                    kLinkLabelForCalc.frame = CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
//                    kLinkLabelForCalc.sizeToFit()
//                    let size = kLinkLabelForCalc.frame.size
//                    commentsFrame = CGRect(x: lrMargin, y: offsetY, width: size.width, height: size.height)
//                } else {
//                    commentsFrame = CGRect.zero
//                }
//            } else {
//                commentsFrame = CGRect.zero
//            }
//        }
//        
//        offsetY += commentsFrame.size.height + tbMargin
//        
//        if model.type == .normal {
//            if model.agrees.count <= 0 && model.comments.count <= 0 {
//                offsetY -= 20
//            }
//        } else if model.type == .project {
//            offsetY = lineFrame.minY
//        } else {
//            if model.comments.count <= 0 {
//                offsetY -= 20
//            }
//        }
        
        cellHeight = offsetY
        
    }
    
    func makeAgreeAttriStri() -> NSAttributedString? {
        if model.agrees.count <= 0 { return nil }
        kLinkLabelForCalc.clean()
        
        kLinkLabelForCalc.customAppend(UIImage(named: "iconLike")!, size: CGSize(width: 14, height: 14))
        kLinkLabelForCalc.customAppend(" ", font: agreeFont, color: norColor)
        
        if model.agrees.count < 4 {
            for agree in model.agrees {
                
                let link = kArticleLinkUser + SafeUnwarp(agree.user.id, holderForNull: "")
                kLinkLabelForCalc.customAppend(SafeUnwarp(agree.user.realName, holderForNull: "匿名用户"), link: link, font: agreeFont, color: linkColor)
                kLinkLabelForCalc.customAppend(", ", font: agreeFont, color: norColor)
            }
            var attriStri = kLinkLabelForCalc.attributedText()
            attriStri = attriStri?.attributedSubstring(from: NSMakeRange(0, (attriStri?.length)! - 2))
            kLinkLabelForCalc.setAttributedText(attriStri)
            kLinkLabelForCalc.customAppend(" 觉得很赞", font: agreeFont, color: norColor)
        } else {
            for i in 0...2 {
                let agree = model.agrees[i]
                let link = kArticleLinkUser + SafeUnwarp(agree.user.id, holderForNull: "")
                kLinkLabelForCalc.customAppend(SafeUnwarp(agree.user.realName, holderForNull: "匿名用户"), link: link, font: agreeFont, color: linkColor)
                kLinkLabelForCalc.customAppend(", ", font: agreeFont, color: norColor)
            }
            var attriStri = kLinkLabelForCalc.attributedText()
            attriStri = attriStri?.attributedSubstring(from: NSMakeRange(0, (attriStri?.length)! - 2))
            kLinkLabelForCalc.setAttributedText(attriStri)
            kLinkLabelForCalc.customAppend(" 等\(model.agrees.count)人觉得很赞", font: agreeFont, color: norColor)
        }
        let attriStri = kLinkLabelForCalc.attributedText().copy()
        return attriStri as? NSAttributedString
    }
    func makeCommentsAttriStri() -> NSAttributedString? {
        if model.comments.count <= 0 { return nil }
        
        kLinkLabelForCalc.clean()
        
        if model.comments.count < 3 {
            for comment in model.comments {
                let link = kArticleLinkUser + SafeUnwarp(comment.user.id, holderForNull: "")
                let name = SafeUnwarp(comment.user.realName, holderForNull: "匿名用户")
                kLinkLabelForCalc.customAppend(name, link: link, font: commentFont, color: linkColor)
                if let reply = comment.replyUser {
                    kLinkLabelForCalc.customAppend(" 回复 ", font: commentFont, color: norColor)
                    let link1 = kArticleLinkUser + SafeUnwarp(reply.id, holderForNull: "")
                    let name = SafeUnwarp(reply.realName, holderForNull: "匿名用户")
                    kLinkLabelForCalc.customAppend(name, link: link1, font: commentFont, color: linkColor)
                }
                kLinkLabelForCalc.customAppend(" : ", font: commentFont, color: norColor)
                if let content = comment.content {
                    let link = kArticleLinkComment + SafeUnwarp(comment.user.id, holderForNull: "")
                    kLinkLabelForCalc.customAppend(content, link: link, font: commentFont, color: norColor)
                }
                kLinkLabelForCalc.customAppend("\n", font: commentFont, color: norColor)
            }
            var attriStri = kLinkLabelForCalc.attributedText()
            attriStri = attriStri?.attributedSubstring(from: NSMakeRange(0, (attriStri?.length)! - 1))
            kLinkLabelForCalc.setAttributedText(attriStri)
        } else {
            for i in 0...1 {
                let comment = model.comments[i]
                let link = kArticleLinkUser + SafeUnwarp(comment.user.id, holderForNull: "")
                let name = SafeUnwarp(comment.user.realName, holderForNull: "匿名用户")
                kLinkLabelForCalc.customAppend(name, link: link, font: commentFont, color: linkColor)
                if let reply = comment.replyUser {
                    kLinkLabelForCalc.customAppend(" 回复 ", font: commentFont, color: norColor)
                    let link1 = kArticleLinkUser + SafeUnwarp(reply.id, holderForNull: "")
                    let name = SafeUnwarp(reply.realName, holderForNull: "匿名用户")
                    kLinkLabelForCalc.customAppend(name, link: link1, font: commentFont, color: linkColor)
                }
                kLinkLabelForCalc.customAppend(" : ", font: commentFont, color: norColor)
                if let content = comment.content {
                    let link = kArticleLinkComment + SafeUnwarp(comment.user.id, holderForNull: "")
                    kLinkLabelForCalc.customAppend(content, link: link, font: commentFont, color: norColor)
                }
                kLinkLabelForCalc.customAppend("\n", font: commentFont, color: norColor)
            }
            
            let link = kArticleLinkMore
            kLinkLabelForCalc.customAppend("\n", font: UIFont.systemFont(ofSize: 3), color: norColor)
            kLinkLabelForCalc.customAppend("查看更多", link: link, font: commentFont, color: linkColor)
        }
        let attriStri = kLinkLabelForCalc.attributedText().copy()
        return attriStri as? NSAttributedString
    }
    
    func makeAttachLabel(title: String?, content: String?, notDiv: Bool = false) -> QXTwoColLabel {
        let label = QXTwoColLabel()
        label.title = title
        label.notDiv = notDiv
        label.titleAttriDic  = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: HEX("#666666")
        ]
        label.contentAttriDic = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: HEX("#333333")
        ]
        label.attributedContent = StringTool.makeHighlightAttriText(text: content, prefix: "<hlt>", suffix: "</hlt>", norAttriDic: label.contentAttriDic, higAttriDic: label.contentAttriDic)
        return label
    }
    
    
    func makeProjectAttri(text: String?, attriDic: [String: AnyObject]) -> NSAttributedString {
        if let attri = StringTool.makeHighlightAttriText(text: text, prefix: "<hlt>", suffix: "</hlt>", norAttriDic: attriDic, higAttriDic: attriDic) {
            return attri
        }
        return NSAttributedString()
    }
    
}

class IndustryArticleCell: RootTableViewCell {
    
    var item: IndustryArticleItem! {
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
            
            contentLabel.attributedText = item.contentAttriStri

            if item.model.type == .normal {
                projectLabel.isHidden = true
                projectDescriLabel.isHidden = true
                attachmentsView.isHidden = true
            } else if item.model.type == .project {
                projectLabel.isHidden = false
                projectDescriLabel.isHidden = false
                attachmentsView.isHidden = true
                projectLabel.attributedText = item.projectAttriStri
             
                projectDescriLabel.attributedText = item.projectDescAttriStri
                
            } else {
                attachmentsView.item = item.attachmentsItem
                attachmentsView.isHidden = false
                projectDescriLabel.isHidden = true
                projectLabel.isHidden = true
                attachmentsView.backgroundColor = UIColor.clear
            }
            
            folderLabel.isHidden = !item.isNeedsFolder
            
            imagesView.item = item.imagesItem
            imagesView.isHidden = (item.imagesItem == nil)
            
            dateLabel.font = item.dateFont
            dateLabel.text = item.dateString
            
            jobLabel.font = item.jobFont
            jobLabel.text = item.jobString
            
            if item.canAgree {
                agreeBtn.alpha = 1
                agreeBtn.isEnabled = true
            } else {
                agreeBtn.alpha = 0.5
                agreeBtn.isEnabled = false
            }
            if item.canView {
                viewBtn.alpha = 1
                viewBtn.isEnabled = true
            } else {
                viewBtn.alpha = 0.5
                viewBtn.isEnabled = false
            }
            
            if SafeUnwarp(item.model.isAgree, holderForNull: false) {
                if item.model.type == .normal {
                    agreeBtn.iconView.image = UIImage(named: "iconLikeSelect")
                } else {
                    agreeBtn.iconView.image = UIImage(named: "followSelect")
                }
            } else {
                if item.model.type == .normal {
                    agreeBtn.iconView.image = UIImage(named: "iconLike")
                } else {
                    agreeBtn.iconView.image = UIImage(named: "follow")
                }
            }

            agreeBtn.myTitleLabel.text = item.agreeText
            shareBtn.myTitleLabel.text = item.shareText
            commentBtn.myTitleLabel.text = item.commentText
            viewBtn.myTitleLabel.text = item.viewText
            
            do {
                viewBtn.isUserInteractionEnabled = true
                switch item.model.viewType {
                case .notApply:
                    viewBtn.iconView.image = UIImage(named: "xmEyes1")
                case .applying:
                    viewBtn.iconView.image = UIImage(named: "xmEyes2")
                case .success:
                    viewBtn.isUserInteractionEnabled = false
                    viewBtn.iconView.image = UIImage(named: "xmEyes3")
                }
                
                if ArticleDetailHelper.canView(article: item.model) {
                    viewBtn.isUserInteractionEnabled = false
                    viewBtn.iconView.image = UIImage(named: "xmEyes3")
                }
                
            }
            
            agreeBtn.setNeedsLayout()
            agreeBtn.layoutIfNeeded()
            commentBtn.setNeedsLayout()
            commentBtn.layoutIfNeeded()
            shareBtn.setNeedsLayout()
            shareBtn.layoutIfNeeded()
            viewBtn.layoutSubviews()
            
            shareBtn.isHidden = (item.model.type == .project)
            viewBtn.isHidden = !shareBtn.isHidden

            if let attriStr = item.agreesAttriCache {
                agreesView.setAttributedText(attriStr)
                agreesView.isHidden = false
            } else {
                agreesView.isHidden = true
            }
            
            if let attriStr = item.commentsAttriCache {
                commentsView.setAttributedText(attriStr)
                commentsView.isHidden = false
            } else {
                commentsView.isHidden = true
            }

            if item.model.type == .normal {
                line.isHidden = (item.model.agrees.count <= 0 && item.model.comments.count <= 0)
            } else {
                line.isHidden = (item.model.comments.count <= 0)
            }
            
        }
    }
    
    var indexPath: IndexPath!
    
    var respondItem: ((_ item: IndustryArticleItem) -> ())?
    
    var respondComment: ((_ item: IndustryArticleItem, _ comment: Comment?, _ indexPath: IndexPath) -> ())?

    var respondAgree: ((_ item: IndustryArticleItem) -> ())?
    var respondShare: ((_ item: IndustryArticleItem) -> ())?
    var respondView: ((_ item: IndustryArticleItem) -> ())?

    var respondUser: ((_ user: User) -> ())?
    var respondIndustry: ((_ industry: Industry) -> ())?
    var respondFold: ((_ item: IndustryArticleItem) -> ())?
    var respondPictures: ((_ idx: Int, _ pics: [Picture]) -> ())?

    lazy var backBtn: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrWhite
        one.dowBgColor = kClrSlightGray
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondItem?(self.item)
        })
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
        one.textColor = HEX("#999999")
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
        one.isUserInteractionEnabled = false
        return one
    }()
    
    lazy var projectLabel: UILabel = {
        let one = UILabel()
        one.numberOfLines = 0
        return one
    }()
    lazy var projectDescriLabel: Label = {
        let one = Label()
        one.numberOfLines = 0
        one.vertAligment = .top
        one.font = UIFont.systemFont(ofSize: 12)
        one.textColor = kClrDeepGray
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var projectDescriBg: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#ededf1")
        one.layer.cornerRadius = 4
        one.isUserInteractionEnabled = false
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
        one.respondBg = { [unowned self] in
            self.hanldeCellClick()
        }
        one.respondIdx = { [unowned self] idx in
            self.respondPictures?(idx, self.item.model.pictures)
        }
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.lightGray
        return one
    }()
    lazy var agreeBtn: ArticleHandleButton = {
        let one = ArticleHandleButton()
        one.myTitleLabel.text = "点赞"
        one.iconView.image = UIImage(named: "iconLike")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondAgree?(self.item)
            })
        return one
    }()
    lazy var commentBtn: ArticleHandleButton = {
        let one = ArticleHandleButton()
        one.myTitleLabel.text = "评论"
        one.iconView.image = UIImage(named: "iconPL")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondComment?(self.item, nil, self.indexPath)
        })
        return one
    }()
    lazy var shareBtn: ArticleHandleButton = {
        let one = ArticleHandleButton()
        one.myTitleLabel.text = "分享"
        one.iconView.image = UIImage(named: "iconShare")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondShare?(self.item)
            })
        return one
    }()
    
    lazy var viewBtn: ArticleHandleButton = {
        let one = ArticleHandleButton()
        one.myTitleLabel.text = "查看"
        one.iconSize = CGSize(width: 20, height: 14)
        one.iconView.image = UIImage(named: "xmEyes2")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondView?(self.item)
        })
        return one
    }()
    
    lazy var agreesView: LinkLabel = {
        let one = LinkLabel()
        one.backgroundColor = UIColor.clear
        one.respondLinkText = { [unowned self] t in
            self.handleLink(t)
        }
        return one
    }()
    lazy var commentsView: LinkLabel = {
        let one = LinkLabel()
        one.backgroundColor = UIColor.clear
        one.respondLinkText = { [unowned self] t in
            self.handleLink(t)
        }
        return one
    }()
    
    lazy var line: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBreak
        return one
    }()
    
    lazy var topLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBackGray
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
        if text.hasPrefix(kArticleLinkMore) {
            respondItem?(item)
        }
        
        if text.hasPrefix(kArticleLinkComment) {
//            let id = text.substring(from: text.characters.index(text.startIndex, offsetBy: kArticleLinkComment.characters.count))
            //TODO:xxx
//            for comment in item.model.comments {
//                if comment.user.id == id {
//                    respondComment?(item, comment.user, indexPath)
//                    return
//                }
//            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(topLine)
        contentView.addSubview(backBtn)
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(jobLabel)
        contentView.addSubview(roleLabel)
        contentView.addSubview(speakerIcon)
        
        contentView.addSubview(projectLabel)
        contentView.addSubview(projectDescriBg)
        contentView.addSubview(projectDescriLabel)
        contentView.addSubview(attachmentsView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(folderLabel)
        contentView.addSubview(imagesView)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(projectImage)
        contentView.addSubview(industryLabel)
        contentView.addSubview(industryBtn)
        
        contentView.addSubview(agreeBtn)
        contentView.addSubview(commentBtn)
        contentView.addSubview(shareBtn)
        contentView.addSubview(viewBtn)

        contentView.addSubview(agreesView)
        contentView.addSubview(commentsView)
        
        contentView.addSubview(line)
        
        //contentView.qxRamdomColorForAllViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func hanldeCellClick() {
        self.respondItem?(self.item)
        backBtn.forceDown(true)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backBtn.forceDown(false)
        }) 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        iconView.frame = item.iconFramme
        titleLabel.frame = item.titleFramme
        jobLabel.frame = item.jobFramme
        roleLabel.frame = item.roleFramme
        speakerIcon.frame = item.speakerFramme

        industryLabel.frame = item.industryFrame
        contentLabel.frame = item.contentFrame
        projectLabel.frame = item.projectFrame
        attachmentsView.frame = item.attachmentsFrame
        projectDescriBg.frame = item.projectDescFrame
        projectDescriLabel.frame = CGRect(x: item.projectDescFrame.minX + 10, y: item.projectDescFrame.minY + 10, width: item.projectDescFrame.width - 20, height: item.projectDescFrame.height - 20)
        
        folderLabel.frame = item.folderFrame
        imagesView.frame = item.imagesFrame
        dateLabel.frame = item.dateFrame
        
        agreeBtn.frame = item.agreeBtnFrame
        commentBtn.frame = item.commentBtnFrame
        shareBtn.frame = item.shareBtnFrame
        viewBtn.frame = item.viewBtnFrame
        
        agreesView.frame = item.agreesFrame
        commentsView.frame = item.commentsFrame
        
        line.frame = item.lineFrame
        topLine.frame = item.topLineFrame
        
        industryBtn.frame = CGRect(x: industryLabel.frame.minX - 10, y: industryLabel.frame.minY - 10, width: industryLabel.frame.width + 20, height: industryLabel.frame.height + 20)
        
        backBtn.frame = CGRect(x: 0, y: topLine.frame.maxY, width: contentView.bounds.width, height: contentView.bounds.height - topLine.frame.maxY)
        
        backBtn.layer.shadowColor = HEX("#dcdcdc").cgColor
        backBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        backBtn.layer.shadowRadius = 4
        backBtn.layer.shadowOpacity = 1
        
        projectImage.frame = CGRect(x: kScreenW - 23 - 7.5, y: backBtn.frame.minY - 2.5, width: 23, height: 46)
    }
    
}

class ArticleHandleButton: ButtonBack {
    
    lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        one.image = nil
        return one
    }()
    lazy var myTitleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 13)
        one.textColor = UIColor.gray
        return one
    }()
    required init() {
        super.init()
        norBgColor = UIColor.clear
        dowBgColor = kClrSlightGray
        addSubview(iconView)
        addSubview(myTitleLabel)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var iconSize = CGSize(width: 13, height: 13)
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.size.width
        let h = bounds.size.height
        myTitleLabel.sizeToFit()
        let titleSize = myTitleLabel.frame.size
        let left = (w - iconSize.width - titleSize.width - 5) / 2
        
        iconView.frame = CGRect(x: left, y: (h - iconSize.height) / 2, width: iconSize.width, height: iconSize.height)
        let textX = iconView.frame.maxX + 5
        myTitleLabel.frame = CGRect(x: textX , y: 0, width: titleSize.width, height: h)
        layer.cornerRadius = h / 2
    }
    
}

class ArticleUpArrow: UIView {
    
    var color: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let a = CGPoint(x: rect.size.width / 2, y: 0)
        let b = CGPoint(x: 0, y: rect.size.height)
        let c = CGPoint(x: rect.size.width, y: rect.size.height)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.move(to: CGPoint(x: a.x, y: a.y))
        ctx?.addLine(to: CGPoint(x: b.x, y: b.y))
        ctx?.addLine(to: CGPoint(x: c.x, y: c.y))
        ctx?.closePath()
        ctx?.setLineWidth(0)
        color.setFill()
        ctx?.fillPath()
    }
    
}


class ArticleAttachmentsItem {
    
    var article: Article
    var viewHeight: CGFloat
    
    init(article: Article) {
        self.article = article
        self.viewHeight = 100
    }
    
}

class ArticleAttachmentsView: UIView {
    
    var item: ArticleAttachmentsItem! {
        didSet {
            
        }
    }
    let font = UIFont.systemFont(ofSize: 14)
    let titleColor = UIColor.gray
    let contetnColor = UIColor.black
    
    lazy var label0: UILabel = {
        let one = UILabel()
        
        return one
    }()
    required init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
