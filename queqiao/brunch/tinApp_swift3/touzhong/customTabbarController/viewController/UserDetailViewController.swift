//
//  UserDetailViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/14.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

//UserDetailViewController

enum UserDetailTag: Int {
    case articles = 0
    case comments = 1
    case circles = 2
}

class UserDetailItem {
    
    var articleItems: [UserDetailArticleItem] = [UserDetailArticleItem]()
    var circles: [Circle] = [Circle]() {
        didSet {
            var models = [RectSelectFixSizeItem]()
            for circle in circles {
                let model = RectSelectFixSizeItem()
                var w: CGFloat = 0
                if kScreenW < 330 {
                    w = (kScreenW - 12.5 * 2 - 10 * 2) / 3
                } else {
                    w = (kScreenW - 12.5 * 2 - 10 * 3) / 4
                }
                model.size = CGSize(width: w, height: 40)
                model.showCornerImage = false
                model.title = circle.industry.name
                model.isSelect = circle.isParty
                model.isSelect = circle.isParty
                model.update()
                models.append(model)
            }
            circlesItem.models = models
            circlesItem.update()
        }
    }
    var commentItems: [UserDetailCommentItem] = [UserDetailCommentItem]()
    
    lazy var circlesItem: RectSelectsFixSizeItem = {
        let one = RectSelectsFixSizeItem()
        one.itemXMargin = 10
        one.itemYMargin = 10
        one.maxWidth = kScreenW - 12.5 * 2
        return one
    }()
    
    var tag: UserDetailTag = .articles
    
    var articlesPage: Int = 0
    var commentsPage: Int = 0
    
    var articlesLoadingStatus: LoadStatus = .loading
    var circlesLoadingStatus: LoadStatus = .loading
    var commentsLoadingStatus: LoadStatus = .loading
    
    var articlesLastDate: String?
    var circlesLastDate: String?
    var commentsStart: Int = 0
    
    var currentLoadStatus: LoadStatus {
        switch tag {
        case .articles:
            return articlesLoadingStatus
        case .circles:
            return circlesLoadingStatus
        case .comments:
            return commentsLoadingStatus
        }
    }
    
    var currentModels: [AnyObject] {
        switch tag {
        case .articles:
            return articleItems
        case .circles:
            return circles
        case .comments:
            return commentItems
        }
    }
    
    var currentEmptyMsg: String {
        switch tag {
        case .articles:
            return "没有新动态"
        case .circles:
            return "没有关注行业"
        case .comments:
            return "没有相关评论"
        }
    }
}

class UserDetailViewController: RootTableViewController {
    
    var user: User!
    var detail: UserDetail?
    
    var item: UserDetailItem = UserDetailItem()
    
    /// 检测能不能看到列表
    func checkForbidSee() -> Bool {
        if user.isMe() {
            return false
        }
        if let detail = detail {
            if let t = detail.user.isFriend {
                return !t
            }
        }
        return true
    }
    
