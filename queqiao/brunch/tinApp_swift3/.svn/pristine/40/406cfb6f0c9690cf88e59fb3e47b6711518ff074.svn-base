//
//  IndexViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

enum IndexNewsTag: Int {
    case news = 0
    case reports = 1
    case events = 2
}

class IndexViewItem {
    
    var banners: [Banner]?
    
    var topBannerLoadSuccess: Bool = false
    var middleBannerLoadSuccess: Bool = false
    var newsLoadSuccess: Bool = false
    
    var news: [News] = [News]()
    var reports: [News] = [News]()
    var events: [FinacingViewModel] = [FinacingViewModel]()
    
    var newsTag: IndexNewsTag = .news
    
    var newsNeedsReload: Bool = true
    var reportsNeedsReload: Bool = true
    var eventsNeedsReload: Bool = true

    var newsLoadingStatus: LoadStatus = .loading
    var reportsLoadingStatus: LoadStatus = .loading
    var eventsLoadingStatus: LoadStatus = .loading
    
    var currentLoadStatus: LoadStatus {
        switch newsTag {
        case .news:
            return newsLoadingStatus
        case .reports:
            return reportsLoadingStatus
        case .events:
            return eventsLoadingStatus
        }
    }
    var currentEmptyMsg: String {
        switch newsTag {
        case .news:
            return "暂无新闻"
        case .reports:
            return "暂无研究报告"
        case .events:
            return "暂无推荐事件"
        }
    }
}

class IndexViewController: RootTableViewController, LogoutProtocol {
    
    var popToRootIfLogout: Bool = false
    
    func performLogin() {
        headerView.segmentView.selectIdx = 0
        headerView.segmentView.update()
        copySegmentView.selectIdx = 0
        copySegmentView.update()
        handleTag(0)
        tableView.mj_header.beginRefreshing()
        tableView.contentOffset = CGPoint.zero
    }
    
    func performLogout() {
        if popToRootIfLogout {
            _ = navigationController?.popToRootViewController(animated: true)
        }
        headerView.segmentView.selectIdx = 0
        headerView.segmentView.update()
        copySegmentView.selectIdx = 0
        copySegmentView.update()
        handleTag(0)
        tableView.contentOffset = CGPoint.zero
    }
    
    var item: IndexViewItem = IndexViewItem()
    
