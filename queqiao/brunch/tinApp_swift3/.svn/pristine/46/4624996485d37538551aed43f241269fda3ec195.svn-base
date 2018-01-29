//
//  QXYRootTableViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit


class QXYRootTableViewController: RootViewController {

    lazy var loadingTableView: LoadingTableView = {
        let one = LoadingTableView()
        return one
    }()
    var tableView:UITableView!
    /// 是否是上拉刷新
    fileprivate var footerRefresh:Bool = false
    var starts:Int = 0
    var rows:Int = 20
    var totalCount:NSInteger = 0
    var noData:Bool = false
    var isAdv:Bool = false
    
    var  tableViewType:UITableViewStyle = .plain{
        didSet{
            createTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.tableViewType = .plain
        view.addSubview(loadingTableView)
        loadingTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.bringSubview(toFront: loadingTableView)
        loadingTableView.isHidden = false
        loadingTableView.isUserInteractionEnabled = false///正在加载的时候不允许点击
        weak var ws = self
        loadingTableView.cell.respondReload = {
            ws?.loadingTableView.cell.showLoading()
            ws?.headRefresh()
        }
    }
    
   fileprivate func createTableView(){
        tableView = UITableView(frame: CGRect.zero, style:tableViewType)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        self.setupRefreshHeader()
        self.setupRefreshFooter()
        tableView.mj_footer.isHidden = true
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-49)
    }
    /// 添加刷新头
    func setupRefreshHeader() {
        weak var ws = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            ws?.headRefresh()
        })
        /**
         *  @author zerlinda, 16-09-23 14:09:42
         *
         *  因为不继承loadingtableview，所以临时加的解决方案         *
         *  @return <#return value description#>
         */
        loadingTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            ws?.headRefresh()
        })
   }
    
    /// 上拉刷新
    func setupRefreshFooter() {
        weak var ws = self
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            ws?.getData(true)
        })
    }
    
    /**
     下拉刷新
     
     - author: zerlinda
     - date: 16-09-27 10:09:06
     */
    func headRefresh(){
        self.isAdv = false
        self.getData(false)
    }
    
    /**
     获取数据 下拉刷新的时候起始行为0
     
     - author: zerlinda
     - date: 16-09-10 17:09:40
     */
    func getData(_ isFooterRefresh:Bool){
        self.footerRefresh = isFooterRefresh
        if isFooterRefresh {
            starts += rows
        }else{
            noData = false
            starts = 0
        }
        if isFooterRefresh { //判断是否是最后一行数据
            if starts >= totalCount {
                self.noData = true
                tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
    }
    /**
     结束刷新
     
     - author: zerlinda
     - date: 16-09-23 12:09:19
     */
    func endRefresh(_ loadingStatus:LoadStatus,view:UIView?,message:String?){
        if tableView.mj_footer != nil {
             tableView.mj_footer.isHidden = false
        }
        if  footerRefresh{
            if self.tableView.mj_footer != nil{
                self.tableView.mj_footer.endRefreshing()
            }
        }else{
            if  self.tableView.mj_header != nil{
                self.tableView.mj_header.endRefreshing()
            }
            if loadingTableView.mj_header != nil {
                loadingTableView.mj_header.endRefreshing()
            }
        }
        if loadingStatus == .done{
            loadingTableView.isHidden = true
            return
        }
        //加载失败允许点击重新加载
        if footerRefresh {
            self.starts -= rows
        }
        loadingTableView.isUserInteractionEnabled = true
        //self.view.bringSubview(toFront: loadingTableView)
        if loadingTableView.isHidden{
            QXTiper.showFailed(message, inView: view, cover: true)
        }else{
            loadingTableView.cell.showFailed(SafeUnwarp(message, holderForNull: ""))
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
