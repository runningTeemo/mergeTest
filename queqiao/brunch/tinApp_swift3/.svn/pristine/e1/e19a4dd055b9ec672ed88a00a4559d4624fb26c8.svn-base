//
//  IndustryArticleViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class IndustryArticleViewController: RootTableViewController {
    
    weak var vcBefore: RootTableViewController?
    
    var industry: Industry!
    var circle: Circle?
    
    var items: [IndustryArticleItem] = [IndustryArticleItem]()
    var lastDate: String?
    var start: Int = 0
    
    var commentItem: IndustryArticleItem?
    var loaded: Bool = false
    var replyComment: Comment?
    
    var articlesLoadingStatus: LoadStatus = .loading
    var moreArticles: Bool = true
    
    /// 首次进入加载头部数据
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        let industry = self.industry!
        
        ArticleManager.shareInstance.getCircleInfo(me, industry: industry, success: { [weak self] (code, msg, circle) in
            if code == 0 {
                self?.circle = circle!
                self?.headView.model = circle!
                self?.articlesLoadingStatus = .loading
                self?.moreArticles = true
                done(.noMore)
                self?.start = 0
                self?.lastDate = nil
                self?.checkOrLoadArticles()
                
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
            }) { [weak self] (err) in
                QXTiper.showFailed(kWebErrMsg + "(\(err.code))", inView: self?.view, cover: true)
                done(.err)
        }
    }
    
    func checkOrLoadArticles() {
        
        if !Account.sharedOne.isLogin { return }
        
        updateFooter()
        tableView.reloadData()
        
        if articlesLoadingStatus == .loading {
            
            let me = Account.sharedOne.user
            ArticleManager.shareInstance.getIndustryArticlesNew(me, dateForPaging: self.lastDate, startForPaging: self.start, rows: 10, industry: industry, success: { [weak self] (code, msg, articles) in
                if code == 0 {
                    if let s = self {
                        let articles = articles!
                        if s.start == 0 {
                            if articles.count == 0 {
                                s.moreArticles = false
                            } else {
                                s.moreArticles = true
                            }
                            var items = [IndustryArticleItem]()
                            for a in articles {
                                let item = IndustryArticleItem(model: a)
                                items.append(item)
                            }
                            s.items = items
                        } else {
                            if articles.count == 0 {
                                s.moreArticles = false
                            } else {
                                s.moreArticles = true
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
                        s.articlesLoadingStatus = .done
                        s.updateFooter()
                        s.tableView.reloadData()
                    }
                } else {
                    if let s = self {
                        s.hasData = s.items.count > 0
                        QXTiper.showWarning(msg, inView: s.view, cover: true)
                        s.articlesLoadingStatus = .doneErr
                        s.updateFooter()
                        s.tableView.reloadData()
                    }
                }
            }) { [weak self] (error) in
                if let s = self {
                    s.hasData = s.items.count > 0
                    QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: s.view, cover: true)
                    s.articlesLoadingStatus = .doneErr
                    s.updateFooter()
                    s.tableView.reloadData()
                }
            }
        }
    }
    
    lazy var headView: IndustryArticleHeadView = {
        let one = IndustryArticleHeadView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: one.viewHeight)
        one.segView.respondMember = { [unowned self] in
            let vc = IndustryMembersViewController()
            vc.industry = self.industry
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondAttention = { [unowned self] attention in
            self.handleAttention(attention: attention)
        }
        one.respondParty = { [unowned self] in
            let vc = SetIndustryViewController()
            vc.isAttentionMode = false
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    var barViewBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "发现"
        
        tableView.register(IndustryArticleCell.self, forCellReuseIdentifier: "IndustryArticleCell")
        emptyMsg = "没有圈内消息"
        
        view.addSubview(coverBtn)
        coverBtn.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        view.addSubview(barView)
        barView.LEFT.EQUAL(view).MAKE()
        barView.RIGHT.EQUAL(view).MAKE()
        barViewBottomCons = barView.BOTTOM.EQUAL(view).OFFSET(barView.viewHeight).MAKE()
        
        NotificationCenter.default.addObserver(self, selector: #selector(IndustryArticleViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IndustryArticleViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.tableHeaderView = headView
        tableViewTopCons.constant = -headView.appendHeight
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        
        setupCustomNav()
        customNavView.backBlackBtn.isHidden = true
        customNavView.setupBackButton()
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
        if let circle = self.circle {
            headView.model = circle
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let name = industry.name {
            customNavView.title = name + "行业详情"
        } else {
            customNavView.title = "行业详情"
        }
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)

    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }
    
    
    /// 添加刷新尾
    lazy var footer: MJRefreshAutoNormalFooter = {
        let one =  MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.articlesLoadingStatus = .loading
            self?.checkOrLoadArticles()
            })
        return one!
    }()
    func appendFooter() {
        tableView.mj_footer = footer
    }
    func removeFooter() {
        tableView.mj_footer = nil
    }
    func updateFooter() {
        if items.count == 0 {
            removeFooter()
        } else {
            appendFooter()
            if articlesLoadingStatus != .loading {
                if moreArticles {
                    footer.endRefreshing()
                } else {
                    footer.endRefreshingWithNoMoreData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            return 1
        }
        return items.count
    }
    
    var lastOffset: CGPoint?
    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if items.count == 0 {
            if articlesLoadingStatus == .loading {
                loadingCell.showLoading()
            } else if articlesLoadingStatus == .doneErr {
                loadingCell.showFailed(self.faliedMsg)
            } else {
                loadingCell.showEmpty("没有相关内容")
            }
            loadingCell.respondReload = { [unowned self] in
                self.articlesLoadingStatus = .loading
                self.checkOrLoadArticles()
            }
            return loadingCell
        }
        
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if items.count == 0 {
            return kScreenH - headView.imgH
        }
        return items[indexPath.row].cellHeight
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
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
        
        if let offset = self.lastOffset {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.tableView.contentOffset = offset
                })
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
    
    func handleComment(_ text: String) {
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.comment(text)
        }
    }
    func comment(_ text: String) {
        
        let item = commentItem!
        let me = Account.sharedOne.user
        
        let comment = Comment()
        comment.articleId = item.model.id
        comment.articleAuthorId = item.model.user.id
        comment.content = text
        comment.user = me
        comment.replyUser = self.replyComment?.user
        comment.createDate = Date()
        
        ArticleManager.shareInstance.comment(me, comment: self.replyComment, article: item.model, content: text, success: { [weak self] (code, message, ret) in
            if code == 0 {
                self?.barView.commentField.textField.text = nil
                item.append(comment: comment)
                self?.tableView.reloadData()
            
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
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
        let model = ProjectViewCommitDataModel()
        model.projectId = item.model.id
        model.projectUserId = item.model.user.id
        model.applyUserId = me.id
        model.applyStatus = type.rawValue
        
        ChatManage.shareInstance.applyCheckCommit(articleModel:item.model,model: model, success: { [weak self] code, msg, model in
            item.canView = true
            if code == 0 {
                // 发送申请
                print(item.model)
                ChatManage.shareInstance.sendApplyCheck(articleModel:item.model,user: item.model.user, model: model!)
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
            self?.tableView.reloadData()
        }
    }
    
    
    func handleAttention(attention: Bool) {
        
        self.vcBefore?.clearFirstInStatus()
        
        if !Account.sharedOne.isLogin { return }
        
        if attention {
            if Account.sharedOne.user.industries.count >= 6 {
                QXTiper.showWarning("最多只能关注6个行业", inView: self.view, cover: true)
                return;
            }
        }
        
        let me = Account.sharedOne.user
        headView.segView.handleBtn.forceDown(true)
        headView.segView.handleTitle.text = attention ? "取消关注" : "关注"
        circle?.isAttentioned = attention
        ArticleManager.shareInstance.setAttentionIndustry(me, industry: industry, attention: attention, success: { [weak self] (code, msg, ret) in
            self?.headView.segView.handleBtn.forceDown(false)
            if code == 0 {
                if let s = self {
                    if attention {
                        Account.sharedOne.checkOrAppend(industry: s.industry)
                    } else {
                        Account.sharedOne.checkOrRemove(industry: s.industry)
                    }
                }
            } else {
                if let s = self {
                    s.headView.segView.handleTitle.text = !attention ? "取消关注" : "关注"
                    s.circle?.isAttentioned = !attention
                }
            }
            }) { [weak self] (error) in
                self?.headView.segView.handleBtn.forceDown(false)
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
                if let s = self {
                    s.headView.segView.handleTitle.text = !attention ? "取消关注" : "关注"
                    s.circle?.isAttentioned = !attention
                }
        }
        
    }
    
    func handleShare(info: [String: Any]?){
        if let infoDic = info {
            let vc = ShareViewController()
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.articleInfo = infoDic
            self.present(vc, animated: true) {
            }
        }
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
