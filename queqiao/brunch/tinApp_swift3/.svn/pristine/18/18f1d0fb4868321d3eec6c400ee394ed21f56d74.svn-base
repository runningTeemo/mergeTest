//
//  MyFriendsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MyCircleViewController: RootTableViewController {
    
    var circles: [Circle] = [Circle]()
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        
        ArticleManager.shareInstance.getCircles(me, success: { [weak self] (code, msg, circles) in
            if code == 0 {
                let circles = circles!
                self?.circles = circles
                self?.tableView.reloadData()
                if circles.count == 0 {
                    done(.empty)
                } else {
                    done(.noMore)
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
    
    lazy var attentionsItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconNewsOpen", responder: { [unowned self] in
            let vc = SetIndustryViewController()
            vc.vcBefore = self
            vc.isAttentionMode = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的行业"
        setupNavBackBlackButton(nil)
        
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        setupRefreshHeader()
        tableView.register(MyCircleCell.self, forCellReuseIdentifier: "MyCircleCell")
        
        setupRightNavItems(items: attentionsItem)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCircleCell") as! MyCircleCell
        cell.circle = circles[indexPath.row]
        cell.showBottomLine = !(indexPath.row == circles.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyCircleCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let circle = circles[indexPath.row]
        let vc = IndustryArticleViewController()
        vc.industry = circle.industry
        vc.hidesBottomBarWhenPushed = true
        vc.vcBefore = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}


class MyCircleCell: RootTableViewCell {
    
    var circle: Circle! {
        didSet {
            icon.fullPath = circle.industry.icon
            
            if let name = circle.industry.name {
                nameLabel.text = name
            } else {
                nameLabel.text = nil
            }
            var userCount = "N/A"
            if let c = circle.userCount {
                userCount = "\(c)"
            }
            var articleCount = "N/A"
            if let c = circle.articleCount {
                articleCount = "\(c)"
            }
            contentLabel.text = "成员：\(userCount)     动态：\(articleCount)"
        }
    }
    
    override class func cellHeight() -> CGFloat {
        return 75
    }

    lazy var icon: RoundIconView = {
        let one = RoundIconView()
        one.image = nil
        return one
    }()
    
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.font = kFontSubTitle
        one.textColor = kClrTitle
        return one
    }()
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.font = kFontSmall
        one.textColor = kClrTip
        return one
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        
        icon.IN(contentView).LEFT(12.5).CENTER.SIZE(45, 45).MAKE()
        nameLabel.RIGHT(icon).OFFSET(10).TOP.MAKE()
        nameLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        contentLabel.RIGHT(icon).OFFSET(10).BOTTOM.MAKE()
        contentLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
