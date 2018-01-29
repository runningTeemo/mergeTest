//
//  ArticleDetailCells.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

//MARK:- 评论列表

class IndustryArticleDetailCommentItem {
    
    var comment: Comment
    let norColor: UIColor = HEX("#333333")
    let linkColor: UIColor = HEX("#46689b")
    let commentFont: UIFont = UIFont.systemFont(ofSize: 14)
    fileprivate(set) var cellHeight: CGFloat = 0
    fileprivate(set) var dateAttriStri: NSAttributedString?
    fileprivate(set) var commentAttriStri: NSAttributedString = NSAttributedString()
    
    fileprivate(set) var backViewFrame: CGRect = CGRect.zero
    fileprivate(set) var iconFrame: CGRect = CGRect.zero
    fileprivate(set) var titleFrame: CGRect = CGRect.zero
    fileprivate(set) var dateFrame: CGRect = CGRect.zero
    fileprivate(set) var commentFrame: CGRect = CGRect.zero
    
    init(comment: Comment) {
        self.comment = comment
        self.update()
    }
    func update() {
        let tbMargin: CGFloat = 10
        let lrMargin: CGFloat = 12.5
        let iconSize = CGSize(width: 45, height: 45)
        if let attri = makeAttri() {
            self.commentAttriStri = attri
        }
        iconFrame = CGRect(x: lrMargin, y: tbMargin, width: iconSize.width, height: iconSize.height)
        let dateString = DateTool.getNature(comment.createDate)
        let sizeStr = StringTool.size(dateString, font: UIFont.systemFont(ofSize: 12))
        dateAttriStri = sizeStr.attriStr
        let textLeft = iconFrame.maxX + 10
        dateFrame = CGRect(x: kScreenW - lrMargin - sizeStr.size.width, y: tbMargin, width: sizeStr.size.width, height: 15)
        let titleW = kScreenW - textLeft - 10 - sizeStr.size.width - lrMargin
        titleFrame = CGRect(x: textLeft, y: tbMargin, width: titleW, height: 20)
        let commentW = kScreenW - textLeft - lrMargin
        kLinkLabelForCalc.setAttributedText(self.commentAttriStri)
        kLinkLabelForCalc.frame = CGRect(x: 0, y: 0, width: commentW, height: CGFloat.greatestFiniteMagnitude)
        kLinkLabelForCalc.sizeToFit()
        let size = kLinkLabelForCalc.frame.size
        commentFrame = CGRect(x: textLeft, y: 40, width: commentW, height: size.height)
        cellHeight = commentFrame.maxY + tbMargin
        cellHeight = max(cellHeight, iconFrame.maxY + tbMargin)
        backViewFrame = CGRect(x: 0, y: 0, width: kScreenW, height: cellHeight)
    }
    
    func makeAttri() -> NSAttributedString? {
        kLinkLabelForCalc.clean()
        if let replyUser = comment.replyUser {
            kLinkLabelForCalc.customAppend("回复", font: commentFont, color: norColor)
            let link = kArticleLinkUser + SafeUnwarp(replyUser.id, holderForNull: "")
            kLinkLabelForCalc.customAppend(replyUser.realName, link: link, font: commentFont, color: linkColor)
            kLinkLabelForCalc.customAppend(": ", font: commentFont, color: norColor)
            kLinkLabelForCalc.customAppend(comment.content, font: commentFont, color: norColor)
        } else {
            kLinkLabelForCalc.customAppend(comment.content, font: commentFont, color: norColor)
        }
        let attriStri = kLinkLabelForCalc.attributedText().copy()
        return attriStri as? NSAttributedString
    }
    
}

class IndustryArticleDetailCommentCell: RootTableViewCell {
    
    var indexPath: IndexPath!
    var respondItem: ((_ item: IndustryArticleDetailCommentItem, _ indexPath: IndexPath) -> ())?
    
