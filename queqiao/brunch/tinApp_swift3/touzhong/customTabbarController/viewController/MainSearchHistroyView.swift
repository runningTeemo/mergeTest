//
//  MainSearchHistroyView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/10.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MainSearchHistroyView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var respondEndEdit: (() -> ())?
    
    var histories: [History] = [History]() {
        didSet {
            emptyLabel.hidden = histories.count != 0
            tableView.reloadData()
        }
    }
    
    lazy var emptyLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFontOfSize(14)
        one.textColor = kClrTip
        one.text = "当前为空"
        one.hidden = true
        return one
    }()
    
    lazy var tableView: UITableView = {
        let one = UITableView(frame: CGRectZero, style: .Grouped)
        one.delegate = self
        one.dataSource = self
        one.separatorEffect = nil
        one.separatorStyle = .None
        one.backgroundColor = kClrBackGray
        one.registerClass(SearchHistoryCell.self, forCellReuseIdentifier: "SearchHistoryCell")
        one.registerClass(SearchHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "SearchHistoryHeader")
        return one
    }()
    required init() {
        super.init(frame: CGRectZero)
        addSubview(tableView)
        tableView.addSubview(emptyLabel)
        emptyLabel.IN(tableView).TOP(100).CENTER.MAKE()
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, kScreenW, 10))
        tableView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        histories = History.getHistories()
        emptyLabel.hidden = histories.count != 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SearchHistoryHeader.viewHeight()
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SearchHistoryHeader") as! SearchHistoryHeader
        view.respondClean = { [unowned self] in
            let histories = [History]()
            History.saveHistories(histories)
            self.histories = histories
            self.tableView.reloadData()
        }
        return view
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchHistoryCell") as! SearchHistoryCell
        cell.history = histories[indexPath.row]
        cell.showBottomLine = !(indexPath.item == histories.count - 1)
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SearchHistoryCell.cellHeight()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        respondEndEdit?()
    }
    
}

class SearchHistoryHeader: RootTableViewHeaderFooterView {
    
    var respondClean: (() -> ())?
    
    override class func viewHeight() -> CGFloat {
        return 50
    }
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFontOfSize(15)
        one.text = "搜索历史"
        return one
    }()
    lazy var cleanBtn: TitleButton = {
        let one = TitleButton()
        one.norTitleColor = kClrDarkGray
        one.dowTitleColor = kClrSlightGray
        one.norTitlefont = UIFont.systemFontOfSize(15)
        one.dowTitlefont = UIFont.systemFontOfSize(15)
        one.norBgColor = UIColor.clearColor()
        one.dowBgColor = UIColor.clearColor()
        one.title = "清空"
        one.signal_event_touchUpInside.head({ [unowned self] (signal) in
            self.respondClean?()
        })
        return one
    }()
    lazy var bottomLine: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#e7e7e7")
        return one
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(cleanBtn)
        contentView.addSubview(bottomLine)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        cleanBtn.IN(contentView).RIGHT.TOP.BOTTOM.WIDTH(60).MAKE()
        bottomLine.IN(contentView).LEFT(12.5).BOTTOM.RIGHT.HEIGHT(0.3).MAKE()
        contentView.backgroundColor = kClrWhite
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchHistoryCell: RootTableViewCell {
    override class func cellHeight() -> CGFloat {
        return 44
    }
    var history: History! {
        didSet {
            keyLabel.text = history.key
        }
    }
    lazy var iconView: ImageView = {
        let one = ImageView()
        one.image = UIImage(named: "iconTzhyTime")
        return one
    }()
    lazy var keyLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFontOfSize(15)
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(keyLabel)
        iconView.IN(contentView).LEFT(12.5).CENTER.SIZE(15, 15).MAKE()
        keyLabel.RIGHT(iconView).OFFSET(10).CENTER.MAKE()
        keyLabel.RIGHT.LESS_THAN_OR_EQUAL(contentView).OFFSET(-12.5).MAKE()
        bottomLineLeftCons?.constant = 12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

