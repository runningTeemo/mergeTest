//
//  ExitEventDetailViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ExitEventDetailViewController: CommonDataDetailViewController,UITableViewDataSource,UITableViewDelegate {
    
    var titleArr:[String] = [String]()
    var valueArr:[String?] = [String?]()
    var id:String = ""{
        didSet{
            self.getData(false)
        }
    }
   fileprivate var viewModel:ExitEventViewModel = ExitEventViewModel(){
        didSet{
            firstSectionHeadLabel.text = viewModel.model.eventTitle
            //设置高亮
            Tools.setHighLightAttibuteColor(label: firstSectionHeadLabel, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 20))
            let size = firstSectionHeadLabel.sizeThatFits(CGSize(width: self.view.bounds.size.width-40, height: CGFloat(MAXFLOAT)))
            firstSectionHeadLabel.frame  = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            titleArr = ["标的企业"]
            if viewModel.model.exiteInstitution != nil {
                titleArr.append("退出机构")
            }
            if viewModel.model.fundName != nil && viewModel.model.fundName?.characters.count != 0{
                titleArr.append("基金名称")
            }
            titleArr += ["首次投资","总投资","退出时间","退出方式","退出股份","回报金额","回报率"]
            
            fillValueArr()
            unfoldModel.showStr = viewModel.model.desc
            tableView.reloadData()
        }
    }
    
    var unfoldModel:DetailViewModel = DetailViewModel()
    
    var firstSectionHeadLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = MyColor.colorWithHexString("#333333")
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var firstSectionFooterv:UIView = {
        let view = UIView()
        
        return view
    }()
    
    func fillValueArr(){
        valueArr = [String?]()
        valueArr.append(SafeUnwarp(viewModel.model.aimedEnterprise?.cnName, holderForNull: ""))
        if viewModel.model.exiteInstitution != nil {
            valueArr.append(SafeUnwarp(viewModel.model.exiteInstitution?.cnName, holderForNull: ""))
        }
        if viewModel.model.fundName != nil && viewModel.model.fundName?.characters.count != 0{
           valueArr.append(SafeUnwarp(viewModel.model.fundName, holderForNull: ""))
        }
        valueArr.append(viewModel.model.firstInvestDate)
        valueArr.append(viewModel.model.totalInvestAmount)
        valueArr.append(viewModel.model.happenDate)
        valueArr.append(viewModel.model.exiteMode)
        valueArr.append(SafeUnwarp(viewModel.model.storkRight, holderForNull:""))
        valueArr.append(viewModel.model.amount)
        valueArr.append(Tools.decimal(2, originalStr: SafeUnwarp(viewModel.model.returnRate, holderForNull:"")))
    }
 
    override func getData(_ isFooterRefresh:Bool){
        weak var ws = self
        if noData {
            return
        }
        DataListManager.shareInstance.geteExiteDetail(id, success: { [weak self](successTuple) in
            if successTuple.code == 0{
                ws?.endRefresh(.done, view: nil, message: nil)
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let viewModel = ExitEventViewModel()
                    let model = ExitEventDataModel.objectWithKeyValues(dataDic as NSDictionary) as! ExitEventDataModel
                    viewModel.model = model
                    self?.viewModel = viewModel
                }
            }else if successTuple.code == SIGNERRORCODE{
                ws?.codesignError()
            }else{
                ws?.endRefresh(.doneErr, view: ws?.view, message: successTuple.message+"(codell=\(successTuple.code))")
            }
            
        }) { (error) in
            ws?.endRefresh(.doneErr, view: ws?.view, message:kWebErrMsg + "\(error.code)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = mainBgGray
        self.navigationItem.title = "退出事件详情"
        tableView.removeFromSuperview()
        tableViewType = .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = mainBgGray
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - NaviHeight)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.mj_footer = nil
        setupNavBackBlackButton(nil)
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        view.backgroundColor = mainBgGray
        tableView.tableHeaderView = view
        self.view.bringSubview(toFront: loadingTableView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK:UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return titleArr.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == titleArr.count {
                let identity = "describeCell"
                let cell = UnfoldBottomCell(style: .default, reuseIdentifier: identity)
                cell.numOfLines = 10
                cell.cellWidth = self.view.bounds.size.width
                cell.model = self.unfoldModel
                cell.indexPath = indexPath
                cell.selectionStyle = .none
                cell.reloadCell = {indexPath in
                    self.unfoldModel.unfold = !self.unfoldModel.unfold
                    tableView.reloadData()
                }
                return cell
            }
            let identity = "labelValueCell"
            let cell = LabelValueCell(style: .default, reuseIdentifier: identity)
            cell.cellWidth = self.view.bounds.size.width
            cell.titleStr = titleArr[indexPath.row]
            cell.valueStr = valueArr[indexPath.row]
            cell.selectionStyle = .none
            if indexPath.row == 0 && (cell.valueStr ?? "").characters.count > 0{
                cell.showRelevance = true
                
            }else if indexPath.row == 1 && viewModel.model.exiteInstitution != nil{
                cell.showRelevance = true
            }else{
               cell.showRelevance = false
            }
            return cell
        }
        let identity = "cellId"
        let cell = UITableViewCell(style: .default, reuseIdentifier: identity)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0&&indexPath.row == titleArr.count {
            return unfoldModel.cellHeight!
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return firstSectionHeadLabel.frame.size.height + 30
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view   = UIView()
            view.backgroundColor = UIColor.white
            view.addSubview(firstSectionHeadLabel)
            firstSectionHeadLabel.frame = CGRect(x: leftStartX, y: 15, width: firstSectionHeadLabel.frame.size.width, height: firstSectionHeadLabel.frame.size.height)
            let line:UIView = UIView()
            line.backgroundColor = cellLineColor
            line.frame = CGRect(x: 0, y: firstSectionHeadLabel.frame.size.height + 30 - 0.5, width: self.view.frame.size.width, height: 0.5)
            view.addSubview(line)
            return view
        }
        return UILabel()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = mainBgGray
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 && (valueArr[indexPath.row] ?? "").characters.count>0{
            if let id = viewModel.model.aimedEnterprise?.id {
                let vc = EnterpriseDetailViewController()
                vc.id = id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 0 && indexPath.row == 1{
            if let id = viewModel.model.exiteInstitution?.id {
                let vc = InstitutionDetailViewController()
                vc.id = id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
