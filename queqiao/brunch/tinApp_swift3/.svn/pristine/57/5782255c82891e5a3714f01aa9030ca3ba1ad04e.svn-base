//
//  MainSearchTipView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/10.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

/// 搜索关键字提示
class MainSearchTipView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var respondEndEdit: (() -> ())?
    
    var tips: [SearchTip] = [SearchTip]()
    var summits: [SearchTipSummit] = [SearchTipSummit]()
    func update() {
        tableView.reloadData()
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
        one.registerClass(SearchTipCell.self, forCellReuseIdentifier: "SearchTipCell")
        one.registerClass(SearchTipSummitCell.self, forCellReuseIdentifier: "SearchTipSummitCell")
        return one
    }()
    required init() {
        super.init(frame: CGRectZero)
        addSubview(tableView)
        tableView.addSubview(emptyLabel)
        emptyLabel.IN(tableView).TOP(100).CENTER.MAKE()
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, kScreenW, 10))
        tableView.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        let t = SearchTip(key: "文字", type: "新闻")
        t.text = "这是一段文字，很长"
        tips = [t, t]
        
        let s = SearchTipSummit(type: "人物")
        s.count = 3
        summits = [s, s, s]
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tips.count > 0 {
            return 0.3
        }
        return 0.0001
    }
    lazy var lineFooter: UIView = {
        let one = UIView()
        one.backgroundColor = kClrBreak
        return one
    }()
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return lineFooter
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return summits.count
        }
        return tips.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchTipSummitCell") as! SearchTipSummitCell
            cell.summit = summits[indexPath.row]
            cell.showBottomLine = !(indexPath.item == summits.count - 1)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTipCell") as! SearchTipCell
        cell.tip = tips[indexPath.row]
        cell.showBottomLine = !(indexPath.item == tips.count - 1)
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return SearchTipSummitCell.cellHeight()
        }
        return SearchTipCell.cellHeight()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        respondEndEdit?()
    }
}

class SearchTipSummitCell: RootTableViewCell {
    var summit: SearchTipSummit! {
        didSet {
            typeLabel.text = summit.type
            let norDic = [
                NSForegroundColorAttributeName: HEX("#333333"),
                NSFontAttributeName: UIFont.systemFontOfSize(15)
            ]
            let countDic = [
                NSForegroundColorAttributeName: kClrOrange,
                NSFontAttributeName: UIFont.systemFontOfSize(15)
            ]
            let mAttr = NSMutableAttributedString(string: "\(summit.count)", attributes: countDic)
            mAttr.appendAttributedString(NSAttributedString(string: "条结果", attributes: norDic))
            countLabel.attributedText = mAttr
        }
    }
    override class func cellHeight() -> CGFloat {
        return 44
    }
    lazy var typeLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFontOfSize(15)
        return one
    }()
    lazy var countLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(typeLabel)
        contentView.addSubview(countLabel)
        typeLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        countLabel.IN(contentView).RIGHT(12.5).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SearchTipCell: RootTableViewCell {
    var tip: SearchTip! {
        didSet {            
            contentLabel.attributedText = tip.attriStr
            typeLabel.text = tip.type
            typeLabel.hidden = Null(tip?.type)
        }
    }
    override class func cellHeight() -> CGFloat {
        return 44
    }
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFontOfSize(15)
        return one
    }()
    lazy var typeLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFontOfSize(10)
        one.textAlignment = .Center
        one.backgroundColor = HEX("#b5b5b5")
        one.layer.cornerRadius = 3
        one.clipsToBounds = true
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentLabel)
        contentView.addSubview(typeLabel)
        typeLabel.IN(contentView).RIGHT(12.5).CENTER.SIZE(36, 18).MAKE()
        contentLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        contentLabel.RIGHT.LESS_THAN_OR_EQUAL(typeLabel).LEFT.OFFSET(-20).MAKE()
        bottomLineLeftCons?.constant = 12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


