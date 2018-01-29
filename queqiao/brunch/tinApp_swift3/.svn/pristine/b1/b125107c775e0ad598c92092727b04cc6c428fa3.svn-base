//
//  CustomTableViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CustomTableViewController: LoadingViewController, UITableViewDelegate, UITableViewDataSource {
   
    override func loadData() {
        showLoading()
        loadData({ [unowned self] (dataType) in
            switch dataType {
            case .ThereIsMore, .NoMore:
                self.showSuccess()
            case .Empty:
                self.showEmpty(self.emptyMsg)
            case .Err:
                self.showFailed(self.faliedMsg)
            }
            if self.isFooterAdded {
                if dataType == .NoMore {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self.tableView.mj_footer.endRefreshing()
                }
            }
            })
    }
    
    required init(tableStyle: UITableViewStyle = .Grouped) {
        self.tableStyle = tableStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let tableStyle: UITableViewStyle
    lazy var tableView: UITableView = {
        let one = UITableView(frame: CGRectZero, style: self.tableStyle)
        one.delegate = self
        one.dataSource = self
        one.separatorEffect = nil
        one.separatorStyle = .None
        one.backgroundColor = UIColor.lightGrayColor()
        one.registerClass(RootTableViewCell.self, forCellReuseIdentifier: "RootTableViewCell")
        one.registerClass(RootTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "RootTableViewHeaderFooterView")
        return one
    }()
    
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
    }
    
    //MARK: 刷新相关
    private(set) var isHeaderAdded: Bool = false
    func setupRefreshHeader() {
        isHeaderAdded = true
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.loadData({ [unowned self] (dataType) in
                self.tableView.mj_header.endRefreshing()
                if self.isFooterAdded {
                    if dataType == .NoMore {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer.endRefreshing()
                    }
                }
                })
            })
    }
    private(set) var isFooterAdded: Bool = false
    func setupRefreshFooter() {
        isFooterAdded = true
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.loadMore({ [unowned self] (dataType) in
                if dataType == .NoMore {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self.tableView.mj_footer.endRefreshing()
                }
                })
            })
    }
    func resetFooter() {
        tableView.mj_footer.resetNoMoreData()
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RootTableViewCell") as! RootTableViewCell
        cell.textLabel?.text = "A Cell"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("RootTableViewHeaderFooterView")!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("RootTableViewHeaderFooterView")!
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}


class RootTableViewCell: UITableViewCell {
    
}

class RootTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
}
