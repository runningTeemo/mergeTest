//
//  NewsReportViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/9.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsReportViewController: NewsContentViewController {
    
    var news: [News] = [News]()
    var lastDate: String?
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        NewsManager.shareInstance.getReports(lastDate, rows: 20, success: { [weak self] (code, msg, news) in
            if code == 0 || code == 1001 {
                if let s = self {
                    let news = news!
                    if s.lastDate == nil {
                        s.news = news
                    } else {
                        s.news += news
                    }
                    s.lastDate = news.last?.dateForPaging
                    done(s.checkOutLoadDataType(allModels: s.news, newModels: news))
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
    
    override func loadData(_ done: @escaping ((_ dataType: LoadDataType) -> ())) {
        resetFooter()
        lastDate = nil
        loadMore(done)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
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
        let vc = NewsDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.news = news
        self.navigationController?.pushViewController(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}
