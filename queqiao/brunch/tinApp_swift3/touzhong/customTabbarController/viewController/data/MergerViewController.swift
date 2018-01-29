//
//  MergerViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MergerViewController: CommonDataListViewController,UITableViewDelegate,UITableViewDataSource {
 
    var dataArr:[MergerViewModel] = [MergerViewModel]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if Account.sharedOne.isLogin{
           // loginView.isHidden = true
            getData(false)
        }else{
            //loginView.isHidden = false
        }
    }
    /**
     高级搜索
     
     - author: zerlinda
     - date: 16-09-27 16:09:48
     */
    override func advanceSearch() {
        super.advanceSearch()
        self.isAdv = true
        getData(false)
    }
    
    override func getData(_ isFooterRefresh: Bool) {
        super.getData(isFooterRefresh)
        if noData {
            return
        }
        getMergerList(isFooterRefresh,isAdv: self.isAdv)
    }
    
    func getMergerList(_ isFooterRefresh: Bool,isAdv:Bool){
        weak var selfW = self
        DataListManager.shareInstance.getMergerList(true, keyword: "", start: self.starts, rows: self.rows, locations: locations, industryIds: category, startDate: startTime, endDate: endTime, minAmount: minMoney, maxAmount: maxMoney,  success: { (code, message, data, totalCount) in
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
    func addModelArr(_ arr:[MergerViewModel],isFooterRefresh:Bool){
        if isFooterRefresh{
            for viewModel in arr {
                self.dataArr.append(viewModel)
            }
        }else{
            self.dataArr = arr
        }
        tableView.reloadData()
    }
    
    
    //MARK:UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identityId = "mergerId"
        var cell: MergerCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? MergerCell
        if cell == nil {
            cell = MergerCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
        cell?.cellWidth = self.view.frame.width
        let viewModel = dataArr[indexPath.row]
        cell!.viewModel = viewModel
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cellHeight!
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MergerDetailViewController()
        vc.viewModel = dataArr[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
