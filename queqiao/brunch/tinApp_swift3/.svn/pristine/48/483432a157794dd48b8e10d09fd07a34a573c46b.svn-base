//
//  ArticleMainViewControler.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleMainViewControler: RootTableViewController, LogoutProtocol {
    
    func performLogin() {
        searchVc.reset()
        initStatus()
        clearFirstInStatus()
        tableView.contentOffset = CGPoint.zero
        
        lastOffsetY = 0
        searchVcOffsetY = 0
        searchVcTopCons?.constant = 0
        
        initSearchHead()
    }
    
    func performLogout() {
        dismiss(animated: false, completion: nil)
        _ = navigationController?.popToRootViewController(animated: true)
        update()
    }
    
    var items: [IndustryArticleItem] = [IndustryArticleItem]()
    var commitModel:ProjectViewCommitDataModel = ProjectViewCommitDataModel()
    var lastDate: String?
    var start: Int = 0
    
    var commentItem: IndustryArticleItem?
    var loaded: Bool = false
    var replyComment: Comment?
    
    lazy var loginView: ToLoginView = {
        let one = ToLoginView()
        one.respondLogin = {
            let vc = LoginViewController()
            vc.showRegistOnAppear = false
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondRegist = {
            let vc = LoginViewController()
            vc.showRegistOnAppear = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var writeItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconCirclePublish", responder: { [unowned self] in
            
            if ArticleWriteLimitChecker.check(onVc: self, operation: "发布文章") {
                
                QXActionSheetShow(onVc: self, cancelBtn: true, actions:
                      ("项目", {                        
                        let vc = PublishProjectViewController()
                        vc.vcBefore = self
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                      }),
//                      ("人才", {
//                        let vc = PublishManPowerViewController()
//                        vc.vcBefore = self
//                        vc.hidesBottomBarWhenPushed = true
//                        self.navigationController?.pushViewController(vc, animated: true)
//                      }),
//                      ("活动", {
//                        let vc = PublishActivityViewController()
//                        vc.vcBefore = self
//                        vc.hidesBottomBarWhenPushed = true
//                        self.navigationController?.pushViewController(vc, animated: true)
//                      }),
                      ("八卦", {
                        let vc = PublishBaGuaViewController()
                        vc.vcBefore = self
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                      })
                )
                
            }
        })
        return one
    }()
    
    lazy var messageItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconMessage", responder: { [unowned self] in
            let vc = MessageMainViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            })
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
            
            self.commentItem = nil
            self.replyComment = nil
        })
        return one
    }()
    
    lazy var searchCover: UIButton = {
        let one = UIButton()
        one.backgroundColor = RGBA(0, 0, 0, 50)
        one.isHidden = true
        one.signal_event_touchUpInside.head({ [unowned self, unowned one] (_) in
            self.searchVc.setFold()
            one.isHidden = true
        })
        return one
    }()
    
    var isFilterMode = true
    var keyword: String?
    lazy var searchVc: ArticleSearchViewController = {
        let one = ArticleSearchViewController()
        one.respondKeyboard = { [unowned self] show in
            self.barView.isHidden = show
            if show {
                self.initSearchHead()
            }
        }
        one.respondHeight = { [unowned self] h in
            self.searchVcHeightCons?.constant = h
        }
        one.respondFold = { [unowned self] f in
            self.searchCover.isHidden = f
            if !f {
                self.initSearchHead()
                self.view.endEditing(true)
            }
        }
        one.respondFilte = { [unowned self] in
            self.keyword = nil
            self.searchVc.searchHeader.searchBar.textField.text = nil
            self.isFilterMode = true
            self.view.endEditing(true)
            self.initStatus()
            self.loadData()
            one.tipVc.view.isHidden = true
        }
        
        one.respondSearch = { [unowned self] key in
            self.keyword = NullText(key) ? nil : key
            self.isFilterMode = false
            one.cleanModel.articleType = .all

            self.view.endEditing(true)
            self.initStatus()
            self.loadData()
            
            one.tipVc.view.isHidden = true
            one.respondHeight?(ArticleSearchViewController.orderHeight)
        }
        
        one.respondClean = { [unowned self] in
            self.keyword = nil
            self.isFilterMode = false
            one.cleanModel.articleType = .all
            
            self.view.endEditing(true)
            self.initStatus()
            self.loadData()
            
            one.tipVc.view.isHidden = true
            one.respondHeight?(ArticleSearchViewController.orderHeight)
        }
        
        one.tipVc.respondType = { [unowned self] type, key, count in
            
            self.keyword = key
            self.isFilterMode = false
            
            var articleType: ArticleType = .all
            if type == .article_normal {
                articleType = .normal
            } else if type == .article_manpower {
                articleType = .manpower
            } else if type == .article_activity {
                articleType = .activity
            } else if type == .article_project {
                articleType = .project
            }
            
            one.cleanModel.articleType = articleType
            
            self.view.endEditing(true)
            self.initStatus()
            self.loadData()
            
            one.tipVc.view.isHidden = true
            one.respondHeight?(ArticleSearchViewController.initHeight)
            one.respondFold?(true)
        }
        
        one.tipVc.respondId = { [unowned self] type, id, key in
            
            let model = Article()
            model.id = id
            if type == .article_normal {
                model.type = .normal
            } else if type == .article_manpower {
                model.type = .manpower
            } else if type == .article_activity {
                model.type = .activity
            } else if type == .article_project {
                model.type = .project
            }
            
            if model.type == .project {
                if ArticleWriteLimitChecker.check(onVc: self, operation: "查看项目详情") {
                    let vc = ArticleDetailViewControler()
                    vc.orgienArticle = model
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let vc = ArticleDetailViewControler()
                vc.orgienArticle = model
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return one
    }()
    

    func initSearchHead() {
        let headerHeight = ArticleSearchHeader.viewHeight()
        searchVcTopCons?.constant = 0
        loadingViewTopCons?.constant = headerHeight
        tableViewTopCons?.constant = headerHeight
    }
    
    var barViewBottomCons: NSLayoutConstraint?
    var searchVcTopCons: NSLayoutConstraint?
    var searchVcHeightCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "发现"

        tableView.register(IndustryArticleCell.self, forCellReuseIdentifier: "IndustryArticleCell")
        emptyMsg = "暂无相关数据"
        
        let headerHeight = ArticleSearchHeader.viewHeight()
        tableViewTopCons.constant = headerHeight
        setupLoadingView()
        loadingViewTopCons?.constant = headerHeight
        
        setupRefreshHeader()
        setupRefreshFooter()
        
        loadDataOnFirstWillAppear = false
        
        view.addSubview(coverBtn)
        coverBtn.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()

        view.addSubview(barView)
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).MAKE()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ArticleMainViewControler.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ArticleMainViewControler.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ArticleMainViewControler.getMessageCount), name: ReciveMessage, object: nil)
        
        view.addSubview(searchCover)
        searchCover.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        view.addSubview(searchVc.view)
        searchVc.view.IN(view).LEFT.RIGHT.MAKE()
        self.addChildViewController(searchVc)
        searchVcTopCons = searchVc.view.TOP.EQUAL(view).TOP.MAKE()
        searchVcHeightCons = searchVc.view.HEIGHT.EQUAL(ArticleSearchViewController.initHeight).MAKE()
        
        view.addSubview(loginView)
        loginView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMessageCount()
        let tabbar = self.tabBarController as? MainTabBarController
        tabbar?.reciveMessage()
        update()
    }
    
    func getMessageCount(){
        ChatManage.shareInstance.getAllUnReadMessage()
        messageItem.count = Account.sharedOne.amountBadge
    }
    
    func update() {

        if Account.sharedOne.isLogin {
            loginView.isHidden = true
            self.statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
            
            setupRightNavItems(items: writeItem)
            setupLeftNavItems(items: messageItem)

            showNav()
            
            if !loaded {
                loadData()
            }
            
        } else {
            loginView.isHidden = false
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
            removeRightNavItems()
            removeLeftNavItems()
            hideNav()
            loaded = false
        }
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if Account.sharedOne.isLogin {
            loadData()
        }
    }
    
    func initStatus() {
        initSearchHead()
        tableView.contentOffset = CGPoint.zero
        lastDate = nil
        start = 0
        items.removeAll()
        tableView.reloadData()
    }
    