    func checkOrLoadSegData(_ done: (() -> ())? = nil) {
        tableView.reloadData()
        switch item.newsTag {
        case .news:
            if !item.newsNeedsReload { return }
            item.newsNeedsReload = false
            
            item.newsLoadingStatus = .loading
            
            var user: User? = nil
            if Account.sharedOne.isLogin {
                user = Account.sharedOne.user
            }
            NewsManager.shareInstance.getNews(nil, user: user, industry: nil, dateForPaging: nil, rows: 20, channel: "-1", cached: true, success: { [weak self] (code, msg, news) in
                done?()
                if code == 0 || code == 1001 {
                    if let s = self {
                        let news = news!
                        if news.count == 0 {
                            s.item.newsLoadingStatus = .doneEmpty
                        } else {
                            s.item.newsLoadingStatus = .done
                        }
                        s.item.news = news
                        s.tableView.reloadData()
                    }
                    
                    if msg == kCacheMessage {
                        QXTiper.showFailed(kWebErrMsg, inView: self?.view, cover: true)
                    } else if msg == kCacheBeforeMessage {
                    } else {
                        TipView.oneForIndex.showMsg("成功为您推荐新闻")
                    }
                    
                } else {
                    self?.item.newsLoadingStatus = .doneErr
                    self?.tableView.reloadData()
                }
                }, failed: { [weak self] (error) in
                    done?()
                    self?.item.newsLoadingStatus = .doneErr
                    self?.tableView.reloadData()
            })
            
        case .reports:
            if !item.reportsNeedsReload { return }
            item.reportsNeedsReload = false
            
            item.reportsLoadingStatus = .loading
            NewsManager.shareInstance.getReports(nil, rows: 20, cached: true, success: { [weak self] (code, msg, news) in
                if code == 0 || code == 1001 {
                    done?()
                    if let s = self {
                        let news = news!
                        if news.count == 0 {
                            s.item.reportsLoadingStatus = .doneEmpty
                        } else {
                            s.item.reportsLoadingStatus = .done
                        }
                        s.item.reports = news
                        s.tableView.reloadData()
                    }
                    
                    if msg == kCacheMessage {
                        QXTiper.showFailed(kWebErrMsg, inView: self?.view, cover: true)
                    } else if msg == kCacheBeforeMessage {
                    } else {
                        TipView.oneForIndex.showMsg("成功为您推荐报告")
                    }
                    
                } else {
                    self?.item.reportsLoadingStatus = .doneErr
                    self?.tableView.reloadData()
                }
                }, failed: { [weak self] (error) in
                    done?()
                    self?.item.reportsLoadingStatus = .doneErr
                    self?.tableView.reloadData()
            })
            
        case .events:

            if !item.eventsNeedsReload { return }
            item.eventsNeedsReload = false
            
            item.eventsLoadingStatus = .loading
            var industryId:[String] = [String]()
            if Account.sharedOne.isLogin {
                if let belongId = Account.sharedOne.user.industry?.id {
                   industryId.append(belongId)
                }
                for attentionIndustry in Account.sharedOne.user.industries {
                    if let attentionId = attentionIndustry.id {
                        industryId.append(attentionId)
                    }
                }
            }
            DataListManager.shareInstance.getInvestList(true, keyword: "", start: 0, rows: 20, ronuds: [String](), locations: [String](), industryIds: industryId, startDate: "", endDate: "", minAmount: "-1", maxAmount: "-1", cached: true, success: { [weak self] (code, message, data, totalCount) in
                if code == 0 || code == 1001 {
                    done?()
                    let viewModels: [FinacingViewModel]
                    if let data = data {
                        viewModels = data
                    } else {
                        viewModels = [FinacingViewModel]()
                    }
                    if viewModels.count == 0 {
                        self?.item.eventsLoadingStatus = .doneEmpty
                    } else {
                        self?.item.eventsLoadingStatus = .done
                    }
                    self?.item.events = viewModels
                    self?.tableView.reloadData()
                    
                    if message == kCacheMessage {
                        QXTiper.showFailed(kWebErrMsg, inView: self?.view, cover: true)
                    } else if message == kCacheBeforeMessage {
                    } else {
                        TipView.oneForIndex.showMsg("成功为您推荐事件")
                    }
                    
                } else {
                    self?.item.eventsLoadingStatus = .doneErr
                    self?.tableView.reloadData()
                }
            }) { [weak self] (error) in
                done?()
                self?.item.eventsLoadingStatus = .doneErr
                self?.tableView.reloadData()
            }
            
       }
    }
    
