//
//  PersonageViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PersonageViewController: CommonDataListViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataArr:[PersonageViewModel] = [PersonageViewModel]()
    var topLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = mainBgGray
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "排序不分先后，仅根据用户搜索频次排序"
        label.textColor = MyColor.colorWithHexString("#999999")
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: 0, y: 0, width: 0, height: 24)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(false)
        tableView.tableHeaderView = topLabel
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self

    }
    override func getData(_ isFooterRefresh: Bool){
        super.getData(isFooterRefresh)
        if noData {
            return
        }
        getPersonageList(isFooterRefresh)
    }
    
    func getPersonageList(_ isFooterRefresh: Bool){
        weak var selfW = self
        DataListManager.shareInstance.getPersonageList(false, keyword: "", start: self.starts, rows: self.rows, success: { (code, message, data, totalCount) in
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
    func addModelArr(_ arr:[PersonageViewModel],isFooterRefresh:Bool){
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
        var cell:PersonageCell? = tableView.dequeueReusableCell(withIdentifier: identityId) as? PersonageCell
        if cell == nil {
           cell = PersonageCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
        }
        
        cell?.viewModel = dataArr[indexPath.row]
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.cellWidth = self.view.frame.width
        return cell ?? UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = PersonageDetailViewController()
        vc.id = dataArr[indexPath.row].model.userId!
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if Account.sharedOne.user.author ==  .isAuthed{
//            let vc = PersonageDetailViewController()
//            vc.id = dataArr[indexPath.row].model.userId!
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            remindCertification()
//        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
