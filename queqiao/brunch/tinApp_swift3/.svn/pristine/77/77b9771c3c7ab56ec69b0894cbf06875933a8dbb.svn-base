//
//  ExitEventViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ExitEventViewController: CommonDataListViewController,UITableViewDelegate,UITableViewDataSource {

    var dataArr:[ExitEventViewModel] = [ExitEventViewModel]()
    var id :String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if Account.sharedOne.isLogin{
            //loginView.isHidden = true
            getData(false)
        }else{
            //loginView.isHidden = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        title = "退出事件"
  }
    override func advanceSearch() {
        super.advanceSearch()
        self.isAdv = true
        getData(false)
    }

    override func getData(_ isFooterRefresh: Bool){
        super.getData(isFooterRefresh)
        if noData {
            return
        }
        if Account.sharedOne.isLogin {
            if noData == false {
                if NotNullText(id) {
                    getExitListBgId(isFooterRefresh)
                } else {
                    getExitList(isFooterRefresh,isAdv: self.isAdv)
                }
            }
        }
    }
    
    func getExitList(_ isFooterRefresh: Bool,isAdv:Bool){
        weak var selfW = self
        DataListManager.shareInstance.getExiteList(true, keyword: "", start: self.starts, rows: self.rows, locations: locations, industryIds: category, startDate: startTime, endDate: endTime, minAmount: minMoney, maxAmount: maxMoney,success:{ (code, message, data, totalCount) in
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
    func getExitListBgId(_ isFooterRefresh: Bool){
        weak var selfW = self
        DataListManager.shareInstance.getExsitListById(id: self.id!, start: starts, rows: rows, success: { (code, message, data, totalCount) in
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
    
    
    func addModelArr(_ arr:[ExitEventViewModel],isFooterRefresh:Bool){
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
        var cell: ExitEventCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? ExitEventCell
        if cell == nil {
            cell = ExitEventCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
        }
        cell?.cellWidth = self.view.frame.width
        cell?.viewModel = dataArr[indexPath.row]
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
        let vc = ExitEventDetailViewController()
        vc.id = dataArr[indexPath.row].model.eventId!
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