    lazy var searchBar: SearchView = {
        let one = SearchView()
        one.isUserInteractionEnabled = false
        return one
    }()
    lazy var searchBarCoverBtn: UIButton = {
        let one = UIButton()
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            if Account.sharedOne.isLogin {
                let vc = MainSearchViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.popToRootIfLogout = true
            } else {
                self.push2ToLoginVc(comeFromVc: self)
            }
            })
        return one
    }()
    
    lazy var headerView: IndexViewHeaderView = {
        let one = IndexViewHeaderView()
        one.frame = CGRect(x: 0, y: 0, width: 0, height: one.viewHeight)
        one.bannerView.respondSelect = { [unowned self] banner in
            if let news = banner.checkOrMakeNews() {
                let vc = NewsDetailViewController()
                vc.news = news
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = CommonWebViewController()
                vc.url = banner.url
                vc.title = "公告详情"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        one.subBannerView.respondSelect = { [unowned self] banner in
            if let news = banner.checkOrMakeNews() {
                let vc = NewsDetailViewController()
                vc.news = news
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = CommonWebViewController()
                vc.url = banner.url
                vc.title = "公告详情"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        one.respondColum = { [unowned self] item in
            if item.name == "会议" {
                let vc = MeetingMainViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if item.name == "榜单" {
                let vc = RankListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if item.name == "融资" {
                self.checkOrJumpToDataVC(0)
            }
            else if item.name == "并购" {
                self.checkOrJumpToDataVC(1)
            }
            else if item.name == "退出" {
                self.checkOrJumpToDataVC(2)
            }
            else if item.name == "机构" {
                self.checkOrJumpToDataVC(3)
            }
            else if item.name == "企业" {
                self.checkOrJumpToDataVC(4)
            }
            else if item.name == "人物" {
                self.checkOrJumpToDataVC(5)
            }
        }
        one.segmentView.respondSelect = { [unowned self] idx in
            self.handleTag(idx)
        }
        one.respondEvents = { [unowned self] in
            let vc = NewsEventsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    /// 这个是下面分段的副本，用于在上端保持
    lazy var copySegmentView: SegmentControl = {
        let one = SegmentControl(titles: "推荐新闻", "研究报告", "推荐事件")
        one.isHidden = true
        one.respondSelect = { [unowned self] idx in
            self.handleTag(idx)
        }
        return one
    }()
    
    lazy var seeMoreView: IndexViewSeeMoreFooterView = {
        let one = IndexViewSeeMoreFooterView()
        one.hide()
        return one
    }()
    
    /**
     跳转到数据页
     
     - author: zerlinda
     - date: 16-09-28 11:09:42
     
     - parameter index: 数据页选中页面
     */
    func checkOrJumpToDataVC(_ index:Int){
        
        if Account.sharedOne.isLogin {
            self.tabBarController?.selectedIndex = 2
            DataManager.shareInstance.dataVC.selectIndex = index
        } else {
            let vc = ToLoginViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func handleTag(_ tag: Int) {
        if tag == 2 && Account.sharedOne.isLogin == false {
            if self.item.newsTag == .news {
                self.headerView.segmentView.selectIdx = 0
                self.copySegmentView.selectIdx = 0
            } else if self.item.newsTag == .reports {
                self.headerView.segmentView.selectIdx = 1
                self.copySegmentView.selectIdx = 1
            }
            self.headerView.segmentView.update()
            self.copySegmentView.update()
            self.checkOrLoadSegData()
            self.push2ToLoginVc(comeFromVc: self)
        } else {
            self.item.newsTag = IndexNewsTag(rawValue: tag)!
            self.checkOrLoadSegData()
            self.headerView.segmentView.selectIdx = tag
            self.copySegmentView.selectIdx = tag
            self.headerView.segmentView.update()
            self.copySegmentView.update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTopCons.constant = -20
        
        //tableViewBottomCons.constant = -49
        tableView.tableHeaderView = headerView
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.register(FinancingCell.self, forCellReuseIdentifier: "FinancingCell")

        setupCustomNav()
        customNavView.changeAlpha(navAlpha)
        searchBar.transAlpha = navInitAlpha
        customNavView.addSubview(searchBar)
        customNavView.addSubview(searchBarCoverBtn)
        searchBar.IN(customNavView).LEFT(12.5).RIGHT(12.5).TOP(20 + 7).BOTTOM(7).MAKE()
        searchBarCoverBtn.IN(searchBar).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        setupMJHeader()
        statusBarStyle = .lightContent
        
        tableView.tableFooterView = seeMoreView
        
        view.addSubview(copySegmentView)
        copySegmentView.IN(view).LEFT.RIGHT.TOP(64).HEIGHT(50).MAKE()
        
        TipView.oneForIndex.inView = self.view
        TipView.oneForIndex.frame = CGRect(x: 0, y: view.bounds.height - 20 - 49, width: view.bounds.width, height: 20)
        
    }
    
    func setupMJHeader() {
        tableView.mj_header = IndexViewMJHeader(refreshingBlock: { [weak self] in
            self?.handleRefresh()
        })
    }
    
    func handleRefresh() {
        item.newsNeedsReload = true
        item.reportsNeedsReload = true
        item.eventsNeedsReload = true
        item.topBannerLoadSuccess = false
        item.middleBannerLoadSuccess = false
        item.newsLoadSuccess = false
        checkOrRequestHeaders()
        checkOrLoadSegData { [unowned self] in
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        checkOrRequestHeaders()
        hideNav()
        popToRootIfLogout = false
    }
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        checkOrLoadSegData()
    }
    
    func checkOrRequestHeaders() {
        if item.topBannerLoadSuccess == false {
            NewsManager.shareInstance.getBanners(.IndexTop, cached: true, success: { [weak self] (code, msg, banners) in
                if code == 0 {
                    if let s = self {
                        s.item.topBannerLoadSuccess = true
                        if let banners = banners {
                            if banners.count > 0 {
                                s.headerView.bannerView.banners = banners
                            }
                        }
                    }
                }
            }) { (error) in
            }
        }
        if item.middleBannerLoadSuccess == false {
            NewsManager.shareInstance.getBanners(.IndexMiddle, cached: true, success: { [weak self] (code, msg, banners) in
                if code == 0 {
                    self?.item.middleBannerLoadSuccess = true
                    if let banners = banners {
                        self?.headerView.subBannerView.banners = banners
                    }
                }
            }) { (error) in
            }
        }
        if item.newsLoadSuccess == false {
            NewsManager.shareInstance.getEvents(nil, dateForPaging: nil, rows: 20, cached: true, success: { [weak self] (code, msg, news) in
                if code == 0 {
                    self?.item.newsLoadSuccess = true
                    if let news = news {
                        self?.headerView.newsView.news = news
                    }
                }
                }, failed: { (error) in
            })
        }
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    let navInitAlpha: CGFloat = 0.1
    var navAlpha: CGFloat = 0.1
    var isSeeMoreViewShow: Bool = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + 20
        let totalHeight = headerView.bannerView.viewHeight - customNavView.viewHeight
        let totalAlpha = 1 - navInitAlpha
        if offsetY > 0 {
            let _alpha = navInitAlpha + (offsetY / totalHeight) * totalAlpha
            navAlpha = min(_alpha, 1)
        } else {
            if offsetY > -customNavView.viewHeight {
                navAlpha = navInitAlpha - (abs(offsetY) / customNavView.viewHeight) * navInitAlpha
            } else {
                navAlpha = 0
            }
            let r = 1 - min(abs(offsetY) / 64, 1)
            searchBar.alpha = r
        }
        // 当 searchView 的背景接近白色时，状态栏的颜色变黑色
//        if navAlpha > 0.9 {
//            statusBarStyle = .default
//        } else {
//            statusBarStyle = .lightContent
//        }
        statusBarStyle = .default
        
        setNeedsStatusBarAppearanceUpdate()
        customNavView.changeAlpha(navAlpha)
        searchBar.transAlpha = navAlpha
        
//        if !isSeeMoreViewShow {
//            let rect = tableView.convert(seeMoreView.frame, to: view)
//            if rect.minY + 10 + 49 + 55 < kScreenH {
//                tableView.tableFooterView = nil
//                seeMoreView.show()
//                tableView.tableFooterView = seeMoreView
//                isSeeMoreViewShow = true
//            }
//        }
        
        copySegmentView.isHidden = !(offsetY >= headerView.viewHeight - 64 - 50)
        
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if item.currentLoadStatus == .done {
            switch item.newsTag {
            case .news:
                return item.news.count
            case .reports:
                return item.reports.count
            case .events:
                return item.events.count
            }
        } else {
            return 1
        }
    }
    
    lazy var loadingCell: LoadingCell = LoadingCell()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if item.currentLoadStatus == .done {
            switch item.newsTag {
            case .news:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
                cell.news = item.news[indexPath.row]
                cell.showBottomLine = !(indexPath.row == item.news.count - 1)
                return cell
            case .reports:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
                cell.news = item.reports[indexPath.row]
                cell.showBottomLine = !(indexPath.row == item.reports.count - 1)
                return cell
            case .events:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FinancingCell") as! FinancingCell
                cell.cellWidth = self.view.bounds.width
                let viewMoedl = item.events[indexPath.row]
                cell.viewModel = viewMoedl
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.cellLine.isHidden = true
                cell.showBottomLine = !(indexPath.row == item.events.count - 1)
                return cell
            }
        } else {
            if item.currentLoadStatus == .doneEmpty {
                loadingCell.showEmpty(item.currentEmptyMsg)
            } else if item.currentLoadStatus == .doneErr {
                loadingCell.showFailed(self.faliedMsg)
            } else {
                loadingCell.showLoading()
            }
            loadingCell.respondReload = { [unowned self] in
                switch self.item.newsTag {
                case .news:
                    self.item.newsNeedsReload = true
                case .reports:
                    self.item.reportsNeedsReload = true
                case .events:
                    self.item.eventsNeedsReload = true
                }
                self.checkOrLoadSegData()
            }
            return loadingCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if item.currentLoadStatus == .done {
            switch item.newsTag {
            case .news, .reports:
                return NewsCell.cellHeight()
            default:
                let viewModel = item.events[indexPath.row]
                return viewModel.cellHeight! < 10 ? 100 : viewModel.cellHeight!
            }
        } else {
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if item.currentLoadStatus == .done {
            return 0.0001
        } else {
            return kScreenH - 49 - 64 - 44 - 200
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if item.currentLoadStatus == .done {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if item.currentLoadStatus == .done {
            switch item.newsTag {
            case .news:
                let news = self.item.news[indexPath.row]
                let vc = NewsDetailViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.news = news
                self.navigationController?.pushViewController(vc, animated: true)
            case .reports:
                let news = self.item.reports[indexPath.row]
                let vc = NewsDetailViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.news = news
                self.navigationController?.pushViewController(vc, animated: true)
            case .events:
                let vc = FinancingDetailViewController()
                vc.viewModel = self.item.events[indexPath.row]
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                popToRootIfLogout = true
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
                tableView?.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
}
