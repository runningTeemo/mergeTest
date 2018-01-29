//
//  UseHornViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class UseHornViewController: QXYRootTableViewController,UITableViewDelegate,UITableViewDataSource {
    
    var respondHorn: ((_ horn: HornDataModel?) -> ())?
    
    var dataArr:[HornViewModel] = [HornViewModel]()
    var date:String = "0" //最后一条信息的创建时间
    
    var disableLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = MyColor.colorWithHexString("#333333")
        label.text = "不使用广播喇叭"
        label.sizeToFit()
        return label
    }()
    var topBgView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var selectStateImageV:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 9
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "radioBox")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "使用广播喇叭"
        createTopLabel()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: disableLabel.frame.maxY + 10, width: view.frame.width, height: view.frame.height - NaviHeight - disableLabel.frame.maxY - 10)
        tableView.mj_header.backgroundColor = mainBgGray
        tableView.backgroundColor = mainBgGray
        self.rows = 7
        getData(false)
        // Do any additional setup after loading the view.
        
        setupNavBackBlackButton(nil)
    }
    
    /// 创建顶部是否使用的圆点，如果是展示界面
    func createTopLabel(){
        topBgView.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: 40)
        view.addSubview(topBgView)
        disableLabel.frame = CGRect(x: leftStartX, y: 0, width: disableLabel.frame.width, height: 40)
        topBgView.addSubview(disableLabel)
        selectStateImageV.frame = CGRect(x: view.frame.width-leftStartX-18, y: (40-18)/2, width: 18, height: 18)
        topBgView.addSubview(selectStateImageV)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(UseHornViewController.disableTap))
        topBgView.addGestureRecognizer(tapGes)
    }
    func disableTap(){
        selectStateImageV.image = UIImage(named: "radioBoxSelect")
        tableView.reloadData()
        print("你点击了我")
        respondHorn?(nil)
        _ = navigationController?.popViewController(animated: true)
    }
    
    /// 获取数据
    ///
    /// - Parameter isFooterRefresh: <#isFooterRefresh description#>
    override func getData(_ isFooterRefresh: Bool) {
        super.getData(isFooterRefresh)
        if noData {
            return
        }
        weak var ws = self
        if !isFooterRefresh {
            date = "0"
        }
        MyselfManager.getHorn(start: starts, date: date, row: rows, success: {(code, message, data, totalCount) in
            if code == 0 {
                ws?.endRefresh(.done, view: nil, message: nil)
                ws?.totalCount = totalCount
                ws?.addModelArr(data!, isFooterRefresh: isFooterRefresh)
            }else if code == SIGNERRORCODE{
                //ws?.codeSignError?()
            }else{
                ws?.endRefresh(.doneErr, view: ws?.view, message: message)
            }
        }, failed: {(error) in
            ws?.endRefresh(.doneErr, view: ws?.view, message: kWebErrMsg+"\(error.code)")
        })
        
    }
    func addModelArr(_ arr:[HornViewModel],isFooterRefresh:Bool){
        if isFooterRefresh{
            for viewModel in arr {
                self.dataArr.append(viewModel)
            }
        }else{
            self.dataArr = arr
        }
        self.date = SafeUnwarp(dataArr.last?.model.createTime, holderForNull: "0")
        tableView.reloadData()
    }

  
    //MARK:UITableViewDelagate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return  dataArr[indexPath.row].cellHeight!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = dataArr[indexPath.row]
        if viewModel.model.effective == "1"&&viewModel.model.used == "0" {
            let cellId = "hornCell"
            var cell:HornCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? HornCell
            if cell == nil {
                cell = HornCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
            }
            cell?.hornViewModel = dataArr[indexPath.row]
            cell?.cellWidth = self.view.frame.width
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        }else{
            let cellId = "ExpiredHornCell"
            var cell:ExpiredHornCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? ExpiredHornCell
            if cell == nil {
                cell = ExpiredHornCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
            }
            let viewModel = dataArr[indexPath.row]
            cell?.hornViewModel = viewModel
            cell?.cellWidth = self.view.frame.width
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = dataArr[indexPath.row]
        viewModel.isSelect = true
        selectStateImageV.image = UIImage(named: "radioBox")
        
        if viewModel.model.effective == "1" {
            respondHorn?(viewModel.model)
            _ = navigationController?.popViewController(animated: true)
        }
        
    }

}