    var respondUser: ((_ user: User) -> ())?
    var item: IndustryArticleDetailCommentItem! {
        didSet {
            iconView.iconView.fullPath = item.comment.user.avatar
            titleLabel.title = SafeUnwarp(item.comment.user.realName, holderForNull: "匿名用户")
            commentView.setAttributedText(item.commentAttriStri)
            dateLabel.attributedText = item.dateAttriStri
        }
    }
    lazy var backView: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrWhite
        one.dowBgColor = kClrLightGray
        one.clipsToBounds = true
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondItem?(self.item, self.indexPath)
        })
        return one
    }()
    lazy var iconView: RoundUserIcon = {
        let one = RoundUserIcon()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.comment.user)
        })
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 10)
        one.textColor = HEX("#999999")
        return one
    }()
    lazy var titleLabel: TitleButton = {
        let one = TitleButton()
        one.myTitleLabel.textAlignment = .left
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = HEX("#46689b")
        one.dowTitleColor = kClrLightGray
        one.norTitlefont = kFontNormal
        one.dowTitlefont = kFontNormal
        one.isUserInteractionEnabled = false
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.comment.user)
        })
        return one
    }()
    lazy var commentView: LinkLabel = {
        let one = LinkLabel()
        one.backgroundColor = UIColor.clear
        one.respondLinkText = { [unowned self] t in
            self.handleLink(t)
        }
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentView)
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = item.backViewFrame
        iconView.frame = item.iconFrame
        titleLabel.frame = item.titleFrame
        dateLabel.frame = item.dateFrame
        commentView.frame = item.commentFrame
    }
    
    func handleLink(_ text: String) {
        if text.hasPrefix(kArticleLinkUser) {
            if let user = item.comment.replyUser {
                respondUser?(user)
            }
        }
    }
    
}

//MARK:- 点赞列表

class IndustryArticleDetailAgreeItem {
    
    let agree: Agree
    let isChat: Bool
    let norColor: UIColor = HEX("#333333")
    let linkColor: UIColor = HEX("#46689b")
    let commentFont: UIFont = UIFont.systemFont(ofSize: 14)
    fileprivate(set) var cellHeight: CGFloat = 0
    fileprivate(set) var dateAttriStri: NSAttributedString?
    fileprivate(set) var commentAttriStri: NSAttributedString = NSAttributedString()
    
    fileprivate(set) var backViewFrame: CGRect = CGRect.zero
    fileprivate(set) var iconFrame: CGRect = CGRect.zero
    fileprivate(set) var titleFrame: CGRect = CGRect.zero
    fileprivate(set) var dateFrame: CGRect = CGRect.zero
    fileprivate(set) var chatFrame: CGRect = CGRect.zero

    init(agree: Agree, isChat: Bool) {
        self.agree = agree
        self.isChat = isChat
        self.update()
    }
    func update() {
        let tbMargin: CGFloat = 10
        let lrMargin: CGFloat = 12.5
        let iconSize = CGSize(width: 45, height: 45)
        iconFrame = CGRect(x: lrMargin, y: tbMargin, width: iconSize.width, height: iconSize.height)
        let dateString: String?
        if isChat {
            dateString = DateTool.getDateTimeString(agree.createDate)
        } else {
            dateString = DateTool.getNature(agree.createDate)
        }
        let sizeStr = StringTool.size(dateString, font: UIFont.systemFont(ofSize: 12))
        dateAttriStri = sizeStr.attriStr
        let textLeft = iconFrame.maxX + 10
        let titleW = kScreenW - textLeft - 10 - sizeStr.size.width - lrMargin
        if isChat {
            titleFrame = CGRect(x: textLeft, y: tbMargin, width: titleW, height: 20)
            dateFrame = CGRect(x: textLeft, y: 40, width: sizeStr.size.width, height: 10)
            chatFrame = CGRect(x: kScreenW - 40 - 15, y: (iconFrame.maxY + tbMargin - 40) / 2, width: 40, height: 40)
        } else {
            dateFrame = CGRect(x: kScreenW - lrMargin - sizeStr.size.width, y: tbMargin, width: sizeStr.size.width, height: iconFrame.maxY)
            titleFrame = CGRect(x: textLeft, y: tbMargin + (iconSize.height - 20) / 2, width: titleW, height: 20)
            chatFrame = CGRect.zero
        }
        
        cellHeight = iconFrame.maxY + tbMargin
        backViewFrame = CGRect(x: lrMargin, y: 0, width: kScreenW, height: cellHeight)
    }
    
}

