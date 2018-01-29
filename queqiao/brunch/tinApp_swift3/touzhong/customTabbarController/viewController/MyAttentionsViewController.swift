//
//  MyAttentionsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/20.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyAttentionsViewController: RootTableViewController {
    
    var articles: [Article] = [Article]()
    var lastDate: String?
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        resetFooter()
        lastDate = nil
        loadMore(done)
    }
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        
        ArticleManager.shareInstance.getAttentionArticles(me, dateForPaging: self.lastDate, success: { [weak self] code, msg, articles in
        
            if code == 0 {
                if let s = self {
                    let articles = articles!
                    if s.lastDate == nil {
                        s.articles = articles
                    } else {
                        s.articles += articles
                    }
                    s.lastDate = s.articles.last?.dateForPaging
                    done(s.checkOutLoadDataType(allModels: s.articles, newModels:articles))
                    s.tableView.reloadData()
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
            self?.autoCheckHasData(models: self?.articles)
        }, failed: { [weak self] error in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
            self?.autoCheckHasData(models: self?.articles)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关注项目"
        setupNavBackBlackButton(nil)
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        setupRefreshFooter()
        tableView.register(MyAttentionCell.self, forCellReuseIdentifier: "MyAttentionCell")
        
        emptyMsg = "暂无关注"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAttentionCell") as! MyAttentionCell
        cell.article = articles[indexPath.row]
        cell.showBottomLine = !(indexPath.row == articles.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyCollectionCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let article = articles[indexPath.row]
        
        if ArticleDetailHelper.canView(article: article) {
            let vc = ArticleDetailViewControler()
            vc.orgienArticle = article
            vc.vcBefore = self
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            QXTiper.showWarning("您无权限查看", inView: self.view, cover: true)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .default, title: "删除") { [weak self] (action, indexPath) in
//            if let s = self {
//                let collection = s.collections[indexPath.row]
//                s.handleDelete(collection: collection)
//            }
//            
//        }
//        return [delete]
//    }
    
    
//    func handleDelete(collection: MyCollection) {
//        
//        if collection.type == nil {
//            QXTiper.showWarning("数据错误，无法执行操作", inView: view, cover: true)
//            return
//        }
//        
//        let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
//        let me = Account.sharedOne.user
//        
//        MyselfManager.shareInstance.deleteCollect(user: me, collection: collection, success: { [weak self] (code, msg, ret) in
//            QXTiper.hideWaiting(wait)
//            if code == 0 {
//                QXTiper.showSuccess("已删除", inView: self?.view, cover: true)
//                self?.performRefresh()
//            } else {
//                QXTiper.showWarning(msg, inView: self?.view, cover: true)
//            }
//        }) { [weak self] (error) in
//            QXTiper.hideWaiting(wait)
//            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
//        }
//        
//    }

    
}

class MyAttentionCell: RootTableViewCell {
    
    var article: Article! {
        didSet {
            if let date = DateTool.getSegDate(article.createDate) {
                dayLabel.text = String(format: "%02d", date.day)
                monthLabel.text = "\(date.month)月"
            } else {
                dayLabel.text = ""
                monthLabel.text = ""
            }
            if let attachments = article.attachments as? ArticleProjectAttachments {
                titleLabel.text = attachments.name
                
                let dealType = TinSearch(code: attachments.dealType, inKeys: kProjectDealTypeKeys)?.name
                let currentRound: String?
                if dealType == "并购收购" {
                    currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectMergeTypeKeys)?.name
                } else {
                    currentRound = TinSearch(code: attachments.currentRound, inKeys: kProjectInvestTypeKeys)?.name
                }
                let currency = TinSearch(code: attachments.currency, inKeys: kCurrencyTypeKeys)?.name
                let money: String?
                let n = StaticCellTools.doubleToNatureMoney(n: SafeUnwarp(attachments.currencyAmount, holderForNull: 0))
                if currency == "人民币" {
                    money = "¥" + n
                } else if currency == "美元" {
                    money = "$" + n
                } else if currency == "欧元" {
                    money = "€" + n
                } else {
                    money = n
                }
                let investStockRatio = SafeUnwarp(attachments.investStockRatio, holderForNull: 0)
                let location = attachments.location
                
                breifLabel.text = SafeUnwarp(currentRound, holderForNull: "") + "  " + "\(SafeUnwarp(money, holderForNull: "")) / \(investStockRatio)%  " + SafeUnwarp(location, holderForNull: "")

                if ArticleDetailHelper.canView(article: article) {
                    dateView.backgroundColor = kClrOrange
                    monthLabel.textColor = UIColor.white
                    dayLabel.textColor = UIColor.white
                    rightArrow.isHidden = false
                } else {
                    dateView.backgroundColor = HEX("#f2f2f2")
                    monthLabel.textColor = kClrGray
                    dayLabel.textColor = kClrDeepGray
                    rightArrow.isHidden = true
                }
            }
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return 80
    }
    
    lazy var dateView: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#f2f2f2")
        one.addSubview(self.dayLabel)
        one.addSubview(self.monthLabel)
        self.dayLabel.IN(one).TOP(6).CENTER.MAKE()
        self.monthLabel.IN(one).BOTTOM(6).CENTER.MAKE()
        return one
    }()
    lazy var dayLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 18)
        one.textColor = kClrDeepGray
        return one
    }()
    lazy var monthLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 10)
        one.textColor = kClrGray
        return one
    }()
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.font = kFontSubTitle
        one.textColor = kClrTitle
        return one
    }()
    lazy var breifLabel: UILabel = {
        let one = UILabel()
        one.font = kFontSmall
        one.textColor = kClrTip
        return one
    }()
    
    lazy var typeLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.white
        one.font = UIFont.systemFont(ofSize: 13)
        one.textAlignment = .left
        one.layer.cornerRadius = 10
        one.clipsToBounds = true
        return one
    }()
    lazy var clipView: UIView = {
        let one = UIView()
        one.clipsToBounds = true
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(breifLabel)
        
        setupRightArrow()

        dateView.IN(contentView).LEFT(12.5).CENTER.SIZE(45, 45).MAKE()
        
        titleLabel.RIGHT(dateView).OFFSET(10).TOP.MAKE()
        titleLabel.RIGHT.EQUAL(contentView).OFFSET(-rightMargin).MAKE()
        
        breifLabel.RIGHT(dateView).OFFSET(10).BOTTOM.MAKE()
        breifLabel.RIGHT.EQUAL(contentView).OFFSET(-rightMargin).MAKE()
        
        contentView.clipsToBounds = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
