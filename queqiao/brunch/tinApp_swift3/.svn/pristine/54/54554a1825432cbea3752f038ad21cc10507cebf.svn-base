//
//  RootTableViewController.swift
//  NewProject
//
//  Created by Zerlinda on 16/5/20.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit

class RootTableViewController: LoadingViewController, UITableViewDataSource, UITableViewDelegate {

    var hasData: Bool = false
    private(set) var isDragging: Bool = false
    
    override func clearFirstInStatus() {
        super.clearFirstInStatus()
        tableView.contentOffset = CGPoint.zero
    }
    
    override func changeModel(){
        self.view.backgroundColor = ChangeModel.changeControllerModelColor()
        tableView.backgroundColor = ChangeModel.changeControllerModelColor()
    }
    
    /// 这个方法用于重载内容
    override func loadData() {
        showLoading()
        loadData({ [weak self] (dataType) in
            if let s = self {
                s.handleLoadDone(dataType)
            }
            })
    }
    func handleLoadDone(_ dataType: LoadDataType) {
        self.setDataType(dataType)
        switch dataType {
        case .thereIsMore, .noMore:
            self.showSuccess()
        case .empty:
            self.showEmpty(self.emptyMsg)
        case .err:
            self.showFailed(self.faliedMsg)
        }
        if self.isFooterAdded {
            if dataType == .noMore {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    /// 创建方法，可选择不同的table类型，默认 Grouped
    init(tableStyle: UITableViewStyle = .grouped) {
        self.tableStyle = tableStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var tableStyle: UITableViewStyle
    
    lazy var tableView: UITableView = {
        let one = UITableView(frame: CGRect.zero, style: self.tableStyle)
        one.delegate = self
        one.dataSource = self
        one.separatorEffect = nil
        one.separatorStyle = .none
        one.backgroundColor = kClrBackGray
        one.register(RootTableViewCell.self, forCellReuseIdentifier: "RootTableViewCell")
        one.register(RootTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "RootTableViewHeaderFooterView")
        return one
    }()
    
    // 修改这些约束可以调整tableView的位置
    /*
     演示：
     tableViewTopCons.content = 64 (tableview距离上端64)
     tableViewBottomCons.content = -49 (tableview距离下端49)
     */
    var tableViewLeftCons: NSLayoutConstraint!
    var tableViewRightCons: NSLayoutConstraint!
    var tableViewTopCons: NSLayoutConstraint!
    var tableViewBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableViewLeftCons = tableView.LEFT.EQUAL(view).MAKE()
        tableViewRightCons = tableView.RIGHT.EQUAL(view).MAKE()
        tableViewTopCons = tableView.TOP.EQUAL(view).MAKE()
        tableViewBottomCons = tableView.BOTTOM.EQUAL(view).MAKE()
        //automaticallyAdjustsScrollViewInsets = false
    }
    
    //MARK: 刷新相关
    
    fileprivate(set) var isHeaderAdded: Bool = false
    /// 添加刷新头
    func setupRefreshHeader() {
        isHeaderAdded = true
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadData({ [weak self] (dataType) in
                guard let s = self else {
                    return
                }
                s.setDataType(dataType)
                    s.tableView.mj_header.endRefreshing()
                    if s.isFooterAdded {
                        if dataType == .noMore {
                            s.tableView.mj_footer.endRefreshingWithNoMoreData()
                        } else {
                            s.tableView.mj_footer.endRefreshing()
                        }
                    }
                })
            })
    }
    
    fileprivate(set) var isFooterAdded: Bool = false
    /// 添加刷新尾
    func setupRefreshFooter() {
        isFooterAdded = true
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                self?.footerRefreshHandle()
            })
    }
    func footerRefreshHandle() {
        self.loadMore({ [weak self] (dataType) in
            if dataType == .noMore {
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self?.tableView.mj_footer.endRefreshing()
            }
            })
    }
    
    /// 删除刷新尾
    func removeRefreshFooter() {
        tableView.mj_footer = nil
    }
    
    /// 重置尾部
    func resetFooter() {
        if tableView.mj_footer != nil {
            tableView.mj_footer.resetNoMoreData()
        }
    }
    func hideFooter(_ hide: Bool) {
        if isFooterAdded {
            if tableView.mj_footer != nil {
                tableView.mj_footer.isHidden = hide
            }
        }
    }
    
    // 搜索相关
    fileprivate(set) var isSearchEmptyLabelShow: Bool = false
    lazy var searchEmptyLabel: UILabel = {
        let one = UILabel()
        one.textColor = UIColor.black
        one.font = UIFont.systemFont(ofSize: 16)
        return one
    }()
    func showSearchEmpty(_ msg: String?) {
        if !isSearchEmptyLabelShow {
            isSearchEmptyLabelShow = true
            tableView.addSubview(searchEmptyLabel)
            searchEmptyLabel.IN(tableView).TOP(80).CENTER.MAKE()
        }
        searchEmptyLabel.text = SafeUnwarp(msg, holderForNull: "没有搜索结果")
        searchEmptyLabel.isHidden = false
    }
    func hideSearchEmpty() {
        isSearchEmptyLabelShow = false
        searchEmptyLabel.isHidden = true
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RootTableViewCell") as! RootTableViewCell
        cell.textLabel?.text = "A Cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RootTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "RootTableViewHeaderFooterView")!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "RootTableViewHeaderFooterView")!
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }
    
    
    func autoCheckHasData(models: [Any]?) {
        hasData = false
        if let models = models {
            if models.count > 0 {
                hasData = true
            }
        }
    }
    
    func performRefresh() {
        if hasData {
            if isHeaderAdded {
                tableView.mj_header.beginRefreshing()
            }
        } else {
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }

}

class RootTableViewCell: UITableViewCell {
        
    class func cellHeight() -> CGFloat {
        return 50
    }
    
    var showBottomLine: Bool = false {
        didSet {
            rootBottomLine.isHidden = !showBottomLine
            contentView.bringSubview(toFront: rootBottomLine)
        }
    }
    
    lazy var rootBottomLine: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#e7e7e7")
        one.isHidden = true
        return one
    }()
    var bottomLineLeftCons: NSLayoutConstraint?
    var bottomLineRightCons: NSLayoutConstraint?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(rootBottomLine)
        rootBottomLine.IN(contentView).BOTTOM.HEIGHT(0.5).MAKE()
        bottomLineLeftCons = rootBottomLine.LEFT.EQUAL(contentView).MAKE()
        bottomLineRightCons = rootBottomLine.RIGHT.EQUAL(contentView).MAKE()
        contentView.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 快捷添加右面的小箭头
    fileprivate(set) var showRightArrow = false
    fileprivate(set) lazy var rightArrow: UIImageView = {
        let one = UIImageView()
        one.image = UIImage(named: "iconListMore")
        return one
    }()
    var rightMargin: CGFloat {
        return showRightArrow ? (10 * 2 + 15) : 15
    }
    func setupRightArrow() {
        contentView.addSubview(rightArrow)
        showRightArrow = true
        rightArrow.IN(contentView).RIGHT(10).SIZE(15, 15).CENTER.MAKE()
    }
    func setupRightFixArrow(topMargin t: CGFloat = 20) {
        contentView.addSubview(rightArrow)
        showRightArrow = true
        rightArrow.IN(contentView).RIGHT(10).SIZE(15, 15).TOP(t).MAKE()
    }
}

class RootTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    class func viewHeight() -> CGFloat {
        return 50
    }
    
}