class IndustryArticleDetailAgreeCell: RootTableViewCell {
    
    var respondUser: ((_ user: User) -> ())?
    var respondChat: ((_ user: User) -> ())?

    var item: IndustryArticleDetailAgreeItem! {
        didSet {
            iconView.iconView.fullPath = item.agree.user.avatar
            titleLabel.title = SafeUnwarp(item.agree.user.realName, holderForNull: "匿名用户")
            dateLabel.attributedText = item.dateAttriStri
            chatBtn.forceDown(item.agree.user.isMe())
        }
    }

    lazy var backView: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrWhite
        one.dowBgColor = kClrLightGray
        one.clipsToBounds = true
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.agree.user)
        })
        return one
    }()
    lazy var iconView: RoundUserIcon = {
        let one = RoundUserIcon()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.agree.user)
        })
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 10)
        one.textColor = HEX("#999999")
        return one
    }()
    lazy var titleLabel: TitleButton = {
        let one = TitleButton()
        one.myTitleLabel.textAlignment = .left
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = HEX("#46689b")
        one.dowTitleColor = kClrLightGray
        one.isUserInteractionEnabled = false
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.agree.user)
        })
        return one
    }()
    lazy var chatBtn: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 30, height: 30)
        one.iconView.image = UIImage(named: "iconChat")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondChat?(self.item.agree.user)
        })
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chatBtn)
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = item.backViewFrame
        iconView.frame = item.iconFrame
        titleLabel.frame = item.titleFrame
        dateLabel.frame = item.dateFrame
        chatBtn.frame = item.chatFrame
    }
}


class ArticleDetailHandleButton: ButtonBack {
    
    lazy var iconView: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 13, height: 13)
        one.iconView.image = nil
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrSlightGray
        return one
    }()
    lazy var myTitleLabel: TitleButton = {
        let one = TitleButton()
        one.norTitlefont = UIFont.systemFont(ofSize: 13)
        one.dowTitlefont = UIFont.systemFont(ofSize: 13)
        one.norTitleColor = UIColor.gray
        one.dowTitleColor = UIColor.gray
        one.norBgColor = UIColor.clear
        one.dowBgColor = kClrSlightGray
        return one
    }()
    lazy var breakLine: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        return one
    }()
    required init() {
        super.init()
        norBgColor = UIColor.clear
        dowBgColor = kClrSlightGray
        addSubview(iconView)
        addSubview(breakLine)
        addSubview(myTitleLabel)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.size.width
        let h = bounds.size.height
        iconView.frame = CGRect(x: 0, y: 0, width: 40, height: h)
        breakLine.frame = CGRect(x: 40, y: (h - 12) / 2, width: 0.5, height: 12)
        myTitleLabel.frame = CGRect(x: 40.5, y: 0, width: w - 40.5, height: h)
        layer.cornerRadius = h / 2
    }
    
}


//MARK:- 查看列表

class IndustryArticleDetailViewItem {
    
    let view: ProjectViewCommitDataModel
    let isPublic: Bool

    fileprivate(set) var cellHeight: CGFloat = 0
    fileprivate(set) var dateAttriStri: NSAttributedString?
    
    fileprivate(set) var backViewFrame: CGRect = CGRect.zero
    fileprivate(set) var iconFrame: CGRect = CGRect.zero
    fileprivate(set) var titleFrame: CGRect = CGRect.zero
    fileprivate(set) var dateFrame: CGRect = CGRect.zero
    fileprivate(set) var chatFrame: CGRect = CGRect.zero
    fileprivate(set) var switchFrame: CGRect = CGRect.zero

