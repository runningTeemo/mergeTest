//
//  RankListViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RankListViewController: RootTableViewController {
    
    var items: [RankListItem] = [RankListItem]()
    
    override func loadData(_ done: @escaping LoadingDataDone) {

        RankManager.shareInstance.getRankLists({ [weak self] (code, msg, lists) in
            if code == 0 {
                var items = [RankListItem]()
                if let lists = lists {
                    if lists.count > 0 {
                        done(.noMore)
                    } else {
                        done(.empty)
                    }
                    for list in lists {
                        let item = RankListItem(model: list)
                        items.append(item)
                    }
                } else {
                    done(.empty)
                }
                self?.items = items
                RankListItem.initForShow(items)
                self?.tableView.reloadData()
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                done(.err)
            }
        }) { [weak self] (error) in
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            done(.err)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "榜单"
        setupNavBackBlackButton(nil)
        tableView.register(RankListCell.self, forCellReuseIdentifier: "RankListCell")
        tableView.register(RankListBottomCell.self, forCellReuseIdentifier: "RankListBottomCell")
        
        setupLoadingView()
        setupRefreshHeader()
        loadDataOnFirstWillAppear = true
        emptyMsg = "当前榜单为空"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankListCell") as! RankListCell
            cell.item = items[indexPath.row]
            cell.showBottomLine = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankListBottomCell") as! RankListBottomCell
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < items.count {
            return RankListCell.cellHeightForModel(items[indexPath.row])
        } else {
            return RankListBottomCell.cellHeight()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let vc = SubRankListViewController()
        vc.rankList = items[indexPath.row].model
        navigationController?.pushViewController(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }

}

class RankListItem {
    let model: RankList
    let isThisYear: Bool
    var isFristOfThisYear: Bool = true
    var isFirst: Bool = false
    var isLast: Bool = false
    init(model: RankList) {
        self.model = model
        if let year = model.year {
            isThisYear = (year == DateTool.getSegDate(Date())!.year)
        } else {
            isThisYear = false
        }
    }
    class func initForShow(_ items: [RankListItem]) {
        var year: Int = 0
        
        for item in items {
            if year == 0 {
                year = item.model.year!
                item.isFristOfThisYear = true
            } else {
                if item.model.year! == year {
                    item.isFristOfThisYear = false
                } else {
                    item.isFristOfThisYear = true
                    year = item.model.year!
                }
            }
        }
        items.first?.isFirst = true
        items.last?.isLast = true
    }
}

class RankListCell: RootTableViewCell {
    var item: RankListItem! {
        didSet {
            if let year  = item.model.year {
                yearLabel.text = String(format: "%04d", year)
            }
            if item.isThisYear {
                yearLabel.backgroundColor = kClrOrange
            } else {
                yearLabel.backgroundColor = kClrBlue
            }
            titleLabel.text = item.model.name
            lineTop.isHidden = item.isFirst
            //lineBottom.hidden = item.isLast
            yearLabel.isHidden = !item.isFristOfThisYear
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
    
    override class func cellHeight() -> CGFloat {
        return 50
    }
    lazy var yearLabel: UILabel = {
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
        contentView.addSubview(yearLabel)
        contentView.addSubview(titleLabel)
        lineTop.CENTER_X.EQUAL(yearLabel).MAKE()
        lineTop.TOP.EQUAL(contentView).MAKE()
        lineTop.BOTTOM.EQUAL(yearLabel).CENTER_Y.MAKE()
        lineTop.WIDTH.EQUAL(0.5).MAKE()
        
        lineBottom.CENTER_X.EQUAL(yearLabel).MAKE()
        lineBottom.BOTTOM.EQUAL(contentView).MAKE()
        lineBottom.TOP.EQUAL(yearLabel).CENTER_Y.MAKE()
        lineBottom.WIDTH.EQUAL(0.5).MAKE()
        
        yearLabel.IN(contentView).LEFT(23).BOTTOM(5).SIZE(40, 40).MAKE()
        yearLabel.layer.cornerRadius = 20
        titleLabel.RIGHT(yearLabel).CENTER.OFFSET(20).MAKE()
        titleLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-20).MAKE()
        bottomLineLeftCons?.constant = 83
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RankListBottomCell: RootTableViewCell {
    override class func cellHeight() -> CGFloat {
        return 20
    }
    lazy var line: UIView = {
        let one = UIView()
        one.backgroundColor = kClrLightGray
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(line)
        line.IN(contentView).LEFT(23 + 20 - 0.25).TOP.BOTTOM.WIDTH(0.5).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
