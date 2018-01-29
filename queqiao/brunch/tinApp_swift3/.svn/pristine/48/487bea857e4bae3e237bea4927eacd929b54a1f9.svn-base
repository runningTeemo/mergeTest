//
//  NewsCommentViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/13.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsCommentViewController: RootTableViewController {
    
    var news: News!
    var replyItem: NewsCommentGroupItem?
    
    var groupItems: [NewsCommentGroupItem] = [NewsCommentGroupItem]()
    var pageIndex: Int = 1
    
    var respondUpdate: (() -> ())?
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        let id = SafeUnwarp(news.id, holderForNull: 0)
        
        CommentManager.shareInstance.getCommentGroupList(news.type, targetId: id, pageIndex: pageIndex, pageSize: 20, success: { [weak self] (code, msg, groups, pageInfo) in
            if code == 0 {
                if let s = self {
                    let groups = groups!
                    var items = [NewsCommentGroupItem]()
                    for group in groups {
                        let item = NewsCommentGroupItem(group: group)
                        items.append(item)
                    }
                    if items.count == 0 && s.pageIndex == 1 {
                        done(.empty)
                    } else {
                        if let pageInfo = pageInfo {
                            if pageInfo.isLastPage {
                                done(.noMore)
                            } else {
                                done(.thereIsMore)
                            }
                        } else {
                            done(.noMore)
                        }
                    }
                    if s.pageIndex == 1 {
                        s.groupItems = items
                    } else {
                        s.groupItems += items
                    }
                    s.pageIndex += 1
                    s.hasData = s.groupItems.count > 0
                    s.tableView.reloadData()
                }
            } else {
                if let s = self {
                    s.hasData = s.groupItems.count > 0
                    done(.err)
                    QXTiper.showWarning(msg, inView: s.view, cover: true)
                }
            }
        }) { [weak self] (error) in
            if let s = self {
                s.hasData = s.groupItems.count > 0
                done(.err)
                QXTiper.showWarning(kWebErrMsg + "(\(error.code))", inView: s.view, cover: true)
            }
        }
    }
    override func loadData(_ done: @escaping LoadingDataDone) {
        resetFooter()
        pageIndex = 1
        loadMore(done)
    }
    
    lazy var tableHeader: UIView = {
        let one = UIView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 10)
        one.backgroundColor = kClrBackGray
        return one
    }()
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
            self.replyItem = nil
            })
        return one
    }()
    
    var barViewBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "评论详情"
        setupNavBackBlackButton(nil)
        tableView.register(NewsCommentReplyCell.self, forCellReuseIdentifier: "NewsCommentReplyCell")
        tableView.register(NewsCommentHeadView.self, forHeaderFooterViewReuseIdentifier: "NewsCommentHeadView")
        tableView.register(NewsCommentFootView.self, forHeaderFooterViewReuseIdentifier: "NewsCommentFootView")
        tableView.tableHeaderView = tableHeader
        
        view.addSubview(barView)

        view.addSubview(coverBtn)
        coverBtn.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).MAKE()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsCommentViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewsCommentViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        setupRefreshFooter()
        emptyMsg = "当前没有评论"
        
        tableViewBottomCons?.constant = -barView.viewHeight
        loadingViewBottomCons?.constant = -barView.viewHeight
        
        view.bringSubview(toFront: barView)
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return groupItems.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupItems[section].subCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCommentReplyCell") as! NewsCommentReplyCell
        cell.comment = groupItems[indexPath.section].group.replays[indexPath.row]
        cell.contentLabel.attributedText = groupItems[indexPath.section].subAttries[indexPath.row]
        cell.showBottomLine = !((groupItems[indexPath.section].subCount - 1) == indexPath.row)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return groupItems[indexPath.section].subHeights[indexPath.row]
    }
    var lastOffset: CGPoint?
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewsCommentHeadView") as! NewsCommentHeadView
        view.item = groupItems[section]
        view.respondComment = { [unowned self, unowned view] item in
            self.replyItem = item
            self.barView.commentField.textField.text = nil
            self.barView.commentField.textField.becomeFirstResponder()
            let y = view.frame.minY
            self.lastOffset = self.tableView.contentOffset
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.tableView.contentOffset = CGPoint(x: 0, y: y - 10)
            })
        }
        view.respondAgree = { [unowned self] item in
            self.handleAgree(item: item)
        }
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let item = groupItems[section]
        return item.headHeight
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewsCommentFootView") as! NewsCommentFootView
        let item = groupItems[section]
        view.item = item
        view.respondMore = { [unowned self] in
            item.fold = !item.fold
            self.tableView.reloadData()
        }
        view.bottomLine.isHidden = (section == groupItems.count - 1)
        return view
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let item = groupItems[section]
        return item.footHeight
    }
    
    func keyboardWillShow(_ notice: Notification) {
        
        coverBtn.isHidden = false

        if (notice as NSNotification).userInfo == nil { return }
        let frame = ((notice as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant =  -frame.size.height
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) 
    }
    func keyboardWillHide(_ notice: Notification) {
        
        coverBtn.isHidden = true

        let duration = ((notice as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        barViewBottomCons?.constant = 0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        
        if let offset = self.lastOffset {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.tableView.contentOffset = offset
                })
        }
    }
    
    func handleComment(_ text: String) {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.comment(text)
        }
    }
    
    func comment(_ text: String) {
        
        var targetId: String
        var replyUserId: String?
        if let comment = replyItem?.group.comment {
            targetId = SafeUnwarp(comment.id, holderForNull: "")
            replyUserId = comment.commentUser?.id
        } else {
            targetId = "\(SafeUnwarp(news.id, holderForNull: 0))"
        }
        
        let comment = NewsComment()
        comment.targetId = targetId
        comment.content = text
        comment.targetType = news.type
        comment.targetContent = nil
        comment.createDate = Date()
        comment.agreeCount = 0
        if Account.sharedOne.isLogin {
            comment.commentUser = Account.sharedOne.user
        }
        
        CommentManager.shareInstance.saveComment(news.type, userId: Account.sharedOne.optionalUserId, replayUserId: replyUserId, targetId: targetId, content: text, newsBref: news.title, success: { [weak self] (code, message, ret) in
            if code == 0 {
                self?.respondUpdate?()
                self?.barView.commentField.textField.text = nil
                if let _ = self?.replyItem {
                    self?.replyItem?.group.replays.insert(comment, at: 0)
                    self?.replyItem?.update()
                    self?.tableView.reloadData()
                    self?.replyItem = nil
                } else {
                    self?.performRefresh()
                    self?.replyItem = nil
                }
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
                self?.replyItem = nil
            }
        }) { [weak self] (error) in
            self?.replyItem = nil
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
    func handleAgree(item: NewsCommentGroupItem) {
        
        item.group.comment.agreeCount = SafeUnwarp(item.group.comment.agreeCount, holderForNull: 0) + 1
        item.canAgree = false
        tableView.reloadData()
        
        var me: User?
        if Account.sharedOne.isLogin {
            me = Account.sharedOne.user
        }
        let id = SafeUnwarp(item.group.comment.id, holderForNull: "")
        CommentManager.shareInstance.agree(user: me, targetId: id, success: { [weak self] (code, msg, ret) in
            if code == 0 {
                
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                item.canAgree = true
                var c = SafeUnwarp(item.group.comment.agreeCount, holderForNull: 0) - 1
                c = max(0, c)
                item.group.comment.agreeCount = c
                self?.tableView.reloadData()
            }
            }) { [weak self] (error) in
                item.canAgree = true
                var c = SafeUnwarp(item.group.comment.agreeCount, holderForNull: 0) - 1
                c = max(0, c)
                item.group.comment.agreeCount = c
                self?.tableView.reloadData()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


class NewsCommentGroupItem {
    
    var group: NewsCommentGroup!
    
    var canAgree: Bool = true
    
    var fold: Bool = true
    
    var headHeight: CGFloat = 0
    var footHeight: CGFloat = 0
    var subHeights: [CGFloat] = [CGFloat]()
    
    let contentDic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: 15), color: kClrDeepGray)
    
    var contentAttri: NSAttributedString?
    var subAttries: [NSAttributedString?] =  [NSAttributedString?]()
    
    var thereIsMore: Bool = false
    
    var subCount: Int {
        if thereIsMore {
            return fold ? 2 : group.replays.count
        }
        return group.replays.count
    }
    
    init(group: NewsCommentGroup) {
        self.group = group
        update()
    }
    
    func update() {
        let attriSize = StringTool.size(group.comment.content, attriDic: contentDic, maxWidth: kScreenW - 12.5 * 2)
        contentAttri = attriSize.attriStr
        
        if group.replays.count == 0 {
            headHeight = 15 + 40 + 15 + attriSize.size.height + 5
            footHeight = 10
            thereIsMore = false
        } else if group.replays.count <= 2 {
            headHeight = 15 + 40 + 15 + attriSize.size.height + 15 + 5 + 3
            footHeight = 15 + 3
            thereIsMore = false
        } else {
            headHeight = 15 + 40 + 15 + attriSize.size.height + 15 + 5 + 3
            footHeight = 15 + 40
            thereIsMore = true
        }
        
        var subAttries = [NSAttributedString?]()
        var subHeights = [CGFloat]()
        for reply in group.replays {
            let attriSize = StringTool.size(reply.content, attriDic: contentDic, maxWidth: kScreenW - 12.5 * 2 * 2)
            let height = 15 + 40 + 15 + attriSize.size.height + 15
            subAttries.append(attriSize.attriStr)
            subHeights.append(height)
        }
        self.subAttries = subAttries
        self.subHeights = subHeights
    }
}

class NewsCommentHeadView: RootTableViewHeaderFooterView {
    
    var respondComment: ((_ item: NewsCommentGroupItem) -> ())?
    var respondAgree: ((_ item: NewsCommentGroupItem) -> ())?

    var item: NewsCommentGroupItem! {
        didSet {
            iconView.fullPath = item.group.comment.commentUser?.avatar
            nameLabel.text = SafeUnwarp(item.group.comment.commentUser?.realName, holderForNull: "匿名用户")
            dateLabel.text = DateTool.getNature(item.group.comment.createDate)
            contentLabel.attributedText = item.contentAttri
            agreeCount.text = "\(SafeUnwarp(item.group.comment.agreeCount, holderForNull: 0))"
            
            if let _ = item.group.comment.commentUser?.id {
                replayBtn.forceDown(false)
            } else {
                replayBtn.forceDown(true)
            }
            
            agreeIcon.forceDown(!item.canAgree)
            
        }
    }
    lazy var iconView: RoundIconView = {
        let one = RoundIconView(type: .user)
        return one
    }()
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = kFontSubTitle
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.numberOfLines = 0
        return one
    }()
    lazy var agreeCount: UILabel = {
        let one = UILabel()
        one.textColor = kClrOrange
        one.font = kFontNormal
        one.text = "0"
        one.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return one
    }()
    lazy var agreeIcon: ImageFixButton = {
        let one = ImageFixButton()
        one.iconSize = CGSize(width: 15, height: 15)
        one.iconView.image = UIImage(named: "iconLike")
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondAgree?(self.item)
        })
        return one
    }()
    lazy var replayBtn: TitleButton = {
        let one = TitleButton()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = RGBA(70, 104, 155, 255)
        one.dowTitleColor = kClrLightGray
        one.norTitlefont = kFontNormal
        one.dowTitlefont = kFontNormal
        one.title = "回复"
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            if let id = self.item.group.comment.commentUser?.id {
                self.respondComment?(self.item)
            }
        })
        return one
    }()
    lazy var breakLine = NewBreakLine
    
    lazy var arrow: ArticleUpArrow = {
        let one = ArticleUpArrow()
        one.color = kClrSlightGray
        return one
    }()
    lazy var backView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrSlightGray
        one.layer.cornerRadius = 2
        one.clipsToBounds = true
        return one
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kClrWhite
        contentView.clipsToBounds = true
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(agreeCount)
        contentView.addSubview(agreeIcon)
        contentView.addSubview(replayBtn)
        contentView.addSubview(breakLine)
        iconView.IN(contentView).LEFT(12.5).TOP(15).SIZE(40, 40).MAKE()
        nameLabel.RIGHT(iconView).OFFSET(10).TOP(-3).MAKE()
        dateLabel.RIGHT(iconView).OFFSET(10).BOTTOM(-3).MAKE()
        
        replayBtn.IN(contentView).RIGHT.TOP(15).SIZE(60, 35).MAKE()
        breakLine.LEFT(replayBtn).CENTER.SIZE(0.5, 10).MAKE()
        agreeIcon.LEFT(breakLine).CENTER.SIZE(40, 40).MAKE()
        agreeCount.LEFT(agreeIcon).CENTER.MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(agreeCount).LEFT.OFFSET(-20).MAKE()
        contentLabel.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP(15 + 40 + 15).MAKE()
        
        contentLabel.addSubview(arrow)
        contentLabel.addSubview(backView)
        
        arrow.BOTTOM(contentLabel).OFFSET(15).SIZE(7, 5).MAKE()
        arrow.LEFT.EQUAL(backView).OFFSET(15).MAKE()
        backView.IN(contentView).LEFT(12.5).RIGHT(12.5).MAKE()
        backView.TOP.EQUAL(arrow).BOTTOM.MAKE()
        backView.HEIGHT.EQUAL(100).MAKE()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NewsCommentFootView: RootTableViewHeaderFooterView {
    
    var respondMore: (() -> ())?
    
    var item: NewsCommentGroupItem! {
        didSet {
            if item.thereIsMore {
                seeMoreBtn.isHidden = false
                if item.fold {
                    seeMoreBtn.title = "查看更多"
                } else {
                    seeMoreBtn.title = "收起"
                }
            } else {
                seeMoreBtn.isHidden = true
            }
        }
    }

    lazy var backView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrSlightGray
        one.layer.cornerRadius = 2
        one.clipsToBounds = true
        return one
    }()
    lazy var bottomLine = NewBreakLine
    lazy var seeMoreBtn: TitleButton = {
        let one = TitleButton()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.norTitleColor = RGBA(70, 104, 155, 255)
        one.dowTitleColor = kClrLightGray
        one.norTitlefont = kFontNormal
        one.dowTitlefont = kFontNormal
        one.title = "查看更多"
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondMore?()
        })
        return one
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = kClrWhite
        contentView.clipsToBounds = true
        contentView.addSubview(backView)
        contentView.addSubview(bottomLine)
        contentView.addSubview(seeMoreBtn)
        backView.IN(contentView).LEFT(12.5).RIGHT(12.5).BOTTOM(15).HEIGHT(100).MAKE()
        bottomLine.IN(contentView).LEFT.RIGHT.BOTTOM.HEIGHT(0.5).MAKE()
        seeMoreBtn.IN(backView).LEFT(12.5).BOTTOM(10).HEIGHT(30).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewsCommentReplyCell: RootTableViewCell {
    
    var comment: NewsComment! {
        didSet {
            iconView.fullPath = comment.commentUser?.avatar
            nameLabel.text = SafeUnwarp(comment.commentUser?.realName, holderForNull: "匿名用户")
            dateLabel.text = DateTool.getNature(comment.createDate)
        }
    }
    
    lazy var iconView: RoundIconView = {
        let one = RoundIconView(type: .user)
        return one
    }()
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = kFontSubTitle
        one.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        one.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return one
    }()
    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrGray
        one.font = kFontSmall
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.numberOfLines = 0
        return one
    }()
    lazy var backView: UIView = {
        let one = UIView()
        one.backgroundColor = kClrSlightGray
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        backView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP.BOTTOM.MAKE()
        iconView.IN(backView).LEFT(12.5).TOP(15).SIZE(40, 40).MAKE()
        nameLabel.RIGHT(iconView).OFFSET(10).TOP(-3).MAKE()
        dateLabel.RIGHT(iconView).OFFSET(10).BOTTOM(-3).MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(backView).OFFSET(-12.5).MAKE()
        dateLabel.RIGHT.LESS_THAN_OR_EQUAL(backView).OFFSET(-12.5).MAKE()
        contentLabel.IN(backView).LEFT(12.5).RIGHT(12.5).TOP(15 + 40 + 15).MAKE()
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
