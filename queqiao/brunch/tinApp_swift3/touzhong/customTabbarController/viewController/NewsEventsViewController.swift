//
//  NewsEventsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsEventsViewController: RootTableViewController {
    
    var items: [NewsEventItem] = [NewsEventItem]()
    var lastDate: String?
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        NewsManager.shareInstance.getEvents(nil, dateForPaging: lastDate, rows: 20, success: { [weak self] (code, msg, news) in
            if code == 0 {
                print("获取数据成功")
                if let s = self {
                    let news = news!
                    var items = [NewsEventItem]()
                    for n in news {
                        let item = NewsEventItem(news: n)
                        items.append(item)
                    }
                    if s.lastDate == nil {
                        if news.count == 0 {
                            done(.empty)
                        } else {
                            done(.thereIsMore)
                        }
                        s.items = items
                    } else {
                        if news.count == 0 {
                            done(.noMore)
                        } else {
                            done(.thereIsMore)
                        }
                        s.items += items
                    }
                    s.lastDate = news.last?.dateForPaging
                    NewsEventItem.initForShow(s.items)
                    s.tableView.reloadData()
                }
                print("处理数据成功")
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
        loadMore(done)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "投融动态"
        
        setupNavBackBlackButton(nil)
        tableView.register(NewsEventCell.self, forCellReuseIdentifier: "NewsEventCell")
        
        setupLoadingView()
        setupRefreshHeader()
        setupRefreshFooter()
        loadDataOnFirstWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsEventCell") as! NewsEventCell
        cell.item = items[indexPath.row]
        cell.showBottomLine = !(indexPath.row == items.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsEventCell.cellHeight()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let news = self.items[indexPath.row].news
        let vc = NewsDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.news = news
        self.navigationController?.pushViewController(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}

class NewsEventItem {
    var news: News
    init(news: News) {
        self.news = news
        if let date = news.publishDate {
            let d1 = DateTool.getSegDate(date)!
            let d2 = DateTool.getSegDate(Date())!
            if d1.year == d2.year && d1.month == d2.month && d1.day == d2.day {
                isThisDay = true
            } else {
                isThisDay = false
            }
        } else {
            isThisDay = false
        }
    }
    
    let isThisDay: Bool
    var isFristOfThisDay: Bool = true
    var isFirst: Bool = false
    var isLast: Bool = false
    class func initForShow(_ items: [NewsEventItem]) {
        var day: Int = 0
        for item in items {
            if day == 0 {
                if let d = DateTool.getSegDate(item.news.publishDate) {
                    day = d.day
                }
                item.isFristOfThisDay = true
            } else {
                if let d = DateTool.getSegDate(item.news.publishDate) {
                    if d.day == day {
                        item.isFristOfThisDay = false
                    } else {
                        item.isFristOfThisDay = true
                        day = d.day
                    }
                
                }
            }
        }
        items.first?.isFirst = true
        items.last?.isLast = true
    }
}

class NewsEventCell: RootTableViewCell {
    
    override class func cellHeight() -> CGFloat {
        return 100
    }
    
    var item: NewsEventItem! {
        didSet {
            if let date = item.news.publishDate {
                let d = DateTool.getSegDate(date)!
                dateLabel.text = String(format: "%d-%d", d.month, d.day)
            }
            if item.isThisDay {
                dateLabel.backgroundColor = kClrOrange
            } else {
                dateLabel.backgroundColor = kClrBlue
            }
            lineTop.isHidden = item.isFirst
            //lineBottom.hidden = item.isLast
            dateLabel.isHidden = !item.isFristOfThisDay
            
            titleLabel.text = item.news.title
            var keywords = ""
            for k in item.news.keyWords {
                keywords += SafeUnwarp(k.content, holderForNull: "") + "  "
            }
            keywordsLabel.text = keywords
        }
    }
    class func cellHeightForModel(_ model: RankListItem) -> CGFloat {
        if model.isFristOfThisYear {
            if model.isFirst {
                return self.cellHeight() + 15
            } else {
                return self.cellHeight() + 30
            }
        }
        return self.cellHeight()
    }

    lazy var dateLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 15)
        one.textColor = kClrWhite
        one.textAlignment = .center
        one.clipsToBounds = true
        return one
    }()
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 15)
        one.textColor = kClrDarkGray
        one.numberOfLines = 2
        return one
    }()
    lazy var keywordsLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 12)
        one.textColor = kClrGray
        return one
    }()
    lazy var lineTop: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        return one
    }()
    lazy var lineBottom: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lineTop)
        contentView.addSubview(lineBottom)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(keywordsLabel)
        lineTop.CENTER_X.EQUAL(dateLabel).MAKE()
        lineTop.TOP.EQUAL(contentView).MAKE()
        lineTop.BOTTOM.EQUAL(dateLabel).CENTER_Y.MAKE()
        lineTop.WIDTH.EQUAL(1).MAKE()
        
        lineBottom.CENTER_X.EQUAL(dateLabel).MAKE()
        lineBottom.BOTTOM.EQUAL(contentView).MAKE()
        lineBottom.TOP.EQUAL(dateLabel).CENTER_Y.MAKE()
        lineBottom.WIDTH.EQUAL(1).MAKE()
        
        dateLabel.IN(contentView).LEFT(23).TOP(20).SIZE(44, 44).MAKE()
        dateLabel.layer.cornerRadius = 22
        
        titleLabel.RIGHT(dateLabel).TOP.OFFSET(20).MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-20).MAKE()
        
        keywordsLabel.LEFT.EQUAL(dateLabel).RIGHT.OFFSET(20).MAKE()
        keywordsLabel.BOTTOM.EQUAL(contentView).OFFSET(-20).MAKE()
        keywordsLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-20).MAKE()
        
        bottomLineLeftCons?.constant = 83
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

