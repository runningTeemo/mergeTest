//
//  FinancingViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/4.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FinancingViewController: CommonDataListViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataArr:[FinacingViewModel] = [FinacingViewModel]()
    var id :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if Account.sharedOne.isLogin{
            getData(false)
        }else{
            
        }
        title = "投资事件"
    }
    override func advanceSearch() {
        super.advanceSearch()
        self.isAdv = true
        getData(false)
    }
    
    override func getData(_ isFooterRefresh: Bool){
        super.getData(isFooterRefresh)
        if Account.sharedOne.isLogin {
            if noData == false {
                if NotNullText(id) {
                    self.getInvestListBgId(isFooterRefresh)
                } else {
                    self.getInvestList(isFooterRefresh,isAdv:self.isAdv)
                }
            }
        }
    }
    //MARK:获取数据
    /**
     获取投资事件列表
      isadv之所以写死是true  因为最初逻辑是下拉刷新重置为不是高级搜索  现在是下拉刷新不重置条件
     - author: zerlinda
     - date: 16-09-08 11:09:16
     */
    func getInvestList(_ isFooterRefresh: Bool,isAdv:Bool){
        weak var selfW = self
        DataListManager.shareInstance.getInvestList(true, keyword: keyWord,start: self.starts, rows: rows,ronuds:rounds,locations: locations, industryIds: category, startDate: startTime, endDate: endTime, minAmount: minMoney, maxAmount: maxMoney, success: { (code, message, data, totalCount) in
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
    
    
    //MARK:获取数据
    /**
     根据ID获取投资事件列表
     
     - author: zerlinda
     - date: 16-09-08 11:09:16
     */
    func getInvestListBgId(_ isFooterRefresh: Bool){
        weak var selfW = self
        DataListManager.shareInstance.getInvestListById(id: self.id!, start: starts, rows: rows, success: { (code, message, data, totalCount) in
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
    
    func addModelArr(_ arr:[FinacingViewModel],isFooterRefresh:Bool){
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
        let identityId = "cellId"
        var cell: FinancingCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? FinancingCell
        if cell == nil {
            cell = FinancingCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
        }
        cell?.cellWidth = self.view.frame.width
      //  cell!.viewModel = dataArr[indexPath.row]
        let viewModel = dataArr[indexPath.row]
        cell!.viewModel = viewModel
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
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
        let vc = FinancingDetailViewController()
        vc.viewModel = dataArr[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
