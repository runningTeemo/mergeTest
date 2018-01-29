//
//  NewsHotViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsHotViewController: NewsContentViewController {
    
    var news: [News] = [News]()
    var lastDate: String?
    var start: Int = 0
    
    lazy var bannerView: NewsHotBannerView = {
        let one = NewsHotBannerView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: one.viewHeight)
        one.respondSelect = { [unowned self] banner in
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
        return one
    }()
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        NewsManager.shareInstance.getAdvAndNews(nil, industry: NewsFilter.sharedOne.industry, dateForPaging: lastDate, start: start, rows: 20, channel: item.channel, success: { [weak self] (code, msg, news) in
            if code == 0 || code == 1001 {
                if let s = self {
                    let news = news!
                    if s.start == 0 {
                        s.news = news
                    } else {
                        s.news += news
                    }
                    var lastNews: News?
                    for news in s.news {
                        if news.type == .news {
                            lastNews = news
                        }
                    }
                    s.lastDate = lastNews?.dateForPaging
                    s.start += 20
                    s.tableView.reloadData()
                    done(s.checkOutLoadDataType(allModels: s.news, newModels: news))
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
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        resetFooter()
        lastDate = nil
        start = 0
        loadMore(done)
        bannerLoadSuccess = false
        checkOrRequestBanner()
    }

    fileprivate var bannerLoadSuccess: Bool = false
    func checkOrRequestBanner() {
        if bannerLoadSuccess == false {
            NewsManager.shareInstance.getBanners(.FocusTop, success: { [weak self] (code, msg, banners) in
                if code == 0 {
                    self?.bannerLoadSuccess = true
                    if let banners = banners {
                        if banners.count > 0 {
                            self?.bannerView.banners = banners
                        } else {
                            self?.bannerView.banners = [Banner()]
                        }
                    }
                }
            }) { (error) in
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkOrRequestBanner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.tableHeaderView = bannerView
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsChannelViewController.filteNotification(_:)), name: NSNotification.Name(rawValue: kNewsFilteNotification), object: nil)
    }
    func filteNotification(_ notice: Notification) {
        if isShowingNow {
            tableView.contentOffset = CGPoint.zero
            news.removeAll()
            tableView.reloadData()
            lastDate = nil
            loadData()
        } else {
            clearFirstInStatus()
        }
    }
    override func clearFirstInStatus() {
        super.clearFirstInStatus()
        news.removeAll()
        lastDate = nil
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        cell.news = news[indexPath.row]
        cell.showBottomLine = !(indexPath.row == news.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsCell.cellHeightForModel(news[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let news = self.news[indexPath.row]
        func toWebView() {
            let vc = CommonWebViewController()
            vc.url = news.url
            vc.title = "广告详情"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        func toNewsDetail() {
            let vc = NewsDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.news = news
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if news.style == .Adv {
            if let type = news.advType {
                if type == .news || type == .report {
                    toNewsDetail()
                } else {
                    toWebView()
                }
            } else {
                toWebView()
            }
        } else {
            toNewsDetail()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}