    init(view: ProjectViewCommitDataModel, isPublic: Bool) {
        self.isPublic = isPublic
        self.view = view
        self.update()
    }
    func update() {
        let tbMargin: CGFloat = 10
        let lrMargin: CGFloat = 12.5
        let iconSize = CGSize(width: 45, height: 45)
        iconFrame = CGRect(x: lrMargin, y: tbMargin, width: iconSize.width, height: iconSize.height)
        let dateString = DateTool.getDateTimeString(view.createDate)
        let sizeStr = StringTool.size(dateString, font: UIFont.systemFont(ofSize: 12))
        dateAttriStri = sizeStr.attriStr
        let textLeft = iconFrame.maxX + 10
        let titleW = kScreenW - textLeft - 10 - sizeStr.size.width - lrMargin
        titleFrame = CGRect(x: textLeft, y: tbMargin, width: titleW, height: 20)
        dateFrame = CGRect(x: textLeft, y: 40, width: sizeStr.size.width, height: 10)
        
        if isPublic {
            switchFrame = CGRect.zero
            chatFrame = CGRect(x: kScreenW - 12.5 - 40, y: (iconFrame.maxY - 40) / 2, width: 40, height: 40)
        } else {
            switchFrame = CGRect(x: kScreenW - 60 - 15, y: (iconFrame.maxY + tbMargin - 40) / 2, width: 60, height: 40)
            chatFrame = CGRect(x: kScreenW - 60 - 40 - 15 - 10, y: (iconFrame.maxY - 40) / 2, width: 40, height: 40)
        }
        cellHeight = iconFrame.maxY + tbMargin
        backViewFrame = CGRect(x: 0, y: 0, width: kScreenW, height: cellHeight)
    }
    
}

class IndustryArticleDetailViewCell: RootTableViewCell {
    
    var respondUser: ((_ user: User) -> ())?
    var respondChat: ((_ user: User) -> ())?
    var respondHanlde:((_ item: IndustryArticleDetailViewItem) -> ())?
    
    var item: IndustryArticleDetailViewItem! {
        didSet {
            iconView.iconView.fullPath = item.view.user.avatar
            titleLabel.title = SafeUnwarp(item.view.user.realName, holderForNull: "匿名用户")
            dateLabel.attributedText = item.dateAttriStri
            if item.view.applyStatus == "2" {
                swith.isOn = true
            } else {
                swith.isOn = false
            }
            swith.isHidden = item.isPublic
        }
    }
    
    lazy var backView: ButtonBack = {
        let one = ButtonBack()
        one.norBgColor = kClrWhite
        one.dowBgColor = kClrLightGray
        one.clipsToBounds = true
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.view.user)
        })
        return one
    }()
    lazy var iconView: RoundUserIcon = {
        let one = RoundUserIcon()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.view.user)
        })
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 10)
        one.textColor = HEX("#999999")
        return one
    }()
    lazy var titleLabel: TitleButton = {
        let one = TitleButton()
        one.myTitleLabel.textAlignment = .left
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = HEX("#46689b")
        one.dowTitleColor = kClrLightGray
        one.isUserInteractionEnabled = false
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondUser?(self.item.view.user)
        })
        return one
    }()
    lazy var chatBtn: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 30, height: 30)
        one.iconView.image = UIImage(named: "iconChat")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondChat?(self.item.view.user)
        })
        return one
    }()
    
    lazy var swith: ZJSwitch = {
        let one = ZJSwitch()
        one.style = ZJSwitchStyle.noBorder
        one.onTintColor = MyColor.colorWithHexString("#23c966")
        one.textFont = UIFont.systemFont(ofSize: 9)
        one.onText = "打开"
        one.offText = "关闭"
        one.signal_event_valueChanged.head({ [unowned self, unowned one] (s) in
            self.respondHanlde?(self.item)
        })
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chatBtn)
        contentView.addSubview(swith)
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = item.backViewFrame
        iconView.frame = item.iconFrame
        titleLabel.frame = item.titleFrame
        dateLabel.frame = item.dateFrame
        chatBtn.frame = item.chatFrame
        swith.frame = item.switchFrame
    }
}


