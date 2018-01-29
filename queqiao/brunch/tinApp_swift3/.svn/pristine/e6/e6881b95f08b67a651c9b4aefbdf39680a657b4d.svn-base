//
//  MyNewsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit


enum MyNewsTag: Int {
    case articles
    case circles
    case comments
}

class MyNewsItem {
        
    var articles: [Article] = [Article]()
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
                if let b = circle.isParty {
                    model.isSelect = b
                }
                model.isSelect = false
                model.update()
                models.append(model)
            }
            circlesItem.models = models
            circlesItem.update()
        }
    }
    var comments: [Article] = [Article]()
    
    lazy var circlesItem: RectSelectsFixSizeItem = {
        let one = RectSelectsFixSizeItem()
        one.itemXMargin = 10
        one.itemYMargin = 10
        one.maxWidth = kScreenW - 12.5 * 2
        return one
    }()

    var tag: MyNewsTag = .articles
    
    var articlesPage: Int = 0
    var commentsPage: Int = 0

    var articlesLoadingStatus: LoadStatus = .loading
    var circlesLoadingStatus: LoadStatus = .loading
    var commentsLoadingStatus: LoadStatus = .loading
    
    var articlesLastDate: Date?
    var circlesLastDate: Date?
    var commentsLastDate: Date?

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
            return articles
        case .circles:
            return circles
        case .comments:
            return comments
        }
    }
    
    var currentEmptyMsg: String {
        switch tag {
        case .articles:
            return "无新动态"
        case .circles:
            return "没有关注行业"
        case .comments:
            return "没有相关评论"
        }
    }
}

class MyNewsViewController: RootTableViewController {
    
    var user: User!
    var isMe: Bool = false
    var detail: UserDetail?
    
    var item: MyNewsItem = MyNewsItem()
    
    /// 首次进入加载头部数据
    override func loadData(_ done: @escaping LoadingDataDone) {
        self.showLoading()
        self.updateNav()
        
        let user = Account.sharedOne.user
        UserManager.shareInstance.getUserDetail(user: user, targetUser: user, success: { [weak self] (code, msg, detail) in
            if code == 0 {
                self?.detail = detail!
                self?.headView.detail = detail!
                self?.checkOrLoadSegData()
                done(.noMore)
                self?.updateNav()
            } else {
                QXTiper.showWarning(msg + "(\(code))", inView: self?.view, cover: true)
                done(.err)
            }
            }) { [weak self] (error) in
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                done(.err)
        }
    }
    
    func checkOrLoadSegData() {
        updateFooter()
        tableView.reloadData()
        switch item.tag {
        case .articles:
            if item.articlesLoadingStatus == .loading {
                let user = Account.sharedOne.user
                UserManager.shareInstance.getUserArticles(date: item.articlesLastDate, user: user, success: { [weak self] (code, msg, articles) in
                    if let s = self {
                        if code == 0 {
                            let articles = articles!
                            if articles.count == 0 {
                                s.item.articlesLoadingStatus = .doneEmpty
                            } else {
                                s.item.articlesLoadingStatus = .done
                            }
                            if s.item.articlesLastDate == nil {
                                s.item.articles = articles
                            } else {
                                s.item.articles += articles
                            }
                            s.item.articlesLastDate = articles.last?.createDate
                        } else {
                            s.item.articlesLoadingStatus = .doneErr
                            QXTiper.showWarning(msg + "(\(code))", inView: s.view, cover: true)
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
            
            item.circlesLoadingStatus = .done
            let i = Industry()
            i.name = "电子商务"
            let c = Circle(industry: i)
            item.circles = [c, c, c]
            item.circlesLoadingStatus = .done
            updateFooter()
            tableView.reloadData()
            
        case .comments:
            if item.commentsLoadingStatus == .loading {
                let user = Account.sharedOne.user
                UserManager.shareInstance.getUserComments(date: item.commentsLastDate, user: user, targetUser: user, success: { [weak self] (code, msg, articles) in
                    if let s = self {
                        if code == 0 {
                            let articles = articles!
                            if articles.count == 0 {
                                s.item.commentsLoadingStatus = .doneEmpty
                            } else {
                                s.item.commentsLoadingStatus = .done
                            }
                            if s.item.commentsLastDate == nil {
                                s.item.comments = articles
                            } else {
                                s.item.comments += articles
                            }
                            s.item.commentsLastDate = articles.last?.createDate
                        } else {
                            s.item.commentsLoadingStatus = .doneErr
                            QXTiper.showWarning(msg + "(\(code))", inView: s.view, cover: true)
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
        let one =  MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.checkOrLoadSegData()
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
            if item.articles.count > 0 {
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
            if item.comments.count > 0 {
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
        self.item.tag = MyNewsTag(rawValue: tag)!
        self.checkOrLoadSegData()
    }
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var headView: MyNewsHeadView = {
        let one = MyNewsHeadView()
        one.frame = CGRect(x: 0, y: 0, width: 0, height: one.viewHeight)
        one.respondTag = { [unowned self] tag in
            self.handleTag(tag)
        }
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTopCons.constant = -headView.appendHeight
        setupNavBackWhiteButton(nil)
        tableView.tableHeaderView = headView
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MyNewsArticleCell.self, forCellReuseIdentifier: "MyNewsArticleCell")
        tableView.register(MyNewsCirclesCell.self, forCellReuseIdentifier: "MyNewsCirclesCell")
        tableView.register(MyNewsCommentCell.self, forCellReuseIdentifier: "MyNewsCommentCell")
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        
        
        setupCustomNav()
        customNavView.setupBackButton()
        customNavView.backBlackBtn.isHidden = true
        customNavView.respondBack = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNav()
        hideNav()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if item.currentModels.count == 0 {
            return 1
        }
        switch item.tag {
        case .articles:
            return item.articles.count
        case .circles:
            return 1
        case .comments:
            return item.comments.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyNewsArticleCell") as! MyNewsArticleCell
            cell.article = item.articles[(indexPath as NSIndexPath).row]
            return cell
        case .circles:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyNewsCirclesCell") as! MyNewsCirclesCell
            cell.item = item.circlesItem
            return cell
        case .comments:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyNewsCommentCell") as! MyNewsCommentCell
            cell.article = item.comments[(indexPath as NSIndexPath).row]
            cell.showBottomLine = !((indexPath as NSIndexPath).row == item.comments.count - 1)
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if item.currentModels.count == 0 {
            return kScreenH - headView.imgH
        }
        
        switch item.tag {
        case .articles:
            return MyNewsArticleCell.cellHeight()
        case .circles:
            return 20 + item.circlesItem.viewHeight + 20
        case .comments:
            return MyNewsCommentCell.cellHeight()
        }
    }
    
    var navAlpha: CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let totalHeight = headView.imgH - 64
        if offsetY > 0 {
            navAlpha =  offsetY / totalHeight
            navAlpha = min(navAlpha, 1)
        } else {
            navAlpha = 0
        }
        updateNav()
    }
    func updateNav() {
        // 当 searchView 的背景接近白色时，状态栏的颜色变黑色
        if navAlpha > 0.9 {
            customNavView.title = isMe ? "我的动态" : "好友动态"
            customNavView.backBlackBtn.isHidden = false
            customNavView.backWhiteBtn.isHidden = true
        } else {
            customNavView.title = ""
            setupNavBackWhiteButton(nil)
            customNavView.backBlackBtn.isHidden = true
            customNavView.backWhiteBtn.isHidden = false
        }
        setNeedsStatusBarAppearanceUpdate()
        // 更新nav背景色
        customNavView.changeAlpha(navAlpha)
    }

}

