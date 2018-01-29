//
//  ArticleFilteOrderViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

let kArticleFilteOrderNames = ["最新发布", "关注最多", "人气最高"]

class ArticleFilteOrderViewController: RootTableViewController {
    
    func reset() {
        currentIdx = 0
        tableView.reloadData()
        updateFilterModel()
    }
    
    var filterModel: ArticleFilter!
    
    class func viewHeight() -> CGFloat {
        return CGFloat(ArticleFilteOrderViewController.titles.count) * CGFloat(ArticleFilteOrderCell.cellHeight())
    }
    
    var respondTag: ((_ tag: Int) -> ())?
    
    static let titles: [String] = kArticleFilteOrderNames
    var currentIdx: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ArticleFilteOrderCell.self, forCellReuseIdentifier: "ArticleFilteOrderCell")
        tableView.bounces = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticleFilteOrderViewController.titles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleFilteOrderCell") as! ArticleFilteOrderCell
        cell.titleLabel.text = ArticleFilteOrderViewController.titles[indexPath.row]
        if indexPath.row == currentIdx {
            cell.titleLabel.textColor = kClrOrange
            cell.iconView.isHidden = false
        } else {
            cell.titleLabel.textColor = kClrDeepGray
            cell.iconView.isHidden = true
        }
        cell.showBottomLine = !(indexPath.row == ArticleFilteOrderViewController.titles.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ArticleFilteOrderCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIdx = indexPath.row
        tableView.reloadData()
        
        updateFilterModel()
        
        respondTag?(indexPath.row)
        
    }
    
    func updateFilterModel() {
        if currentIdx == 0 {
            filterModel.orderType = .new
        } else if currentIdx == 1 {
            filterModel.orderType = .attention
        } else if currentIdx == 2 {
            filterModel.orderType = .hot
        }
    }
}


class ArticleFilteOrderCell: RootTableViewCell {
    
    override class func cellHeight() -> CGFloat {
        return 44
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = UIFont.systemFont(ofSize: 14)
        return one
    }()
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconHySortB")
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconView)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        iconView.RIGHT(titleLabel).OFFSET(20).CENTER.SIZE(12, 8).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