    /// 首次进入加载头部数据
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        
        UserManager.shareInstance.getUserDetail(user: me, targetUser: user, success: { [weak self] (code, msg, detail) in
            if code == 0 {
                let detail = detail!
                self?.user = detail.user
                self?.detail = detail
                self?.headView.detail = detail
                
                self?.item.articlesLoadingStatus = .loading
                self?.item.circlesLoadingStatus = .loading
                self?.item.commentsLoadingStatus = .loading
                self?.checkOrLoadSegData()
                done(.noMore)
                
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
        }
    }
    
    func checkOrLoadSegData() {
        
        if !Account.sharedOne.isLogin { return }
        
        updateFooter()
        tableView.reloadData()
        switch item.tag {
        case .articles:
            
            if checkForbidSee() {
                return
            }
            
            if item.articlesLoadingStatus == .loading {
                
                let me = Account.sharedOne.user
                UserManager.shareInstance.getUserArticles(dateForPaging: item.articlesLastDate, user: me, targetUser: user, success: { [weak self] (code, msg, articles) in
                    if let s = self {
                        if code == 0 {
                            let articles = articles!
                            var articleItems = [UserDetailArticleItem]()
                            for article in articles {
                                let item = UserDetailArticleItem(model: article)
                                articleItems.append(item)
                            }                            
                            if articles.count == 0 {
                                s.item.articlesLoadingStatus = .doneEmpty
                            } else {
                                s.item.articlesLoadingStatus = .done
                            }
                            if s.item.articlesLastDate == nil {
                                s.item.articleItems = articleItems
                            } else {
                                s.item.articleItems += articleItems
                            }
                            s.item.articlesLastDate = articles.last?.dateForPaging
                        } else {
                            s.item.articlesLoadingStatus = .doneErr
                            QXTiper.showWarning(msg, inView: s.view, cover: true)
                        }
                        s.updateFooter()
                        s.tableView.reloadData()
                    }
                    }, failed: { [weak self] (error) in
                        self?.item.articlesLoadingStatus = .doneErr
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        self?.updateFooter()
                        self?.tableView.reloadData()
                    })
            }
            
        case .circles:

            if item.circlesLoadingStatus == .loading {
                
                ArticleManager.shareInstance.getUserCircles(targetUser: user, success: { [weak self] (code, msg, circles) in
                    if let s = self {
                        if code == 0 {
                            let circles = circles!
                            s.item.circles = circles
                            if circles.count == 0 {
                                s.item.circlesLoadingStatus = .doneEmpty
                            } else {
                                s.item.circlesLoadingStatus = .done
                            }
                        } else {
                            s.item.commentsLoadingStatus = .doneErr
                            QXTiper.showWarning(msg, inView: s.view, cover: true)
                        }
                        s.updateFooter()
                        s.tableView.reloadData()
                    }
                    }, failed: { [weak self] (error) in
                        self?.item.circlesLoadingStatus = .doneErr
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        self?.updateFooter()
                        self?.tableView.reloadData()
                })
            
            }
            
        case .comments:
            
            if checkForbidSee() {
                return
            }
            
            if item.commentsLoadingStatus == .loading {

                UserManager.shareInstance.getUserComments(targetUser: user, start: item.commentsStart, rows: 10, success: { [weak self] (code, msg, articles) in
                    if let s = self {
                        if code == 0 {
                            let articles = articles!
                            var articleItems = [UserDetailCommentItem]()
                            let isMe: Bool
                            if let t = s.detail?.user.isMe() {
                                isMe = t
                            } else {
                                isMe = false
                            }
                            for article in articles {
                                let item = UserDetailCommentItem(model: article, isMe: isMe)
                                articleItems.append(item)
                            }
                            if articles.count == 0 {
                                s.item.commentsLoadingStatus = .doneEmpty
                            } else {
                                s.item.commentsLoadingStatus = .done
                            }
                            if s.item.commentsStart == 0 {
                                s.item.commentItems = articleItems
                            } else {
                                s.item.commentItems += articleItems
                            }
                            s.item.commentsStart += 10
                        } else {
                            s.item.commentsLoadingStatus = .doneErr
                            QXTiper.showWarning(msg, inView: s.view, cover: true)
                        }
                        s.updateFooter()
                        s.tableView.reloadData()
                    }
                    }, failed: { [weak self] (error) in
                        self?.item.commentsLoadingStatus = .doneErr
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        self?.updateFooter()
                        self?.tableView.reloadData()
                    })
            }
        }
    }
    
    /// 添加刷新尾
    lazy var footer: MJRefreshAutoNormalFooter = {
        let one =  MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            guard let s = self else {
                return
            }
            switch s.item.tag {
            case .articles:
                s.item.articlesLoadingStatus = .loading
            case .circles:
                s.item.circlesLoadingStatus = .loading
            case .comments:
                s.item.commentsLoadingStatus = .loading
            }
            s.checkOrLoadSegData()
            })
        return one!
    }()
    func appendFooter() {
        tableView.mj_footer = footer
    }
    /// 删除刷新尾
    func removeFooter() {
        tableView.mj_footer = nil
    }
    func updateFooter() {
        switch item.tag {
        case .articles:
            if item.articleItems.count > 0 && !checkForbidSee() {
                appendFooter()
                if item.articlesLoadingStatus == .done {
                    footer.endRefreshing()
                } else if item.articlesLoadingStatus == .doneEmpty {
                    footer.endRefreshingWithNoMoreData()
                }
            } else {
                removeFooter()
            }
        case .circles:
            removeFooter()
        case .comments:
            if item.commentItems.count > 0 && !checkForbidSee() {
                appendFooter()
                if item.commentsLoadingStatus == .done {
                    footer.endRefreshing()
                } else if item.commentsLoadingStatus == .doneEmpty {
                    footer.endRefreshingWithNoMoreData()
                }
            } else {
                removeFooter()
            }
        }
        
    }
    
    func handleTag(_ tag: Int) {
        self.item.tag = UserDetailTag(rawValue: tag)!
        self.checkOrLoadSegData()
    }
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var headView: UserDetailHeadView = {
        let one = UserDetailHeadView()
        one.frame = CGRect(x: 0, y: 0, width: 0, height: one.viewHeight)
        one.respondTag = { [unowned self] tag in
            self.handleTag(tag)
        }
        //聊天
        one.respondChat = { [unowned self] user in
            print(user.realName ?? "")
            let vc = ChatViewController(conversationChatter: user.huanXinId, conversationType: EMConversationTypeChat)
            vc?.userName = SafeUnwarp(user.realName, holderForNull: "")
            vc?.userImg = user.avatar
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        one.respondInfo = { [unowned self] user in
            let vc = MeInformationViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondAdd = { [unowned self] user in
            if !Account.sharedOne.isLogin { return }
            let me = Account.sharedOne.user
            if let name = me.realName {
                self.barView.commentField.textField.text = "我是" + name
            } else {
                self.barView.commentField.textField.text = "我是"
            }
            self.barView.commentField.textField.becomeFirstResponder()
        }
        one.respondOrganization = { [unowned self] organization in
            if organization.type == .company {
                if let id = organization.id {
                    let vc = EnterpriseDetailViewController()
                    vc.id = "\(id)"
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else if organization.type == .institution {
                if let id = organization.id {
                    let vc = InstitutionDetailViewController()
                    vc.id = "\(id)"
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        return one
    }()
    
    lazy var barView: NewsCommentCommentBar = {
        let one = NewsCommentCommentBar()
        one.commentField.textField.placeholder = "填写验证信息"
        one.respondComment = { [unowned self, unowned one] text in
            
            if !Account.sharedOne.isLogin { return }

            let me = Account.sharedOne.user
            if let name = me.realName {
                one.commentField.textField.text = "我是" + name
            } else {
                one.commentField.textField.text = "我是"
            }
            self.handleComment(text)
        }
        return one
    }()
    
    var barViewBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTopCons.constant = -headView.appendHeight
        setupNavBackWhiteButton(nil)
        tableView.tableHeaderView = headView
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UserDetailArticleCell.self, forCellReuseIdentifier: "UserDetailArticleCell")
        tableView.register(UserDetailCirclesCell.self, forCellReuseIdentifier: "UserDetailCirclesCell")
        tableView.register(UserDetailCommentCell.self, forCellReuseIdentifier: "UserDetailCommentCell")
        setupLoadingView()
        loadDataOnFirstWillAppear = true
       
        view.addSubview(barView)
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).OFFSET(barView.viewHeight).MAKE()
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UserDetailViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        setupCustomNav()
        customNavView.setupBackButton()
        customNavView.backBlackBtn.isHidden = true
        customNavView.respondBack = { [unowned self] in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.statusBarStyle = .lightContent
        customNavView.respondWhite = { [unowned self] in
            self.statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
        }
        customNavView.respondTransparent = { [unowned self] in
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        setupRefreshHeader()
        loadDataOnFirstWillAppear = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkForbidSee() && (item.tag == .articles || item.tag == .comments) {
            return 0
        }
        if item.currentModels.count == 0 {
            return 1
        }
        switch item.tag {
        case .articles:
            return item.articleItems.count
        case .circles:
            return 1
        case .comments:
            return item.commentItems.count
        }
    }
    
    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if item.currentModels.count == 0 {
            if item.currentLoadStatus == .doneEmpty {
                loadingCell.showEmpty(item.currentEmptyMsg)
            } else if item.currentLoadStatus == .doneErr {
                loadingCell.showFailed(self.faliedMsg)
            } else {
                loadingCell.showLoading()
            }
            loadingCell.respondReload = { [unowned self] in
                switch self.item.tag {
                case .articles:
                    self.item.articlesLoadingStatus = .loading
                case .circles:
                    self.item.circlesLoadingStatus = .loading
                case .comments:
                    self.item.commentsLoadingStatus = .loading
                }
                self.checkOrLoadSegData()
            }
            return self.loadingCell
        }
        
        switch item.tag {
        case .articles:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailArticleCell") as! UserDetailArticleCell
            cell.item = item.articleItems[indexPath.row]
            return cell
        case .circles:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCirclesCell") as! UserDetailCirclesCell
            cell.item = item.circlesItem
            return cell
        case .comments:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCommentCell") as! UserDetailCommentCell
            cell.item = item.commentItems[indexPath.row]
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if item.currentModels.count == 0 {
            return false
        }
        switch item.tag {
        case .circles:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        switch item.tag {
        case .articles:
            let article = item.articleItems[indexPath.row].model
            if ArticleDetailHelper.canView(article: article) {
                let vc = ArticleDetailViewControler()
                vc.orgienArticle = article
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            } else {
                QXTiper.showWarning("您无权限查看", inView: self.view, cover: true)
            }

        case .comments:
            let article = item.commentItems[indexPath.row].model
            if ArticleDetailHelper.canView(article: article) {
                let vc = ArticleDetailViewControler()
                vc.orgienArticle = article
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            } else {
                QXTiper.showWarning("您无权限查看", inView: self.view, cover: true)
            }

        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if item.currentModels.count == 0 {
            return kScreenH - headView.imgH
        }
        switch item.tag {
        case .articles:
            let articleItem = item.articleItems[indexPath.row]
            return articleItem.cellHeight
        case .circles:
            return 20 + item.circlesItem.viewHeight + 20
        case .comments:
            let commentItem = item.commentItems[indexPath.row]
            return commentItem.cellHeight
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if user.isMe() {
            customNavView.title = "我的动态"
        } else {
            customNavView.title = "用户动态"
            if let ret = user.isFriend {
                if ret {
                    customNavView.title = "好友动态"
                }
            }
        }
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)
        
        view.endEditing(true)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }
    
    
    fileprivate var origenFooterView: UIView?
    fileprivate var isSecondShow: Bool = false // 解决第三方键盘的多次弹出问题
    func keyboardWillShow(_ notice: Notification) {
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
            self?.sendRequest(text)
        }
    }
    func sendRequest(_ text: String) {
        
        if !Account.sharedOne.isLogin { return }
        
        let wait = QXTiper.showWaiting("请求中...", inView: view, cover: true)
        let me = Account.sharedOne.user
        
        UserManager.shareInstance.sendFriendRequest(user: me, toUser: user, message: text, success: { [weak self] (code, message, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                self?.barView.commentField.textField.text = nil
                QXTiper.showSuccess("请求已发送", inView: self?.view, cover: true)
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
