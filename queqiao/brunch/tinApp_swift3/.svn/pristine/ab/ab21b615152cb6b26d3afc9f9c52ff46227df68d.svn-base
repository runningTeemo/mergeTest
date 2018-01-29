//
//  CircleDetailViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CircleDetailViewController: RootTableViewController {
    
    var circle: Circle!
    
    var items: [IndustryArticleItem] = [IndustryArticleItem]()
    
    lazy var writeItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconCirclePublish", pos: .right, responder: { [unowned self] in
            let vc = WriteArticleViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            })
        return one
    }()
    
    lazy var messageItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconMessage", pos: .left, responder: { [unowned self] in
            let vc = MessageMainViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            })
        return one
        
    }()
    
    lazy var headView: CircleDetailHeadView = {
        let one = CircleDetailHeadView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: one.viewHeight)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "圈子"
        navigationItem.leftBarButtonItem = messageItem
        navigationItem.rightBarButtonItem = writeItem
        
        tableView.register(IndustryArticleCell.self, forCellReuseIdentifier: "IndustryArticleCell")
        emptyMsg = "没有圈内消息"
        
        setupLoadingView()
        setupRefreshHeader()
        setupRefreshFooter()
        
        loadDataOnFirstWillAppear = true
        
        tableView.tableHeaderView = headView
        tableViewTopCons.constant = -headView.appendHeight
        
        setupCustomNav()
        customNavView.backBlackBtn.isHidden = true
        customNavView.setupBackButton()
        customNavView.respondBack = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            
            let a1 = Article()
            a1.user.id = "x"
            a1.user.realName = "小明"
            let ind = Industry()
            ind.name = "金融"
            a1.industry = ind
            a1.content = "这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，这是一句话，"
            a1.pictures = [Picture(), Picture(), Picture(), Picture()]
            
            let agree = Agree()
            agree.user.id = "1"
            agree.user.realName = "A"
            
            let comment = Comment()
            comment.user.id = "2"
            comment.user.realName = "2"
            comment.content = "我评论了你"
            comment.replyUser = a1.user
            
            a1.agrees = [agree, agree, agree]
            a1.comments = [comment, comment, comment]
            
            a1.createDate = Date()
            let i1 = IndustryArticleItem(model: a1)
            let i2 = IndustryArticleItem(model: a1)
            let i3 = IndustryArticleItem(model: a1)
            self.items = [
                i1, i2, i3
            ]
            self.tableView.reloadData()
            done(.noMore)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndustryArticleCell") as! IndustryArticleCell
        cell.item = items[(indexPath as NSIndexPath).row]
        cell.respondFold = { [unowned self] item in
            self.tableView.reloadData()
        }
        cell.respondUser = { u in
            print(u.realName)
            print(u.id)
        }
        cell.respondItem = { [unowned self] item in
            let vc = ArticleDetailViewControler()
            vc.orgienArticle = item.model
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.showBottomLine = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items[(indexPath as NSIndexPath).row].cellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
            customNavView.title = "圈子详情"
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
