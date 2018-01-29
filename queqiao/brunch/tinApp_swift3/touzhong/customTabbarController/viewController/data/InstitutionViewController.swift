//
//  InstitutionViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionViewController: CommonDataListViewController,UITableViewDataSource,UITableViewDelegate {
    
    var dataArr:[InstitutionViewModel] = [InstitutionViewModel]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if Account.sharedOne.isLogin{
          //  loginView.isHidden = true
            getData(false)
        }else{
           // loginView.isHidden = false
        }
        tableView.delegate = self
        tableView.dataSource = self
      //  tableView.alpha = 0
    }
    
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
        getInstitutionList(isFooterRefresh,isAdv: self.isAdv)
    }

    func getInstitutionList(_ isFooterRefresh: Bool,isAdv:Bool){
        weak var selfW = self
        DataListManager.shareInstance.getInstitutionList(true, keyword: "", start: self.starts, rows: self.rows, industryIds: category, insType: insType, capitalFroms: capitalFroms, isOpenInvest: isOpen, success: { (code, message, data, totalCount) in
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
    func addModelArr(_ arr:[InstitutionViewModel],isFooterRefresh:Bool){
        if isFooterRefresh{
            for viewModel in arr {
                self.dataArr.append(viewModel)
            }
        }else{
            self.dataArr = arr
        }
        tableView.reloadData()
    }

    //UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identityId = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? InstitutionCell
        if cell == nil {
          cell = InstitutionCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
          cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
        cell?.cellWidth = self.view.frame.width
        cell!.viewModel = dataArr[indexPath.row]
        cell!.indexPath = indexPath
        cell!.pushVC = {vc in
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        weak var ws = self
        cell?.nameTapAction = { id in
            if Account.sharedOne.user.author ==  .isAuthed{
                let vc = PersonageDetailViewController()
                vc.id = id
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                ws?.remindCertification()
            }
        }
        cell!.reloadCell = { indexPath in
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cellHeight!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InstitutionDetailViewController()
        vc.id = dataArr[indexPath.row].model.id!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
