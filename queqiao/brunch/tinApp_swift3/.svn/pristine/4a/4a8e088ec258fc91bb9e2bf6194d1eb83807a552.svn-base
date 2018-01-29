    //
//  CommonDataListViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class CommonDataListViewController: QXYRootTableViewController {
   
    var allowSlide:Bool = false
    var keyWord:String = ""
    var locations:[String] = [String]()
    var category:[String] = [String]()
    var rounds:[String] = [String]()
    var minMoney:String = "-1"
    var maxMoney:String = "-1"
    var startTime:String = ""
    var endTime:String = ""
    var insType:[String] = [String]()
    var capitalFroms:[String] = [String]()
    var isOpen:[String] = [String]()
    var tableViewFrame:Bool = false
    var isGetData:Bool = false //是否获取数据了  用来判断数据页面的验签判断
    var filtDataDic:[String:AnyObject] = [String:AnyObject](){
        didSet{
            self.advanceSearch()
        }
    }
    var codeSignError:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44-49-64)
        setupNavBackBlackButton(nil)
        if tableViewFrame {
            tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        }
        
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func getData(_ isFooterRefresh: Bool) {
        super.getData(isFooterRefresh)
        self.isGetData = true
//        if isFooterRefresh {放到父类里面
//            if starts >= totalCount {
//                self.noData = true
//                tableView.mj_footer.endRefreshingWithNoMoreData()
//            }
//        }
    }
    /**
     解析高级搜索选择返回的字典
     
     - author: zerlinda
     - date: 16-09-27 14:09:12
     */
    func advanceSearch(){
        self.keyWord = SafeUnwarp(self.filtDataDic[""] as? String, holderForNull: "")
        self.locations = SafeUnwarp(self.filtDataDic["area"] as? [String], holderForNull: [String]())
        self.category = SafeUnwarp(self.filtDataDic["category"] as? [String], holderForNull: [String]())
       self.rounds = SafeUnwarp(self.filtDataDic["rounds"] as? [String], holderForNull: [String]())
        let fundArr = SafeUnwarp(self.filtDataDic["fund"] as? [String], holderForNull: ["", ""])
        if fundArr.count>0 {
            self.minMoney = fundArr[0]
            self.maxMoney = fundArr[1]
        }
        let timeArr = SafeUnwarp(self.filtDataDic["time"] as? [String], holderForNull: ["",""])
        if timeArr.count>0 {
            self.startTime = timeArr[0]
            self.endTime = timeArr[1]
        }
        self.insType = SafeUnwarp(self.filtDataDic["insType"] as? [String], holderForNull: [String]())
        self.capitalFroms = SafeUnwarp(self.filtDataDic["capitalFroms"] as? [String], holderForNull: [String]())
        self.isOpen = SafeUnwarp(self.filtDataDic["isOpen"] as? [String], holderForNull:[String]())
        loadingTableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
        if Account.sharedOne.isLogin{
             showNav()
        }else{
             hideNav()
        }
        if Account.sharedOne.isLogin && !isGetData{
            self.getData(false)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
