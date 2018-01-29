//
//  ArticleDetailViewControler.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/20.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleDetailViewControler: RootTableViewController {
    
    var orgienArticle: Article!
    var item: IndustryArticleDetailItem?
    var replyComment: Comment?
    weak var vcBefore: RootTableViewController?
    var respondUpdate: ((_ article: Article?) -> ())?
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        if item == nil {
            self.showLoading()
        }
        
        let user = Account.sharedOne.user
        ArticleManager.shareInstance.getArticleDetail(user, article: orgienArticle, success: { [weak self] (code, msg, article) in
            if code == 0 {
                if let s = self {
                    let article = article!
                    if article.id == nil {
                        QXTiper.showWarning("文章已删除", inView: s.view, cover: true)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                            _ = self?.navigationController?.popViewController(animated: true)
                        }
                        done(.empty)
                        return
                    }
                    s.item = IndustryArticleDetailItem(model: article)
                    s.checkOrSendViewRequestIfProjectPublic()
                    s.headerView.item = s.item
                    s.headerView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: s.item!.viewHeight)
                    s.tableView.tableHeaderView = nil
                    s.tableView.tableHeaderView = s.headerView
                    s.checkOrLoadTagData()
                    s.hasData = true
                    s.tableView.reloadData()
                    s.barView.item = s.item
                }
                done(.noMore)
            // 4002：申请中
            // 4003: 通过
            // 4001： 未申请
            // 4000: 项目不存在
            } else if code == 4002 || code == 4001 || code == 4000 {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                }
                done(.empty)
                
            } else {
                if let s = self {
                    s.hasData = false
                    QXTiper.showWarning(msg, inView: s.view, cover: true)
                    done(.err)
                }
            }
        }) { [weak self] (error) in
            if let s = self {
                s.hasData = false
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: s.view, cover: true)
                done(.err)
            }
        }
    }
    
    func loadMoreTagData() {
        
        if self.item == nil { return }
        let item = self.item!
        
        if item.tagComment {
            item.commentLoadingStatus = .loading
            updateFooter()
            tableView.reloadData()
            
            ArticleManager.shareInstance.getComments(orgienArticle, dateForPaging: item.commentLastDate, success: { [weak self] (code, msg, comments) in
                if code == 0 {
                    let comments = comments!
                    var items = [IndustryArticleDetailCommentItem]()
                    for comment in comments {
                        let item = IndustryArticleDetailCommentItem(comment: comment)
                        item.update()
                        items.append(item)
                    }
                    item.commentThereIsMore = items.count > 0
                    if item.commentLastDate == nil {
                        item.commentItems = items
                    } else {
                        item.commentItems += items
                    }
                    if item.commentItems.count > 0 {
                        item.commentLoadingStatus = .done
                    } else {
                        item.commentLoadingStatus = .doneEmpty
                    }
                    item.commentLastDate = items.last?.comment.dateForPaging
                    
                } else {
                    item.commentLoadingStatus = .doneErr
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
                self?.updateFooter()
                self?.tableView.reloadData()
                }, failed: { [weak self] (error) in
                    QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                    item.commentLoadingStatus = .doneErr
                    self?.updateFooter()
                    self?.tableView.reloadData()
            })
            
        } else {
            
            if item.showView {
                
                item.viewLoadingStatus = .loading
                updateFooter()
                tableView.reloadData()
                
                ArticleManager.shareInstance.getViews(orgienArticle, dateForPaging: item.viewLastDate, success: { [weak self] (code, msg, views) in
                    if code == 0 {
                        let views = views!
                        var items = [IndustryArticleDetailViewItem]()
                        var isPublic = false
                        if let b = (self?.item?.model.attachments as? ArticleProjectAttachments)?.detailPublic {
                            isPublic = b
                        }
                        for view in views {
                            let item = IndustryArticleDetailViewItem(view: view, isPublic: isPublic)
                            item.update()
                            items.append(item)
                        }
                        item.viewThereIsMore = items.count > 0
                        if item.viewLastDate == nil {
                            item.viewItems = items
                        } else {
                            item.viewItems += items
                        }
                        if item.viewItems.count > 0 {
                            item.viewLoadingStatus = .done
                        } else {
                            item.viewLoadingStatus = .doneEmpty
                        }
                        item.viewLastDate = items.last?.view.createTime
                        
                    } else {
                        item.viewLoadingStatus = .doneErr
                        QXTiper.showWarning(msg, inView: self?.view, cover: true)
                    }
                    self?.updateFooter()
                    self?.tableView.reloadData()
                    }, failed: { [weak self] (error) in
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        item.viewLoadingStatus = .doneErr
                        self?.updateFooter()
                        self?.tableView.reloadData()
                })
                
            } else {
                
                item.agreeLoadingStatus = .loading
                updateFooter()
                tableView.reloadData()
                
                ArticleManager.shareInstance.getAgrees(orgienArticle, dateForPaging: item.agreeLastDate, success: { [weak self] (code, msg, agrees) in
                    if code == 0 {
                        let agrees = agrees!
                        var items = [IndustryArticleDetailAgreeItem]()
                        for agree in agrees {
                            
                            var isChat: Bool = false
                            if let s = self {
                                let a = s.orgienArticle.type != .normal
                                let b = s.orgienArticle.user.isMe()
                                if a && b {
                                    isChat = true
                                }
                            }
                            
                            let item = IndustryArticleDetailAgreeItem(agree: agree, isChat: isChat)
                            item.update()
                            items.append(item)
                        }
                        item.agreeThereIsMore = items.count > 0
                        if item.agreeLastDate == nil {
                            item.agreeItems = items
                        } else {
                            item.agreeItems += items
                        }
                        if item.agreeItems.count > 0 {
                            item.agreeLoadingStatus = .done
                        } else {
                            item.agreeLoadingStatus = .doneEmpty
                        }
                        item.agreeLastDate = items.last?.agree.dateForPaging
                        
                    } else {
                        item.agreeLoadingStatus = .doneErr
                        QXTiper.showWarning(msg, inView: self?.view, cover: true)
                    }
                    self?.updateFooter()
                    self?.tableView.reloadData()
                    }, failed: { [weak self] (error) in
                        QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                        item.agreeLoadingStatus = .doneErr
                        self?.updateFooter()
                        self?.tableView.reloadData()
                })
                
            }
        }
        
    }
    
    /// 当是项目，并且不是自己的时候，在查看列表新增一条数据
    func checkOrSendViewRequestIfProjectPublic() {
        if let article = self.item?.model {
            if let attachments = article.attachments as? ArticleProjectAttachments {
                if let detailPublic = attachments.detailPublic {
                    if detailPublic {
                        if !article.user.isMe() {
                            let type = ArticleViewType.success
                            let model = ProjectViewCommitDataModel()
                            let me = Account.sharedOne.user
                            model.projectId = article.id
                            model.projectUserId = article.user.id
                            model.applyUserId = me.id
                            model.applyStatus = type.rawValue
                            // 发送申请
                            ChatManage.shareInstance.applyCheckCommit(articleModel: article, model: model, success: {_, _, _ in}, failed: {_ in })
                        }
                    }
                }
            }
        }
    }
    
    func checkOrLoadTagData() {
        if self.item == nil { return }
        let item = self.item!
        if item.tagComment {
            updateFooter()
            if item.commentLoadingStatus == .loading {
                loadMoreTagData()
            }
        } else {
            if item.showView {
                updateFooter()
                if item.viewLoadingStatus == .loading {
                    loadMoreTagData()
                }
            } else {
                updateFooter()
                if item.agreeLoadingStatus == .loading {
                    loadMoreTagData()
                }
            }
        }
    }
    
    func updateFooter() {
        if let item = item {
            if item.tagComment {
                if item.commentItems.count > 0 {
                    appendFooter()
                    if item.commentThereIsMore {
                        footer.endRefreshing()
                    } else {
                        footer.endRefreshingWithNoMoreData()
                    }
                } else {
                    removeFooter()
                }
            } else {
                
                if item.showView {
                    if item.viewItems.count > 0 {
                        appendFooter()
                        if item.viewThereIsMore {
                            footer.endRefreshing()
                        } else {
                            footer.endRefreshingWithNoMoreData()
                        }
                    } else {
                        removeFooter()
                    }
                } else {
                    if item.agreeItems.count > 0 {
                        appendFooter()
                        if item.agreeThereIsMore {
                            footer.endRefreshing()
                        } else {
                            footer.endRefreshingWithNoMoreData()
                        }
                    } else {
                        removeFooter()
                    }
                }
            }
        } else {
            removeFooter()
        }
    }
    
    /// 添加刷新尾
    lazy var footer: MJRefreshAutoNormalFooter = {
        let one =  MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadMoreTagData()
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
    
    lazy var headerView: IndustryArticleDetailHeaderView = {
        let one = IndustryArticleDetailHeaderView()
        one.respondUser = { [unowned self] user in
            let vc = UserDetailViewController()
            vc.user = user
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondIndustry = { [unowned self] industry in
            let vc = IndustryArticleViewController()
            vc.industry = industry
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondFold = { [unowned self] item in
            self.tableView.tableHeaderView = nil
            self.headerView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: self.item!.viewHeight)
            self.tableView.tableHeaderView = self.headerView
        }
        one.respondPictures = { [unowned self] idx, pics in
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
        one.segView.respondA = {
            self.item?.tagComment = false
            self.tableView.reloadData()
            self.checkOrLoadTagData()
        }
        one.segView.respondB = {
            self.item?.tagComment = true
            self.tableView.reloadData()
            self.checkOrLoadTagData()
        }
        one.respondUrl = { [unowned self] url in
            let vc = CommonWebViewController()
            vc.url = url
            vc.title = "活动链接"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondCompany = { [unowned self] id in
            let vc = EnterpriseDetailViewController()
            vc.id = "\(id)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.projectPointsView.respondSpot = { [unowned self, unowned one] article in
            let vc = ArticleProjectTextBubbleViewController()
            vc.text = (article.attachments as? ArticleProjectAttachments)?.spot
            vc.headTitle = "项目亮点"
            
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        one.projectPointsView.respondBrief = { [unowned self] article in
            let vc = ArticleProjectBriefBubbleViewController()
            vc.article = article
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
            vc.respondPictures = { [unowned vc] idx, pics in
                let pvc = PhotoViewerViewController()
                var items: [PhotoViewerItem] = [PhotoViewerItem]()
                for pic in pics {
                    let image = Image()
                    image.thumUrl = pic.thumbUrl
                    image.url = pic.url
                    let item = PhotoViewerItem(image: image, select: false)
                    items.append(item)
                }
                pvc.isTapBackMode = true
                pvc.items = items
                pvc.currentIndex = idx
                pvc.isSelectModel = false
                vc.navigationController?.pushViewController(pvc, animated: true)
            }
        }
        one.projectPointsView.respondPain = { [unowned self] article in
            let vc = ArticleProjectTextBubbleViewController()
            vc.text = (article.attachments as? ArticleProjectAttachments)?.pain
            vc.headTitle = "行业痛点"
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        one.projectPointsView.respondMembers = { [unowned self] article in
            let vc = ArticleProjectTextBubbleViewController()
            vc.text = (article.attachments as? ArticleProjectAttachments)?.members
            vc.headTitle = "创始团队"
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        one.projectPointsView.respondBussiness = { [unowned self] article in
            let vc = ArticleProjectTextBubbleViewController()
            vc.text = (article.attachments as? ArticleProjectAttachments)?.bussiness
            vc.headTitle = "商业模式"
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        one.projectPointsView.respondData = { [unowned self] article in
            let vc = ArticleProjectTextBubbleViewController()
            vc.text = (article.attachments as? ArticleProjectAttachments)?.data
            vc.headTitle = "运营数据"
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        one.projectPointsView.respondMaketing = { [unowned self] article in
            let vc = ArticleProjectTextBubbleViewController()
            vc.text = (article.attachments as? ArticleProjectAttachments)?.marketing
            vc.headTitle = "市场状况"
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        one.projectPointsView.respondExit = { [unowned self] article in
            let vc = ArticleProjectTextBubbleViewController()
            vc.text = (article.attachments as? ArticleProjectAttachments)?.exit
            vc.headTitle = "退出方案"
            BubbleHelper.show(vc, startPoint: nil, onVc: self)
        }
        
        return one
    }()
    
    lazy var barView: ArticleDetailBarView = {
        let one = ArticleDetailBarView()
        one.respondComment = { [unowned self] text in
            self.handleComment(text, self.replyComment)
        }
        one.respondAgree = { [unowned self] in
            var text = "点赞文章"
            if ArticleDetailHelper.checkListShow(article: self.orgienArticle).agreeIsAttention {
                text = "关注文章"
            }
            if ArticleWriteLimitChecker.check(onVc: self, operation: text) {
                self.hanldeAgree(self.item!)
            }
        }
        one.respondShare = { [unowned self] in
            self.handleShare(info: self.item!.model)
        }
        //        one.respondComment = { [unowned self] item in
        //            self.replyUser = nil
        //            self.barView.commentField.textField.becomeFirstResponder()
        //            self.tableView.scrollsToTop = true
        //        }
        one.respondBeginEdit = { [unowned self] in
            return ArticleWriteLimitChecker.check(onVc: self, operation: "评论文章")
        }
        return one
    }()
    lazy var coverBtn: UIButton = {
        let one = UIButton()
        one.isHidden = true
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            self.view.endEditing(true)
            self.replyComment = nil
        })
        return one
    }()
    
    lazy var deleteNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "删除", responder: { [unowned self] in
            Confirmer.show("确认", message: "您确定要删除文章？", confirm: "删除", confirmHandler: { [weak self] in
                self?.handleDelete()
                }, cancel: "取消", cancelHandler: nil, inVc: self)
        })
        return one
    }()
    lazy var loadingNavItem: BarButtonItem = {
        let one = BarButtonItem(indicatorStyle: .gray)
        return one
    }()
    
    var barViewBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBackBlackButton(nil)
        
        tableViewBottomCons?.constant = -barView.viewHeight
        tableView.register(IndustryArticleDetailCommentCell.self, forCellReuseIdentifier: "IndustryArticleDetailCommentCell")
        tableView.register(IndustryArticleDetailAgreeCell.self, forCellReuseIdentifier: "IndustryArticleDetailAgreeCell")
        tableView.register(IndustryArticleDetailViewCell.self, forCellReuseIdentifier: "IndustryArticleDetailViewCell")
        
        view.addSubview(coverBtn)
        coverBtn.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        view.addSubview(barView)
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).MAKE()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ArticleDetailViewControler.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ArticleDetailViewControler.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        switch orgienArticle.type {
        case .normal:
            title = "八卦详情"
        case .activity:
            title = "活动详情"
        case .project:
            title = "项目详情"
        case .manpower:
            title = "人才详情"
        case .all:
            title = "发现详情"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
        if orgienArticle.user.isMe() {
            setupRightNavItems(items: deleteNavItem)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let item = item {
            if item.tagComment {
                if item.commentItems.count > 0 {
                    return item.commentItems.count
                } else {
                    return 1
                }
            } else {
                if item.showView {
                    if item.viewItems.count > 0 {
                        return item.viewItems.count
                    } else {
                        return 1
                    }
                } else {
                    if item.agreeItems.count > 0 {
                        return item.agreeItems.count
                    } else {
                        return 1
                    }
                }
            }
        }
        return 0
    }
    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = item {
            if item.tagComment {
                if item.commentItems.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "IndustryArticleDetailCommentCell") as! IndustryArticleDetailCommentCell
                    cell.item = item.commentItems[indexPath.row]
                    cell.indexPath = indexPath
                    cell.respondItem = { [unowned self] item, indexPath in
                        self.handleCommentItem(item: item, indexPath: indexPath)
                    }
                    cell.respondUser = { [unowned self] user in
                        let vc = UserDetailViewController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.user = user
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.showBottomLine = !(indexPath.row == item.commentItems.count - 1)
                    return cell
                } else {
                    if item.commentLoadingStatus == .doneEmpty {
                        loadingCell.showEmpty("没有评论")
                    } else if item.commentLoadingStatus == .doneErr {
                        loadingCell.showFailed(self.faliedMsg)
                    } else {
                        loadingCell.showLoading()
                    }
                    loadingCell.respondReload = { [unowned self] in
                        if item.tagComment {
                            item.commentLoadingStatus = .loading
                        } else {
                            if item.showView {
                                item.viewLoadingStatus = .loading
                            } else {
                                item.agreeLoadingStatus = .loading
                            }
                        }
                        self.checkOrLoadTagData()
                    }
                    return loadingCell
                }
                
            } else {
                
                if item.showView {
                    if item.viewItems.count > 0 {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "IndustryArticleDetailViewCell") as! IndustryArticleDetailViewCell
                        cell.item = item.viewItems[indexPath.row]
                        cell.respondUser = { [unowned self] user in
                            let vc = UserDetailViewController()
                            vc.hidesBottomBarWhenPushed = true
                            vc.user = user
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        cell.respondChat = { [unowned self] user in
                            let vc = ChatViewController(conversationChatter: user.huanXinId, conversationType: EMConversationTypeChat)
                            vc?.userName = SafeUnwarp(user.realName, holderForNull: "")
                            vc?.userImg = user.avatar
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        cell.respondHanlde = { [unowned self] item in
                            self.handleView(item: item)
                        }
                        cell.showBottomLine = !(indexPath.row == item.agreeItems.count - 1)
                        return cell
                        
                    } else {
                        if item.viewLoadingStatus == .doneEmpty {
                            loadingCell.showEmpty("没有查看")
                        } else if item.agreeLoadingStatus == .doneErr {
                            loadingCell.showFailed(self.faliedMsg)
                        } else {
                            loadingCell.showLoading()
                        }
                        loadingCell.respondReload = { [unowned self] in
                            if item.tagComment {
                                item.commentLoadingStatus = .loading
                            } else {
                                if item.showView {
                                    item.viewLoadingStatus = .loading
                                } else {
                                    item.agreeLoadingStatus = .loading
                                }
                            }
                            self.checkOrLoadTagData()
                        }
                        return loadingCell
                    }
                    
                } else {
                    
                    if item.agreeItems.count > 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "IndustryArticleDetailAgreeCell") as! IndustryArticleDetailAgreeCell
                        cell.item = item.agreeItems[indexPath.row]
                        cell.respondUser = { [unowned self] user in
                            let vc = UserDetailViewController()
                            vc.hidesBottomBarWhenPushed = true
                            vc.user = user
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        cell.respondChat = { [unowned self] user in
                            let vc = ChatViewController(conversationChatter: user.huanXinId, conversationType: EMConversationTypeChat)
                            vc?.userName = SafeUnwarp(user.realName, holderForNull: "")
                            vc?.userImg = user.avatar
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        cell.showBottomLine = !(indexPath.row == item.agreeItems.count - 1)
                        return cell
                        
                    } else {
                        if item.agreeLoadingStatus == .doneEmpty {
                            loadingCell.showEmpty("没有点赞")
                        } else if item.agreeLoadingStatus == .doneErr {
                            loadingCell.showFailed(self.faliedMsg)
                        } else {
                            loadingCell.showLoading()
                        }
                        loadingCell.respondReload = { [unowned self] in
                            if item.tagComment {
                                item.commentLoadingStatus = .loading
                            } else {
                                if item.showView {
                                    item.viewLoadingStatus = .loading
                                } else {
                                    item.agreeLoadingStatus = .loading
                                }
                            }
                            self.checkOrLoadTagData()
                        }
                        return loadingCell
                    }
                    
                }
                
            }
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let item = item {
            if item.tagComment {
                if item.commentItems.count > 0 {
                    let item = item.commentItems[indexPath.row]
                    return item.cellHeight
                } else {
                    return 300
                }
            } else {
                if item.showView {
                    if item.viewItems.count > 0 {
                        let item = item.viewItems[indexPath.row]
                        return item.cellHeight
                    } else {
                        return 300
                    }
                } else {
                    if item.agreeItems.count > 0 {
                        let item = item.agreeItems[indexPath.row]
                        return item.cellHeight
                    } else {
                        return 300
                    }
                }
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
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
        
    }
    
    func handleDelete() {
        
        if !Account.sharedOne.isLogin { return }
        
        let user = Account.sharedOne.user
        
        let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
        setupRightNavItems(items: loadingNavItem)
        
        ArticleManager.shareInstance.delete(user, article: orgienArticle, success: { [weak self] (code, message, ret) in
            QXTiper.hideWaiting(wait)
            self?.setupRightNavItems(items: self?.deleteNavItem)
            if code == 0 {
                QXTiper.showSuccess("删除成功", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                    self?.vcBefore?.performRefresh()
                }
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            self?.setupRightNavItems(items: self?.deleteNavItem)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func handleDeleteComment(_ comment: Comment) {
        
        if !Account.sharedOne.isLogin { return }
        
        let user = Account.sharedOne.user
        let id = SafeUnwarp(comment.id, holderForNull: "")
        let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
        ArticleManager.shareInstance.deleteComment(user, article: orgienArticle, commentId: id, success: { [weak self] (code, message, ret) in
            QXTiper.hideWaiting(wait)
            self?.navigationItem.rightBarButtonItem = self?.deleteNavItem
            if code == 0 {
                QXTiper.showSuccess("删除成功", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    self?.item?.model.commentCount = SafeUnwarp(self?.item?.model.commentCount, holderForNull: 1) - 1
                    self?.item?.tagComment = true
                    self?.item?.commentLastDate = nil
                    self?.item?.commentItems.removeAll()
                    self?.item?.commentLoadingStatus = .loading
                    self?.headerView.item = self?.item
                    self?.checkOrLoadTagData()
                    self?.respondUpdate?(self?.item?.model)
                }
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func handleComment(_ text: String, _ replyComment: Comment?) {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.comment(text, replyComment)
        }
    }
    func comment(_ text: String, _ replyComment: Comment?) {
        
        if !Account.sharedOne.isLogin { return }
        
        let wait = QXTiper.showWaiting("评论中...", inView: view, cover: true)
        let user = Account.sharedOne.user
        let article = item!.model
        
        ArticleManager.shareInstance.comment(user, comment: replyComment, article: article, content: text, success: { [weak self] (code, message, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                self?.barView.commentField.textField.text = nil
                QXTiper.showSuccess("评论成功", inView: self?.view, cover: true)
                self?.item?.model.commentCount = SafeUnwarp(self?.item?.model.commentCount, holderForNull: 0) + 1
                self?.item?.tagComment = true
                self?.item?.commentLastDate = nil
                self?.item?.commentLoadingStatus = .loading
                self?.item?.commentItems.removeAll()
                self?.headerView.item = self?.item
                self?.checkOrLoadTagData()
                self?.respondUpdate?(self?.item?.model)
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func hanldeAgree(_ item: IndustryArticleDetailItem) {
        
        if !Account.sharedOne.isLogin { return }
        
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
        
        let user = Account.sharedOne.user
        headerView.item = item
        barView.item = item
        tableView.reloadData()
        barView.agreeButton.forceDown(true)
        self.respondUpdate?(self.item?.model)
        
        ArticleManager.shareInstance.agree(user, article: item.model, agree: agree, success: { [weak self] (code, message, ret) in
            
            self?.barView.agreeButton.forceDown(false)
            
            if code == 0 {
                
                let show = ArticleDetailHelper.checkListShow(article: self?.item?.model)
                
                if show.count != 1 {
                    self?.item?.tagComment = false
                    self?.item?.agreeLastDate = nil
                    self?.item?.agreeLoadingStatus = .loading
                    self?.item?.agreeItems.removeAll()
                }
                self?.headerView.item = self?.item
                self?.checkOrLoadTagData()
                
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
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
            self?.headerView.item = item
            self?.barView.item = item
            self?.tableView.reloadData()
            self?.respondUpdate?(self?.item?.model)
            
        }) { [weak self] (error) in
            self?.barView.agreeButton.forceDown(false)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
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
            self?.headerView.item = item
            self?.barView.item = item
            self?.tableView.reloadData()
            self?.respondUpdate?(self?.item?.model)
        }
    }
    
    func handleView(item: IndustryArticleDetailViewItem) {
        
        if !Account.sharedOne.isLogin { return }
        
        let lastStatus = item.view.applyStatus
        
        //let type = lastStatus == "2" ? ArticleViewType.applying : ArticleViewType.success
        //let me = Account.sharedOne.user
        item.view.applyStatus = lastStatus == "2" ? "1" : "2"
        if let model = self.item?.model {
            ChatManage.shareInstance.applyCheckCommit(articleModel: model, model: item.view, success: { [weak self] code, msg, ret in
                if code == 0 {
                    // 发送消息
                    // ChatManage.shareInstance.sendApplyCheck(articleModel:(ws?.item?.model)!,user: me, model: item.view)
                } else {
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                    item.view.applyStatus = lastStatus
                    self?.tableView.reloadData()
                    self?.respondUpdate?(self?.item?.model)
                    
                }
                }, failed: { [weak self] error in
                    QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                    item.view.applyStatus = lastStatus
                    self?.tableView.reloadData()
                    self?.respondUpdate?(self?.item?.model)
            })
            
        }
        
    }
    
    func handleCommentItem(item: IndustryArticleDetailCommentItem, indexPath: IndexPath) {
        
        if item.comment.user.isMe() {
            Confirmer.show("删除确认", message: "您确定要删除评论？", confirm: "删除", confirmHandler: { [weak self] in
                self?.handleDeleteComment(item.comment)
                }, cancel: "取消", cancelHandler: {
            }, inVc: self)
        } else {
            replyComment = item.comment
            self.barView.commentField.textField.text = nil
            self.barView.commentField.textField.becomeFirstResponder()
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func handleShare(info:Article){
        let vc = ChooseFriendViewController()
        vc.article = info
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

