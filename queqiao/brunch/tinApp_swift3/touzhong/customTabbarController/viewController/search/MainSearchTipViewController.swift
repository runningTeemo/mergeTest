//
//  MainSearchTipViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/19.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MainSearchTipViewController: RootTableViewController {
    
    var isCommonSearch = true
    
    var respondEndEdit: (() -> ())?
    var hasTips: Bool {
        return tips.count > 0 || summits.count > 0
    }
    var key: String?
    var respondType: ((_ type: SearchType, _ key: String, _ count: Int) -> ())?
    var respondId: ((_ type: SearchType, _ id: String, _ key: String) -> ())?
    
    var tips: [SearchTip] = [SearchTip]()
    var summits: [SearchTipSummit] = [SearchTipSummit]()
    func update() {
    }
    
    /// 这个标示用于保证频繁访问网络只取最后一条数据
    var changeFlag: Int = 0
    func handleText(_ text: String) {
        key = text
        changeFlag += 1
        search(text, flag: changeFlag) { [weak self] (flag, tips, summits) in
            if let s = self {
                if s.changeFlag == flag {
                    s.tips = tips
                    s.summits = summits
                    s.tableView.reloadData()
                }
            }
        }
    }
    
    /// 只有成功才返回数据
    func search(_ text: String, flag: Int, done: @escaping ((_ flag: Int, _ tips: [SearchTip], _ summits: [SearchTipSummit]) -> ())) {
        if !Account.sharedOne.isLogin {
            return
        }
        let me = Account.sharedOne.user
        CommonSearchManager.shareInstance.searchTip(user: me, key: text, commonSearch: isCommonSearch, success: { (code, msg, tips, summits, totalCount) in
            if code == 0 {
                done(flag, tips!, summits!)
            }
            }, failed: { (error) in
                
                print(error)
                
        })
    }
    
    lazy var emptyLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrTip
        one.text = "当前为空"
        one.isHidden = true
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchTipCell.self, forCellReuseIdentifier: "SearchTipCell")
        tableView.register(SearchTipSummitCell.self, forCellReuseIdentifier: "SearchTipSummitCell")
        tableView.addSubview(emptyLabel)
        emptyLabel.IN(tableView).TOP(100).CENTER.MAKE()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 10))
    }
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return lineFooter
    }
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return summits.count
        }
        return tips.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTipSummitCell") as! SearchTipSummitCell
            cell.summit = summits[indexPath.row]
            cell.showBottomLine = !(indexPath.item == summits.count - 1)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTipCell") as! SearchTipCell
        cell.tip = tips[indexPath.row]
        cell.showBottomLine = !(indexPath.item == tips.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return SearchTipSummitCell.cellHeight()
        }
        return SearchTipCell.cellHeight()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        respondEndEdit?()
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.section == 0 {
            let summit = summits[indexPath.row]
            if NotNull(summit.type) && NotNull(key) {
                respondType?(summit.type!, key!, summit.count)
            }
        } else {
            let tip = tips[indexPath.row]
            if NotNull(tip.type) && NotNull(tip.id) && NotNull(key) {
                respondId?(tip.type!, tip.id!, key!)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
    }
    
}


class SearchTipSummitCell: RootTableViewCell {
    var summit: SearchTipSummit! {
        didSet {
            typeLabel.text = summit.type?.toString()
            let norDic = [
                NSForegroundColorAttributeName: HEX("#333333"),
                NSFontAttributeName: UIFont.systemFont(ofSize: 15)
            ]
            let countDic = [
                NSForegroundColorAttributeName: kClrOrange,
                NSFontAttributeName: UIFont.systemFont(ofSize: 15)
            ]
            let mAttr = NSMutableAttributedString(string: "\(summit.count)", attributes: countDic)
            mAttr.append(NSAttributedString(string: " 条结果", attributes: norDic))
            countLabel.attributedText = mAttr
        }
    }
    override class func cellHeight() -> CGFloat {
        return 44
    }
    lazy var typeLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 15)
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
        bottomLineLeftCons?.constant = 12.5
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class SearchTipCell: RootTableViewCell {
    var tip: SearchTip! {
        didSet {
            contentLabel.attributedText = tip.attriStr
            typeLabel.text = tip.type?.toString()
            typeLabel.isHidden = Null(tip?.type)
        }
    }
    override class func cellHeight() -> CGFloat {
        return 44
    }
    lazy var contentLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrDarkGray
        one.font = UIFont.systemFont(ofSize: 15)
        return one
    }()
    lazy var typeLabel: UILabel = {
        let one = UILabel()
        one.textColor = kClrWhite
        one.font = UIFont.systemFont(ofSize: 10)
        one.textAlignment = .center
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
        bottomLineRightCons?.constant = -12.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
