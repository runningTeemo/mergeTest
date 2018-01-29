//
//  MainSearchHistroyViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/19.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MainSearchHistroyViewController: RootTableViewController {
    
    var respondEndEdit: (() -> ())?
    var respondKey: ((_ key: String) -> ())?
    
    var histories: [History] = [History]() {
        didSet {
            emptyLabel.isHidden = histories.count != 0
            tableView.reloadData()
        }
    }
    
    lazy var emptyLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrTip
        one.text = "没有搜索历史"
        one.isHidden = true
        return one
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(emptyLabel)
        emptyLabel.IN(tableView).TOP(100).CENTER.MAKE()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 10))
        histories = History.getHistories()
        emptyLabel.isHidden = histories.count != 0
        
        tableView.register(SearchHistoryCell.self, forCellReuseIdentifier: "SearchHistoryCell")
        tableView.register(SearchHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "SearchHistoryHeader")
    }
    
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SearchHistoryHeader.viewHeight()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchHistoryHeader") as! SearchHistoryHeader
        view.respondClean = { [unowned self] in
            let histories = [History]()
            History.saveHistories(histories)
            self.histories = histories
            self.tableView.reloadData()
        }
        
        view.cleanBtn.isHidden = histories.count == 0
        return view
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(histories.count, 5)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCell") as! SearchHistoryCell
        cell.history = histories[indexPath.row]
        cell.showBottomLine = !(indexPath.item == histories.count - 1)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchHistoryCell.cellHeight()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        respondEndEdit?()
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        respondKey?(histories[indexPath.row].key)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
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
        one.font = UIFont.systemFont(ofSize: 15)
        one.text = "搜索历史"
        return one
    }()
    lazy var cleanBtn: TitleButton = {
        let one = TitleButton()
        one.norTitleColor = kClrDarkGray
        one.dowTitleColor = kClrSlightGray
        one.norTitlefont = UIFont.systemFont(ofSize: 15)
        one.dowTitlefont = UIFont.systemFont(ofSize: 15)
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
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
        one.font = UIFont.systemFont(ofSize: 15)
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
