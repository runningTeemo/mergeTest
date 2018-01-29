//
//  EnterpriseViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class EnterpriseViewController: CommonDataListViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataArr:[EnterpriseViewModel] = [EnterpriseViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if Account.sharedOne.isLogin{
           // loginView.isHidden = true
            getData(false)
        }else{
            //loginView.isHidden = false
        }
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func advanceSearch() {
        super.advanceSearch()
        self.isAdv = true
        getData(false)
    }
    /**
     获取数据
     
     - author: zerlinda
     - date: 16-09-23 15:09:28
     
     - parameter isFooterRefresh: 是否是下拉刷新
     */
    override func getData(_ isFooterRefresh: Bool){
        super.getData(isFooterRefresh)
        if noData {
            return
        }
         getEnterprise(isFooterRefresh,isAdv: self.isAdv)
    }
    func getEnterprise(_ isFooterRefresh: Bool,isAdv:Bool){
        weak var selfW = self
        DataListManager.shareInstance.getEnterpriseList(true, keyword: "", start: self.starts, rows: self.rows, locations: locations, industryIds: category, rounds: rounds, success: { (code, message, data, totalCount) in
            if code == 0{
                selfW?.endRefresh(.done, view: nil, message: nil)
                selfW?.totalCount = totalCount
                selfW?.addModelArr(data!, isFooterRefresh: isFooterRefresh)
            }else if code == SIGNERRORCODE{
                selfW?.codeSignError?()
            }else{
                selfW?.endRefresh(.doneErr, view: selfW?.view, message: message)
            }
        }) { (error) in
            selfW?.endRefresh(.doneErr, view: selfW?.view, message: kWebErrMsg+"\(error.code)")
        }
        
    }
    func addModelArr(_ arr:[EnterpriseViewModel],isFooterRefresh:Bool){
        if isFooterRefresh{
            for viewModel in arr {
                self.dataArr.append(viewModel)
            }
        }else{
            self.dataArr = arr
        }
        tableView.reloadData()
    }
    
    //MARK:UITableDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identityId = "cellId"
        var cell:EnterpriseCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identityId) as?
            EnterpriseCell
        if cell==nil {
           cell = EnterpriseCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
        }
        cell?.viewModel = dataArr[indexPath.row]
        cell?.cellWidth = self.view.frame.size.width
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.setNeedsLayout()
        cell?.layoutIfNeeded()
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EnterpriseDetailViewController()
        vc.id = dataArr[indexPath.row].model.id!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dataArr[indexPath.row].cellHeight!
    }
    
    
}
