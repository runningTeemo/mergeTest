//
//  FinancingDetailViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/15.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FinancingDetailViewController: CommonDataDetailViewController,UITableViewDelegate,UITableViewDataSource {
    
    var titiArr:[String] = [String]()
    var valueArr:[String?] = [String?]()
    var participateArr:[PaticipateInstitotionViewModel] = [PaticipateInstitotionViewModel]()
    var id:String = ""{
        didSet{
            self.getData(false)
        }
    }
    var viewModel:FinacingViewModel = FinacingViewModel(){
        didSet{
            firstSectionHeadLabel.text = viewModel.model.eventTitle
            //设置高亮
            Tools.setHighLightAttibuteColor(label: firstSectionHeadLabel, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 20))
            let size = firstSectionHeadLabel.sizeThatFits(CGSize(width: self.view.bounds.size.width-40, height: CGFloat(MAXFLOAT)))
            firstSectionHeadLabel.frame  = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            titiArr = ["融资企业","融资时间","轮    次","成长阶段","融资金额"]
            fillValueArr()
            fillInstitutionViewModelArr()
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
        if viewModel.model.aimedEnterprise != nil {
            valueArr.append(viewModel.model.aimedEnterprise?.cnName)
        }else{
            valueArr.append("")
        }
        valueArr.append(viewModel.model.happenDate)
        if viewModel.model.round != nil {
            valueArr.append(SafeUnwarp(viewModel.model.round, holderForNull: ""))
        }else{
            valueArr.append("")
        }
        valueArr.append(viewModel.model.growth)
        valueArr.append(viewModel.model.amount)
    }
    
    func fillInstitutionViewModelArr(){
        if viewModel.model.investInstitutionList == nil {
            return
        }
        for i in 0..<viewModel.model.investInstitutionList!.count{
            let particeModel = PaticipateInstitotionViewModel()
            particeModel.model = viewModel.model.investInstitutionList![i]
            participateArr.append(particeModel)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showNav()
    }
    
    override func getData(_ isFooterRefresh:Bool){
        weak var ws = self
        if noData {
            return
        }
        DataListManager.shareInstance.getInvestDetail(id, success: { [weak self](successTuple) in
            if successTuple.code == 0{
                ws?.endRefresh(.done, view: nil, message: nil)
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let viewModel = FinacingViewModel()
                    let model = InvestEventDataModel.objectWithKeyValues(dataDic as NSDictionary) as! InvestEventDataModel
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
        self.navigationItem.title = "融资事件详情"
        tableView.removeFromSuperview()
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = mainBgGray
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - NaviHeight)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        view.backgroundColor = mainBgGray
        tableView.tableHeaderView = view
        setupNavBackBlackButton(nil)
        
    }
    
    //MARK:UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return titiArr.count + 1
        }
        if section == 1 {
            return participateArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == titiArr.count {
                let identity = "describeCell"
                let cell = UnfoldBottomCell(style: .default, reuseIdentifier: identity)
                cell.cellWidth = self.view.bounds.size.width
                cell.numOfLines = 10
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
            cell.titleStr = titiArr[indexPath.row]
            cell.valueStr = valueArr[indexPath.row]
            cell.selectionStyle = .none
            if indexPath.row == 0 && (cell.valueStr ?? "").characters.count > 0{
                cell.showRelevance = true
            }else{
                cell.showRelevance = false
            }
            return cell
        }
        if indexPath.section == 1 {
            let identity = "participateInstitution"
            let cell = participateInstitutionCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = participateArr[indexPath.row]
            cell.indexPath = indexPath
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            //显示最右边的箭头
            return cell
        }
        let identity = "cellId"
        let cell = UITableViewCell(style: .default, reuseIdentifier: identity)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0&&indexPath.row == titiArr.count {
            return unfoldModel.cellHeight!
        }
        if indexPath.section == 1 {
            return 80
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return firstSectionHeadLabel.frame.size.height + 30
        }
        if section == 1 {
            return 44
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view   = UIView()
        var lineStartH :CGFloat = 0
        if section == 0 {
            view.addSubview(firstSectionHeadLabel)
            firstSectionHeadLabel.frame = CGRect(x: leftStartX, y: 15, width: firstSectionHeadLabel.frame.size.width, height: firstSectionHeadLabel.frame.size.height)
            lineStartH = firstSectionHeadLabel.frame.size.height + 30 - 0.5
        }
        if section == 1 {
            let label = UILabel()
            label.frame = CGRect(x: leftStartX, y: 0, width: self.view.frame.size.width, height: 40-1)
            label.font = UIFont.systemFont(ofSize: 15)
            label.text = "参与机构(\(SafeUnwarp(viewModel.model.investInstitutionList?.count, holderForNull: 0)))"
            label.textColor = MyColor.colorWithHexString("#333333")
            view.addSubview(label)
            lineStartH = 44 - 0.5
            if SafeUnwarp(viewModel.model.investInstitutionList?.count, holderForNull: 0) == 0 {
                return UIView()
            }
            
        }
        let line:UIView = UIView()
        line.backgroundColor = cellLineColor
        line.frame = CGRect(x: 0, y: lineStartH, width: self.view.frame.size.width, height: 0.5)
        view.addSubview(line)
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = mainBgGray
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let model = self.participateArr[indexPath.row]
            if let id = model.model?.id {
                if id != "0" {
                    let vc = InstitutionDetailViewController()
                    vc.id = id
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        if indexPath.section == 0 && indexPath.row == 0 && (valueArr[indexPath.row] ?? "").characters.count>0 {
            if let enterprise = viewModel.model.aimedEnterprise{
                if enterprise.id != nil {
                    let vc = EnterpriseDetailViewController()
                    vc.id = enterprise.id!
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class DetailViewModel: CommonViewModel {
    var unfold:Bool = false
    var showStr:String?
    var hidenUnfoldBtn = false
}
class PaticipateInstitotionViewModel: CommonViewModel {
    var model:InstitutionDataModel?
}
class FoldButton: UIView {
    
    //    view.layer.borderColor = mainBlueColor.CGColor
    var label:UILabel = {
        let label = UILabel()
        label.textColor = mainBlueColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.right
        label.text = "全部"
        label.sizeToFit()
        return label
    }()
    var imageV:UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "iconBtnOpenBlue")
        return imageV
    }()
    
    var unfold:Bool = false{
        didSet{
            if unfold {
                imageV.image = UIImage(named: "iconBtnCloselBlue")
                label.text = "收起"
            }else{
                imageV.image = UIImage(named: "iconBtnOpenBlue")
                label.text = "全部"
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        self.addSubview(imageV)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 35, y: 0, width: label.frame.width, height: self.frame.size.height)
        imageV.frame = CGRect(x: label.frame.maxX+2,  y: (self.frame.size.height-10)/2, width: 10, height: 10)
        self.layer.borderColor = mainBlueColor.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

