//
//  AssociateToMeViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class AssociateToMeViewController: RootTableViewController {
    
    var items: [AssociatedToMeItem] = [AssociatedToMeItem]()
    var start: Int = 0
    
    var replyArticle: Article?
    var replyComment: Comment?
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        start = 0
        resetFooter()
        loadMore(done)
    }
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let user = Account.sharedOne.user
        
        ArticleManager.shareInstance.getAssociatedToMes(start: self.start, rows: 10, user: user, success: { [weak self] (code, msg, associatedToMes) in
            if code == 0 {
                if let s = self {
                    let associatedToMes = associatedToMes!
                    var newItems = [AssociatedToMeItem]()
                    for associatedToMe in associatedToMes {
                        let item = AssociatedToMeItem(model: associatedToMe)
                        newItems.append(item)
                    }
                    if s.start == 0 {
                        s.items = newItems
                    } else {
                        s.items += newItems
                    }
                    s.start += 10
                    done(s.checkOutLoadDataType(allModels: s.items, newModels: newItems))
                    s.tableView.reloadData()
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
        }
    }
    
    
    lazy var barView: NewsCommentCommentBar = {
        let one = NewsCommentCommentBar()
        one.respondComment = { [unowned self] text in
            self.handleComment(text)
        }
        return one
    }()
    lazy var coverBtn: UIButton = {
        let one = UIButton()
        one.isHidden = true
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.view.endEditing(true)
            self.replyArticle = nil
            self.replyComment = nil
            })
        return one
    }()
    
    var barViewBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "与我相关"
        setupNavBackBlackButton(nil)
        
        tableView.register(AssociatedToMeCell.self, forCellReuseIdentifier: "AssociatedToMeCell")
        
        view.addSubview(coverBtn)
        coverBtn.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        view.addSubview(barView)
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).OFFSET(barView.viewHeight).MAKE()
        
        emptyMsg = "没有相关信息"
        setupLoadingView()
        setupRefreshHeader()
        setupRefreshFooter()
        loadDataOnFirstWillAppear = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(AssociateToMeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AssociateToMeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Account.sharedOne.associateBadge = 0
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssociatedToMeCell") as! AssociatedToMeCell
        cell.item = items[indexPath.row]
        cell.respondReply = { [unowned self] article, comment, indexPath in
            if ArticleWriteLimitChecker.check(onVc: self, operation: "评论文章") {
                self.replyArticle = article
                self.replyComment = comment
                self.barView.commentField.textField.text = nil
                self.barView.commentField.textField.becomeFirstResponder()
                self.barView.commentField.textField.placeholder = "回复：" + SafeUnwarp(comment.user.realName, holderForNull: "")
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        cell.indexPath = indexPath
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        return item.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let article = items[indexPath.row].model.article
        if ArticleDetailHelper.canView(article: article) {
            let vc = ArticleDetailViewControler()
            vc.orgienArticle = article
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            QXTiper.showWarning("您无权限查看", inView: self.view, cover: true)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    fileprivate var origenFooterView: UIView?
    fileprivate var isSecondShow: Bool = false // 解决第三方键盘的多次弹出问题
    func keyboardWillShow(_ notice: Notification) {
        
        coverBtn.isHidden = false
        
        if (notice as NSNotification).userInfo == nil { return }
        
        let frame = ((notice as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant =  -frame.size.height
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            })
        
        if isSecondShow { return }
        isSecondShow = true
        // 解决第三方键盘的多次弹出问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.isSecondShow = false
        }
        // 这里有tabBar则还要-49
        let endHeight = frame.size.height
        if let footerView = tableView.tableFooterView {
            if !footerView.isKind(of: KeyboardSpaceView.self) {
                origenFooterView = footerView
            }
        }
        let footerView = KeyboardSpaceView(frame: CGRect(x: 0,y: 0,width: 0,height: endHeight))
        tableView.tableFooterView = footerView
    }
    func keyboardWillHide(_ notice: Notification) {
        
        coverBtn.isHidden = true
        
        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant = barView.viewHeight
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            })
        tableView.tableFooterView = origenFooterView
        origenFooterView = nil
        
    }
    
    
    func handleComment(_ text: String) {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.comment(text)
        }
    }
    func comment(_ text: String) {
        
        if !Account.sharedOne.isLogin { return }
        
        let me = Account.sharedOne.user
        let article = self.replyArticle!
        
        ArticleManager.shareInstance.comment(me, comment: self.replyComment, article: article, content: text, success: { [weak self] (code, message, ret) in
            if code == 0 {
                self?.barView.commentField.textField.text = nil
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }

    
}


class AssociatedToMeItem {
    
    var model: AssociatedToMe
    
    fileprivate(set) var isNormalMode: Bool = true
    fileprivate(set) var cellHeight: CGFloat = 110
    
    let roleFont: UIFont = UIFont.systemFont(ofSize: 9)
    
    fileprivate(set) var titleAttriCache: NSAttributedString?
    fileprivate(set) var roleWidth: CGFloat = 0
    fileprivate(set) var role: String?
    
    // 当前评论
    fileprivate(set) var commentAttriCache: NSAttributedString?
    // 评论列表
    fileprivate(set) var commentsTop: CGFloat = 999
    fileprivate(set) var commentsAttriCache: NSAttributedString?

    // 文章部分
    fileprivate(set) var textAttriCache: NSAttributedString?
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
    let userAttriDic = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: HEX("#46689b"),
        NSParagraphStyleAttributeName: {
            let one = NSMutableParagraphStyle()
            one.lineSpacing = 2
            one.lineBreakMode = .byWordWrapping
            one.alignment = .justified
            return one
        }()
    ]
    
    init(model: AssociatedToMe) {
        self.model = model
        update()
    }
    
    func update() {
 
        do {
            let user = model.comment.user
            let name = SafeUnwarp(user.realName, holderForNull: "匿名用户")
            var duty: String?
            if NotNullText(user.duty) {
                duty = user.duty!
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
            
            let roleType = TinSearch(code: user.roleType, inKeys: kUserRoleTypeKeys)?.name
            roleWidth = StringTool.size(roleType, font: roleFont).size.width + 5 * 2
            if roleWidth <= 12 {
                roleWidth = 0
            }
            role = roleType
        }
        
        do {
            let mAttr = NSMutableAttributedString()
            if let replyUser = model.comment.replyUser {
                mAttr.append(StringTool.makeAttributeString("回复 ", dic: textAttriDic)!)
                mAttr.append(StringTool.makeAttributeString(SafeUnwarp(replyUser.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
                mAttr.append(StringTool.makeAttributeString("：", dic: textAttriDic)!)
            }
            mAttr.append(StringTool.makeAttributeString(SafeUnwarp(model.comment.content, holderForNull: ""), dic: textAttriDic)!)
            commentAttriCache = mAttr
        }
        
        if model.comments.count == 0 {
            commentsAttriCache = nil
        } else if model.comments.count == 1 {
            commentsAttriCache = makeCommentAttriStr(comment: model.comments[0])
        } else if model.comments.count == 2 {
            let mAttr = NSMutableAttributedString()
            mAttr.append(makeCommentAttriStr(comment: model.comments[1]))
            mAttr.append(StringTool.makeAttributeString("\n", dic: textAttriDic)!)
            mAttr.append(makeCommentAttriStr(comment: model.comments[0]))
            commentsAttriCache = mAttr
        } else {
            let mAttr = NSMutableAttributedString()
            mAttr.append(makeCommentAttriStr(comment: model.comments[2]))
            mAttr.append(StringTool.makeAttributeString("\n", dic: textAttriDic)!)
            mAttr.append(makeCommentAttriStr(comment: model.comments[1]))
            mAttr.append(StringTool.makeAttributeString("\n", dic: textAttriDic)!)
            mAttr.append(makeCommentAttriStr(comment: model.comments[0]))
            commentsAttriCache = mAttr
        }

        let article = model.article
        if article.type == .normal {
            let mAttr = NSMutableAttributedString()
            mAttr.append(StringTool.makeAttributeString(SafeUnwarp(article.user.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
            if NotNullText(article.content) {
                mAttr.append(StringTool.makeAttributeString("：" + SafeUnwarp(article.content, holderForNull: ""), dic: textAttriDic)!)
            }
            attachmentsAttriCache = mAttr
            if article.pictures.count > 0 {
                attachmentsBgColor = UIColor.clear
                isNormalMode = true
                textAttriCache = mAttr
            } else {
                isNormalMode = false
                attachmentsBgColor = HEX("#ededf1")
                attachmentsAttriCache = mAttr
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
            
            if article.type == .project {
                attachmentsBgColor = HEX("#fffaf3")
                if let attachments = article.attachments as? ArticleProjectAttachments {
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(article.user.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
                    mAttr.append(StringTool.makeAttributeString("：" + SafeUnwarp(article.content, holderForNull: ""), dic: textAttriDic)!)
                    
                    let icon = AttributedStringTool.notNullAttributedImage(named: "iconXM", bounds: CGRect(x: 0, y: -5, width: 30, height: 18))
                    
                    mAttr.append(icon)
                    mAttr.append(StringTool.makeAttributeString(" ", dic: contentDic)!)
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(attachments.name, holderForNull: ""), dic: titleDic)!)
                    if article.broadcast == true {
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
                
            } else if article.type == .activity {
                attachmentsBgColor = HEX("#f2f3ff")
                if let attachments = article.attachments as? ArticleActivityAttachments {
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(article.user.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
                    mAttr.append(StringTool.makeAttributeString("：" + SafeUnwarp(article.content, holderForNull: ""), dic: textAttriDic)!)
                    
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
                
            } else if article.type == .manpower {
                attachmentsBgColor = HEX("#f3faff")
                if let attachments = article.attachments as? ArticleManpowerAttachments {
                    
                    mAttr.append(StringTool.makeAttributeString(SafeUnwarp(article.user.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
                    mAttr.append(StringTool.makeAttributeString("：" + SafeUnwarp(article.content, holderForNull: ""), dic: textAttriDic)!)
                    
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
        
        if !ArticleDetailHelper.canView(article: article) {
            attachmentsBgColor = HEX("#ededf1")
        }
        
        if isNormalMode {
            let commentH = StringTool.size(commentAttriCache, maxWidth: kScreenW - 12.5 - 12.5).height
            let commentsH = StringTool.size(commentsAttriCache, maxWidth: kScreenW - 12.5 - 12.5).height
            cellHeight = CGFloat(20 + 45 + 10 + commentH + 10 + 60 + 10 + commentsH + 20 + 10)
            if commentsAttriCache == nil {
                cellHeight -= 10
            }
        } else {
            var h = StringTool.size(attachmentsAttriCache, maxWidth: kScreenW - 12.5 - 10 - 12.5 - 10).height
            let commentH = StringTool.size(commentAttriCache, maxWidth: kScreenW - 12.5 - 12.5).height
            let commentsH = StringTool.size(commentsAttriCache, maxWidth: kScreenW - 12.5 - 12.5).height
            h += 20 + 45 + 10 + commentH + 10 + 10
            h += 10 + 10 + commentsH + 20 + 10
            if commentsAttriCache == nil {
                h -= 10
            }
            cellHeight = h
        }
        
    }
    
    func makeCommentAttriStr(comment: Comment) -> NSAttributedString {
        let mAttr = NSMutableAttributedString()
        if let replyUser = comment.replyUser {
            mAttr.append(StringTool.makeAttributeString(SafeUnwarp(comment.user.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
            mAttr.append(StringTool.makeAttributeString(" 回复 ", dic: textAttriDic)!)
            mAttr.append(StringTool.makeAttributeString(SafeUnwarp(replyUser.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
            mAttr.append(StringTool.makeAttributeString("：", dic: textAttriDic)!)
        } else {
            mAttr.append(StringTool.makeAttributeString(SafeUnwarp(comment.user.realName, holderForNull: "匿名用户"), dic: userAttriDic)!)
            mAttr.append(StringTool.makeAttributeString("：", dic: textAttriDic)!)
        }
        mAttr.append(StringTool.makeAttributeString(comment.content, dic: textAttriDic)!)
        return mAttr
    }
    
}

class AssociatedToMeCell: RootTableViewCell {
    
    var indexPath: IndexPath!
    var respondReply: ((_ article: Article, _ comment: Comment, _ indexPath: IndexPath) -> ())?
    
    var item: AssociatedToMeItem! {
        didSet {
            
            let article = item.model.article
            
            iconView.iconView.fullPath = item.model.comment.user.avatar
            titleLabel.attributedText = item.titleAttriCache
            roleWidthCons?.constant = item.roleWidth
            
            commentLabel.attributedText = item.commentAttriCache
            commentsLabel.attributedText = item.commentsAttriCache
            
            var hideReply: Bool = false
            if item.model.comment.user.isMe() {
                hideReply = true
            }
            if !ArticleDetailHelper.canView(article: item.model.article) {
                hideReply = true
            }
            replyBtn.isHidden = hideReply
            
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
            
            if article.type == .project {
                dateLabel.text = DateTool.getDateString(item.model.comment.createDate)
                companyLabel.text = SafeUnwarp(article.user.company, holderForNull: "匿名公司")
                companyLeftCons?.constant = 10
            } else {
                dateLabel.text = DateTool.getDateString(item.model.comment.createDate)
                companyLabel.text = nil
                companyLeftCons?.constant = -20
            }
            
            if item.isNormalMode {
                imageContentLabel.attributedText = item.textAttriCache
                imagesView.pictures = article.pictures
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
    
    lazy var commentLabel: UILabel = {
        let one = UILabel()
        one.numberOfLines = 0
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
    
    lazy var commentsLabel: UILabel = {
        let one = UILabel()
        one.numberOfLines = 0
        return one
    }()
    
    lazy var bottomView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBackGray
        return one
    }()
    
    lazy var replyBtn: TitleButton = {
        let one = TitleButton()
        one.title = "回复"
        one.norTitlefont = UIFont.systemFont(ofSize: 14)
        one.dowTitlefont = UIFont.systemFont(ofSize: 14)
        one.norTitleColor = HEX("#46689b")
        one.dowTitleColor = HEX("#46689b")
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.respondReply?(self.item.model.article, self.item.model.comment, self.indexPath)
        })
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
        
        contentView.addSubview(commentLabel)
        
        contentView.addSubview(attachmentBg)
        attachmentBg.addSubview(attachmentLabel)
        
        contentView.addSubview(imagesView)
        contentView.addSubview(imageContent)
        contentView.addSubview(imageContentLabel)
        
        contentView.addSubview(commentsLabel)
        contentView.addSubview(replyBtn)

        contentView.addSubview(bottomView)
        
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
        
        commentLabel.IN(contentView).LEFT(12.5).TOP(20 + 45 + 10).RIGHT(12.5).MAKE()
        
        attachmentLabel.IN(contentView).LEFT(12.5 + 10).RIGHT(12.5 + 10).MAKE()
        attachmentLabel.BOTTOM(commentLabel).OFFSET(10 + 10).MAKE()
        
        attachmentBg.IN(attachmentLabel).LEFT(-10).TOP(-10).RIGHT(-10).BOTTOM(-10).MAKE()
        
        imagesView.IN(contentView).LEFT(12.5).SIZE(60, 60).MAKE()
        imagesView.BOTTOM(commentLabel).OFFSET(10).MAKE()
        imageContent.IN(contentView).RIGHT(12.5).MAKE()
        imageContent.BOTTOM(commentLabel).OFFSET(10).MAKE()
        imageContent.RIGHT(imagesView).BOTTOM.MAKE()
        imageContentLabel.IN(imageContent).LEFT(10).TOP(10).RIGHT(10).MAKE()
        
        commentsLabel.IN(contentView).LEFT(12.5).BOTTOM(10 + 20).RIGHT(12.5).MAKE()

        replyBtn.IN(contentView).RIGHT.TOP.SIZE(60, 40).MAKE()
        
        bottomView.IN(contentView).BOTTOM(-1).LEFT.RIGHT.HEIGHT(10).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
