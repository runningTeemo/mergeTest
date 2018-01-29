//
//  MyFriendsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyCollectionViewController: RootTableViewController {
    
    var collections: [MyCollection] = [MyCollection]()
    var lastPage: Int = 1
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        resetFooter()
        lastPage = 1
        loadMore(done)
    }
    
    override func loadMore(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        MyselfManager.shareInstance.getCollects(user: me, type: .news, page: lastPage, success: { [weak self] (code, msg, collections) in
            if code == 0 {
                if let s = self {
                    let collections = collections!
                    if s.lastPage == 1 {
                        s.collections = collections
                    } else {
                        s.collections += collections
                    }
                    s.lastPage += 1
                    done(s.checkOutLoadDataType(allModels: s.collections, newModels:collections))
                    s.tableView.reloadData()
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
            self?.autoCheckHasData(models: self?.collections)
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
            self?.autoCheckHasData(models: self?.collections)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的收藏"
        setupNavBackBlackButton(nil)
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        setupRefreshFooter()
        tableView.register(MyCollectionCell.self, forCellReuseIdentifier: "MyCollectionCell")
        
        emptyMsg = "暂无收藏"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCollectionCell") as! MyCollectionCell
        cell.collection = collections[indexPath.row]
        cell.showBottomLine = !(indexPath.row == collections.count - 1)
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
        
        let collection = collections[indexPath.row]
        
        if let type = collection.type {
            
            switch type {
            case .news:
                if let id = collection.targetId {
                    let vc = NewsDetailViewController()
                    vc.hidesBottomBarWhenPushed = true
                    let news = News(type: .news)
                    news.id = (id as NSString).integerValue
                    news.url = collection.targetUrl
                    vc.news = news
                    do {
                        let title = "【投中网】" + SafeUnwarp(collection.targetContent, holderForNull: "")
                        let imgUrl = SafeUnwarp(collection.targetImage, holderForNull: "")
                        let desc = SafeUnwarp(collection.targetDescri, holderForNull: "")
                        let link: String
                        if let url = collection.targetUrl {
                            link = (url as NSString).replacingOccurrences(of: "viewType=APP", with: "viewType=WEIXIN")
                        } else {
                            link = ""
                        }
                        var dic = [String: Any]()
                        dic.append("title", notNullValue: title)
                        dic.append("imgUrl", notNullValue: imgUrl)
                        dic.append("desc", notNullValue: desc)
                        dic.append("link", notNullValue: link)
                        news.shareInfo = dic
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .report:
                if let id = collection.targetId {
                    let vc = NewsDetailViewController()
                    vc.hidesBottomBarWhenPushed = true
                    let news = News(type: .report)
                    news.id = (id as NSString).integerValue
                    news.url = collection.targetUrl
                    do {
                        let title = "【投中网】" + SafeUnwarp(collection.targetContent, holderForNull: "")
                        let imgUrl = SafeUnwarp(collection.targetImage, holderForNull: "")
                        let desc = SafeUnwarp(collection.targetDescri, holderForNull: "")
                        let link: String
                        if let url = collection.targetUrl {
                            link = (url as NSString).replacingOccurrences(of: "viewType=APP", with: "viewType=WEIXIN")
                        } else {
                            link = ""
                        }
                        var dic = [String: Any]()
                        dic.append("title", notNullValue: title)
                        dic.append("imgUrl", notNullValue: imgUrl)
                        dic.append("desc", notNullValue: desc)
                        dic.append("link", notNullValue: link)
                        news.shareInfo = dic
                    }
                    vc.news = news
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .conference:
                if let id = collection.targetId {
                    let vc = MeetingDetailViewController()
                    vc.hidesBottomBarWhenPushed = true
                    let meeting = Meeting()
                    meeting.id = (id as NSString).integerValue
                    meeting.url = collection.targetUrl
                    vc.meeting = meeting
                    vc.canCollect = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .figure:
                if Account.sharedOne.user.author ==  .isAuthed{
                    let vc = PersonageDetailViewController()
                    vc.id = SafeUnwarp(collection.targetId, holderForNull: "")
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    remindCertification()
                }
            case .institution:
                let vc = InstitutionDetailViewController()
                vc.id = SafeUnwarp(collection.targetId, holderForNull: "")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .enterprise:
                let vc = EnterpriseDetailViewController()
                vc.id = SafeUnwarp(collection.targetId, holderForNull: "")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "删除") { [weak self] (action, indexPath) in
            if let s = self {
                let collection = s.collections[indexPath.row]
                s.handleDelete(collection: collection)
            }
            
        }
        return [delete]
    }
    
    
    func handleDelete(collection: MyCollection) {
        
        if collection.type == nil {
            QXTiper.showWarning("数据错误，无法执行操作", inView: view, cover: true)
            return
        }
        
        let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
        let me = Account.sharedOne.user
        
        MyselfManager.shareInstance.deleteCollect(user: me, collection: collection, success: { [weak self] (code, msg, ret) in
            QXTiper.hideWaiting(wait)
            if code == 0 {
                QXTiper.showSuccess("已删除", inView: self?.view, cover: true)
                self?.performRefresh()
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            QXTiper.hideWaiting(wait)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
}

class MyCollectionCell: RootTableViewCell {
    
    var collection: MyCollection! {
        didSet {
            if let date = DateTool.getSegDate(collection.collectDate) {
                dayLabel.text = String(format: "%02d", date.day)
                monthLabel.text = "\(date.month)月"
            } else {
                dayLabel.text = ""
                monthLabel.text = ""
            }
            titleLabel.text = collection.targetContent
            breifLabel.text = collection.targetDescri
            
            if let type = collection.type {
                switch type {
                case .news:
                    typeLabel.text = "    新闻"
                    typeLabel.backgroundColor = HEX("#3aaaf1")
                case .report:
                    typeLabel.text = "    报告"
                    typeLabel.backgroundColor = HEX("#3aaaf1")
                case .conference:
                    typeLabel.text = "    会议"
                    typeLabel.backgroundColor = HEX("#3aaaf1")
                case .figure:
                    typeLabel.text = "    人物"
                    typeLabel.backgroundColor = HEX("#44c4c3")
                case .institution:
                    typeLabel.text = "    机构"
                    typeLabel.backgroundColor = HEX("#44c4c3")
                case .enterprise:
                    typeLabel.text = "    企业"
                    typeLabel.backgroundColor = HEX("#44c4c3")
                }
            } else {
                typeLabel.text = nil
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
        contentView.addSubview(clipView)
        clipView.addSubview(typeLabel)
        
        dateView.IN(contentView).LEFT(12.5).CENTER.SIZE(45, 45).MAKE()
        
        clipView.IN(contentView).RIGHT.TOP(20).SIZE(50, 20).MAKE()
        typeLabel.IN(contentView).RIGHT(-15).TOP(20).SIZE(65, 20).MAKE()
        
        titleLabel.RIGHT(dateView).OFFSET(10).TOP.MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(typeLabel).LEFT.OFFSET(-10).MAKE()
        
        breifLabel.RIGHT(dateView).OFFSET(10).BOTTOM.MAKE()
        breifLabel.RIGHT.LESS_THAN_OR_EQUAL(typeLabel).LEFT.OFFSET(-10).MAKE()
        
        contentView.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