//    override func initStatus() {
//        super.initStatus()
//        initSearchHead()
//        tableView.contentOffset = CGPoint.zero
//        lastDate = nil
//        start = 0
//        items.removeAll()
//        tableView.reloadData()
//    }
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        
        let filter: ArticleFilter
        if isFilterMode {
           filter = self.searchVc.filterModel
        } else {
            filter = self.searchVc.cleanModel
        }
        
        ArticleManager.shareInstance.filterIndexArticles(user: me, dateForPaging: self.lastDate, startForPaging: self.start, rows: 10, filter: filter, keyword: self.keyword, success: { [weak self] (code, msg, articles) in
            if code == 0 {
                if let s = self {
                    let articles = articles!
                    if s.start == 0 {
                        if articles.count == 0 {
                            done(.empty)
                        } else {
                            done(.thereIsMore)
                        }
                        var items = [IndustryArticleItem]()
                        for a in articles {
                            let item = IndustryArticleItem(model: a)
                            items.append(item)
                        }
                        s.items = items
                        
                    } else {
                        if articles.count == 0 {
                            done(.noMore)
                        } else {
                            done(.thereIsMore)
                        }
                        var items = [IndustryArticleItem]()
                        for a in articles {
                            let item = IndustryArticleItem(model: a)
                            items.append(item)
                        }
                        s.items += items
                    }
                    s.lastDate = articles.last?.dateForPaging
                    s.start += 10
                    s.hasData = s.items.count > 0
                    s.tableView.reloadData()
                }
            } else {
                self?.initSearchHead()
                if let s = self {
                    s.hasData = s.items.count > 0
                    QXTiper.showWarning(msg, inView: s.view, cover: true)
                    done(.err)
                }
            }
        }) { [weak self] (error) in
            self?.initSearchHead()
            if let s = self {
                s.hasData = s.items.count > 0
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: s.view, cover: true)
                done(.err)
            }
        }
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        initSearchHead()
        loaded = true
        resetFooter()
        lastDate = nil
        start = 0
        loadMore(done)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    var lastOffset: CGPoint?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndustryArticleCell") as! IndustryArticleCell
        cell.item = items[indexPath.row]
        cell.indexPath = indexPath
        cell.respondFold = { [unowned self] item in
            self.tableView.reloadData()
        }
        cell.respondUser = { [unowned self] user in
            let vc = UserDetailViewController()
            vc.user = user
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.respondItem = { [unowned self] item in
            if item.model.type != .project || item.model.user.isMe() {
                let vc = ArticleDetailViewControler()
                vc.orgienArticle = item.model
                vc.vcBefore = self
                vc.hidesBottomBarWhenPushed = true
                vc.respondUpdate = { [unowned self] article in
                    self.handleDetailChange(item: item, detailArticle: article)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                if item.model.type == .project {
                    if ArticleWriteLimitChecker.check(onVc: self, operation: "查看项目详情") {
                        let isPublic = SafeUnwarp((item.model.attachments as! ArticleProjectAttachments).detailPublic, holderForNull: false)
                        if isPublic {
                            let vc = ArticleDetailViewControler()
                            vc.orgienArticle = item.model
                            vc.vcBefore = self
                            vc.hidesBottomBarWhenPushed = true
                            vc.respondUpdate = { [unowned self] article in
                                self.handleDetailChange(item: item, detailArticle: article)
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            if item.model.viewType == .success {
                                let vc = ArticleDetailViewControler()
                                vc.orgienArticle = item.model
                                vc.vcBefore = self
                                vc.hidesBottomBarWhenPushed = true
                                vc.respondUpdate = { [unowned self] article in
                                    self.handleDetailChange(item: item, detailArticle: article)
                                }
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else if item.model.viewType == .applying {
                                QXTiper.showWarning("您已申请查看，等待对方处理", inView: self.view, cover: true)
                            } else {
                                Confirmer.show("查看确认", message: "是否申请查看？", confirm: "申请", confirmHandler: { [weak self] in
                                    self?.hanldeView(item)
                                    }, cancel: "取消", cancelHandler: nil, inVc: self)
                            }
                        }
                    }
                }
            }
        }
        cell.respondPictures = { [unowned self] idx, pics in
            let vc = PhotoViewerViewController()
            var items: [PhotoViewerItem] = [PhotoViewerItem]()
            for pic in pics {
                let image = Image()
                image.thumUrl = pic.thumbUrl
                image.url = pic.url
                let item = PhotoViewerItem(image: image, select: false)
                items.append(item)
            }
            vc.isTapBackMode = true
            vc.items = items
            vc.currentIndex = idx
            vc.isSelectModel = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.respondComment = { [unowned self, unowned cell] item, replyComment, indexPath in
            if ArticleWriteLimitChecker.check(onVc: self, operation: "评论文章") {
                
                if let replyUser = replyComment?.user {
                    if replyUser.isMe() {
                        return
                    }
                }
                
                if item.model.type == .project && !item.model.user.isMe()  {
                    let isPublic = SafeUnwarp((item.model.attachments as! ArticleProjectAttachments).detailPublic, holderForNull: false)
                    if !isPublic {
                        if item.model.viewType == .applying {
                            QXTiper.showWarning("您已申请查看，对方同意后可评论", inView: self.view, cover: true)
                            return
                        } else if item.model.viewType == .notApply {
                            Confirmer.show("查看确认", message: "申请查看后才可评论，是否申请？", confirm: "申请查看", confirmHandler: { [weak self] in
                                self?.hanldeView(item)
                                }, cancel: "取消", cancelHandler: nil, inVc: self)
                            return
                        }
                    }
                }
                
                self.commentItem = item
                self.replyComment = replyComment

                self.barView.commentField.textField.text = nil
                self.barView.commentField.textField.becomeFirstResponder()
                
                var y = cell.frame.minY
                if let replyComment = replyComment {
                    self.barView.commentField.textField.placeholder = "回复：" + SafeUnwarp(replyComment.user.realName, holderForNull: "")
                    y = cell.commentsView.frame.minY
                    let p = CGPoint(x: 0, y: y)
                    y = cell.contentView.convert(p, to: tableView).y - 10
                } else {
                    self.barView.commentField.textField.placeholder = "写评论："
                }

                self.lastOffset = self.tableView.contentOffset
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.tableView.contentOffset = CGPoint(x: 0, y: y)
                    })
            }
        }
        cell.respondAgree = { [unowned self] item in
            var text = "点赞文章"
            if ArticleDetailHelper.checkListShow(article: item.model).agreeIsAttention {
                text = "关注文章"
            }
            if ArticleWriteLimitChecker.check(onVc: self, operation: text) {
                self.hanldeAgree(item)
            }
        }
        cell.respondShare = { [unowned self] item in
            if ArticleWriteLimitChecker.check(onVc: self, operation: "分享") {
                self.handleShare(article: item.model)
            }
        }
        cell.respondView = { [unowned self] item in
            if ArticleWriteLimitChecker.check(onVc: self, operation: "申请查看项目") {
                if item.model.viewType == .applying {
                    QXTiper.showWarning("您已申请查看，等待对方处理", inView: self.view, cover: true)
                } else {
                    Confirmer.show("查看确认", message: "是否申请查看？", confirm: "申请", confirmHandler: { [weak self] in
                        self?.hanldeView(item)
                        }, cancel: "取消", cancelHandler: nil, inVc: self)
                }
            }
        }
        cell.respondIndustry = { [unowned self] industry in
            let vc = IndustryArticleViewController()
            vc.industry = industry
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items[indexPath.row].cellHeight
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    var lastOffsetY: CGFloat = 0
    var searchVcOffsetY: CGFloat = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isDragging {
            
            let offsetY = scrollView.contentOffset.y
            let maxOffsetY = scrollView.contentSize.height - scrollView.frame.height + ArticleSearchViewController.initHeight
            if offsetY >= maxOffsetY {
                return
            }
            
            if offsetY > 0 {
                let deltaY = offsetY - lastOffsetY
                searchVcOffsetY -= deltaY
                if searchVcOffsetY > 0 {
                    searchVcOffsetY = 0
                }
                if searchVcOffsetY < -ArticleSearchHeader.headerHeight() {
                    searchVcOffsetY = -ArticleSearchHeader.headerHeight()
                }
                searchVcTopCons?.constant = searchVcOffsetY
                
                let headerHeight = ArticleSearchHeader.viewHeight()
                loadingViewTopCons?.constant = headerHeight + searchVcOffsetY
                tableViewTopCons?.constant = headerHeight + searchVcOffsetY

                lastOffsetY = offsetY
            }
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
        barViewBottomCons?.constant = 0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) 
        tableView.tableFooterView = origenFooterView
        origenFooterView = nil
        
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
        
        if !Account.sharedOne.isLogin { return }
        
        let item = commentItem!
        let me = Account.sharedOne.user
        let article = item.model
        
        let comment = Comment()
        comment.articleId = article.id
        comment.articleAuthorId = article.user.id
        comment.content = text
        comment.user = me
        comment.replyUser = replyComment?.user
        comment.createDate = Date()
        
        ArticleManager.shareInstance.comment(me, comment: replyComment, article: article, content: text, success: { [weak self] (code, message, ret) in
            if code == 0 {
                self?.barView.commentField.textField.text = nil
                item.append(comment: comment)
                item.model.commentCount = SafeUnwarp(item.model.commentCount, holderForNull: 0) + 1
                item.update()
                self?.tableView.reloadData()
                
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func handleDetailChange(item: IndustryArticleItem, detailArticle: Article?) {
        
        if let detailArticle = detailArticle {
            item.model.isAgree = detailArticle.isAgree
            item.model.agreeCount = detailArticle.agreeCount
            item.model.commentCount = detailArticle.commentCount
            item.model.applyViewCount = detailArticle.applyViewCount
            item.model.acceptViewCount = detailArticle.acceptViewCount
            item.update()
            tableView.reloadData()
        }
//        else {
//            let idx = items.index(where: { (item1) -> Bool in
//                return item1.model.id == item.model.id
//            })
//            if let idx = idx {
//                items.remove(at: idx)
//                tableView.reloadData()
//            }
//        }
    }
    
    func hanldeAgree(_ item: IndustryArticleItem) {
        
        if !Account.sharedOne.isLogin { return }

        item.canAgree = false
        let agree = !SafeUnwarp(item.model.isAgree, holderForNull: false)
        item.model.isAgree = agree
        if agree {
            item.model.agreeCount = SafeUnwarp(item.model.agreeCount, holderForNull: 0) + 1
        } else {
            var c = SafeUnwarp(item.model.agreeCount, holderForNull: 0)
            if c > 0 {
                c -= 1
            }
            item.model.agreeCount = c
        }
        item.update()
        
        let me = Account.sharedOne.user
        tableView.reloadData()
        
        ArticleManager.shareInstance.agree(me, article: item.model, agree: agree, success: { [weak self] (code, message, ret) in
            item.canAgree = true
            if code == 0 {
                let meAgree = Agree()
                meAgree.user = me
                meAgree.createDate = Date()
                if agree {
                    item.checkOrAppendByName(agree: meAgree)
                } else {
                    item.checkOrRemoveByName(agree: meAgree)
                }
                item.update()
                self?.tableView.reloadData()
                
            } else {
                item.model.isAgree = !agree
                if agree {
                    var c = SafeUnwarp(item.model.agreeCount, holderForNull: 0)
                    if c > 0 {
                        c -= 1
                    }
                    item.model.agreeCount = c
                } else {
                    item.model.agreeCount = SafeUnwarp(item.model.agreeCount, holderForNull: 0) + 1
                }
                item.update()
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
            self?.tableView.reloadData()
            }) { [weak self] (error) in
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                item.canAgree = true
                item.model.isAgree = !agree
                if agree {
                    var c = SafeUnwarp(item.model.agreeCount, holderForNull: 0)
                    if c > 0 {
                        c -= 1
                    }
                    item.model.agreeCount = c
                } else {
                    item.model.agreeCount = SafeUnwarp(item.model.agreeCount, holderForNull: 0) + 1
                }
                item.update()
                self?.tableView.reloadData()
        }
    }
    
    
    /// 申请查看项目
    ///
    /// - Parameter item: 
    func hanldeView(_ item: IndustryArticleItem) {
        
        if item.model.viewType == .applying { return }
        if !Account.sharedOne.isLogin { return }
        let me = Account.sharedOne.user
        
        let lastApplyType = item.model.viewType
        item.model.viewType = .applying
        item.model.applyViewCount = SafeUnwarp(item.model.applyViewCount, holderForNull: 0) + 1
        item.canView = false
        item.update()
        tableView.reloadData()
        
        let type = ArticleViewType.applying
       
        commitModel.projectId = item.model.id
        commitModel.projectUserId = item.model.user.id
        commitModel.applyUserId = me.id
        commitModel.applyStatus = type.rawValue
        weak var ws = self
        ChatManage.shareInstance.applyCheckCommit(articleModel:item.model, model: commitModel, success: { [weak self] code, msg, model in
            item.canView = true
            if code == 0 {
                // 发送申请
                if model != nil{
                    ChatManage.shareInstance.sendApplyCheck(articleModel:item.model, user: item.model.user, model: model!)
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                item.model.viewType = lastApplyType
                item.model.applyViewCount = SafeUnwarp(item.model.applyViewCount, holderForNull: 0) - 1
            }
            item.update()
            self?.tableView.reloadData()
            
        }, failed: { [weak self] error in
            item.canView = true
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            item.model.viewType = lastApplyType
            item.model.applyViewCount = SafeUnwarp(item.model.applyViewCount, holderForNull: 0) - 1
            item.update()
            self?.tableView.reloadData()
        })
    }
    
    
    /// 分享
    ///
    /// - Parameter article: 文章模型
    func handleShare(article: Article){
        let vc = ChooseFriendViewController()
        vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
//        if let infoDic = article.shareInfo {
//            let vc = ShareViewController()
//            vc.modalPresentationStyle = .custom
//            vc.transitioningDelegate = self
//            vc.articleInfo = infoDic
//            self.present(vc, animated: true) {
//            }
//            vc.respondSuccess = { [unowned self] in
//                if !Account.sharedOne.isLogin { return }
//                let me = Account.sharedOne.user
//                ArticleManager.shareInstance.share(me, article: article, success: { (code, msg, ret) in
//                    print(code)
//                }, failed: { (err) in
//                    print(err)
//                })
//            }
//        }
//        if let info = info {
//            BusinessTool.share(info: info, done: { [weak self] (success, msg) in
//                if success {
//                    QXTiper.showSuccess(msg, inView: self?.view, cover: true)
//                } else {
//                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
//                }
//                })
//        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
