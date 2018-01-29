//
//  PersonageDetailViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PersonageDetailViewController: CommonDataDetailViewController,UITableViewDelegate,UITableViewDataSource {
    var id:String = ""{
        didSet{
            self.getData(false)
        }
    }
    var viewModel:PersonageViewModel = PersonageViewModel(){
        didSet{
            unfoldModel.showStr = viewModel.model.cnDescription
            /// 职业生涯数组进行赋值
            var careerA:[CareersViewModel] = [CareersViewModel]()
            if let careers = viewModel.model.careers {
                for model in careers {
                    let careerViewModle = CareersViewModel()
                    careerViewModle.model = model
                    careerA.append(careerViewModle)
                }
                careerModelArr = careerA
            }
            var financingModelA:[FinacingViewModel] = [FinacingViewModel]()
            if let financingS = viewModel.model.invests {
                for model in financingS {
                    let finanViewModel = FinacingViewModel()
                    finanViewModel.model = model
                    financingModelA.append(finanViewModel)
                }
                financingModelArr = financingModelA
            }
            headView.model = viewModel.model
            tableView?.reloadData()
        }
    }
    var unfoldModel:DetailViewModel = DetailViewModel()
    var careerModelArr:[CareersViewModel] = [CareersViewModel]()
    var financingModelArr:[FinacingViewModel] = [FinacingViewModel]()
    var fistHeadView:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var headView: PersonageDetailHeadView = {
        let one = PersonageDetailHeadView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: one.viewHeight)
        one.respondCollect = { [unowned self, unowned one] in
            self.handleCollect()
        }
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewType = .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = mainBgGray
        tableView.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: self.view.frame.size.height - 49 - 10)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)

        tableView.tableHeaderView = headView
        tableView.frame = CGRect(x: 0, y: -headView.appendHeight, width: self.view.frame.size.width, height: headView.appendHeight + kScreenH)
        tableView.mj_footer = nil
       
        self.view.bringSubview(toFront: loadingTableView)
        
        setupCustomNav()
        customNavView.backBlackBtn.isHidden = true
        customNavView.setupBackButton()
        customNavView.respondBack = { [unowned self] in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.statusBarStyle = .lightContent
        customNavView.respondWhite = { [unowned self] in
            self.statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
        }
        customNavView.respondTransparent = { [unowned self] in
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNav()
        checkOrLoadCollect()
    }
  
    //MARK:获取数据
    override func getData(_ isFooterRefresh: Bool) {
        weak var ws = self
        if noData {
            return
        }
        DataListManager.shareInstance.getePersonageDetail(self.id, success: { (code, message, data) in
            if code == 0{
                ws?.endRefresh(.done, view: nil, message: nil)
                self.viewModel = data!
                ws?.tableView.reloadData()
            }else if code == SIGNERRORCODE{
                ws?.codesignError()
            }else{
               ws?.endRefresh(.doneErr, view: ws?.view, message: message+"\(code)")
            }
        }) { (error) in
             ws?.endRefresh(.doneErr, view: ws?.view, message: kWebErrMsg+"\(error.code)")
        }
        
    }
    
    
    var isCollect: Bool = false
    var setNeedsUpdateCollect = true
    func checkOrLoadCollect() {
        
        if !Account.sharedOne.isLogin { return }
        
        if !setNeedsUpdateCollect { return }
        
        let me = Account.sharedOne.user
        headView.attentionBtn.forceDown(true)
        
        MyselfManager.shareInstance.checkCollect(user: me, id: id, type: .figure, success: { [weak self] (code, msg, ret) in
            if code == 0 {
                self?.setNeedsUpdateCollect = false
                self?.headView.attentionBtn.forceDown(false)
                self?.headView.changeLikeImage(ret)
                self?.isCollect = ret
            }
        }) { (error) in
            print(error)
        }
    }
    
    func handleCollect() {
        
        if !Account.sharedOne.isLogin { return }
        
        let me = Account.sharedOne.user
        let collect = !self.isCollect
        
        let model = viewModel.model
        
        let collection = MyCollection()
        collection.type = .figure
        
        collection.targetId = SafeUnwarp(model.userId, holderForNull: "")
        //collection.targetUrl = model.webSite
        
        var name = ""
        if NotNullText(model.cnName) {
            name += model.cnName!
        }
        if NotNullText(model.enName) {
            name += "("
            name += model.enName!
            name += ")"
        }
        collection.targetContent = name
        collection.targetImage = model.imgUrl
        collection.targetDescri = model.companyName
        
        headView.attentionBtn.forceDown(true)
        headView.changeLikeImage(collect)
        weak var ws = self
        headView.changeCollectionCount(collection: collect, success: true)
        MyselfManager.shareInstance.collect(user: me, collect: collect, collection: collection, success: { [weak self] (code, msg, ret) in
            ws?.headView.attentionBtn.forceDown(false)
            if code == 0 {
                ws?.isCollect = collect
            } else {
                ws?.headView.changeLikeImage(!collect)
                ws?.headView.changeCollectionCount(collection: collect, success: false)
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            ws?.headView.attentionBtn.forceDown(false)
            ws?.headView.changeLikeImage(!collect)
            ws?.headView.changeCollectionCount(collection: collect, success: false)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }

    
    
    //UITableViewDelegate
    
    //MARK:UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 1
        }
        if section == 1 {
            return careerModelArr.count
        }
        
        return financingModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let identity = "describeCell"
            let cell = UnfoldBottomCell(style: .default, reuseIdentifier: identity)
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
        if indexPath.section == 1 {//职业生涯
            let identity = "careerCell"
            let cell = PersonageCareerCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = careerModelArr[indexPath.row]
            cell.indexPath = indexPath
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            cell.pushVC = { vc in
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        let identity = "institutionCell"
        let cell = PersonageInstitutionCell(style: .default, reuseIdentifier: identity)
        cell.viewModel = financingModelArr[indexPath.row]
        cell.indexPath = indexPath
        cell.cellWidth = self.view.frame.size.width
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return unfoldModel.cellHeight!
        }
        if indexPath.section == 1 {
            return careerModelArr[indexPath.row].cellHeight!
        }
        if indexPath.section == 2 {
            return 75
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }
        if section == 2 && financingModelArr.count == 0 {
            return 0.0001
        }
        return 35
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view   = UIView()
            view.backgroundColor = UIColor.red
            return view
        }
        let view   = UIView()
        view.backgroundColor = UIColor.white
        let label = LineLabel()
        view.addSubview(label)
        if section==1 {
            label.text = "职业生涯"
            label.mainColor = mainBlueColor
        }
        if section==2 {
            if financingModelArr.count == 0 {
                return UIView()
            }
            label.text = "投资经历"
            label.mainColor = mainBlueGreenColor
        }
        label.frame = CGRect(x: 19.5, y: 35-label.frame.size.height, width: self.view.frame.size.width-40,height: label.frame.size.height)
        label.lineView.frame = CGRect(x: 0, y: 2, width: 2, height: label.frame.size.height - 2)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = mainBgGray
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let model = self.financingModelArr[indexPath.row]
            let vc = FinancingDetailViewController()
            if model.model.eventId != nil {
                vc.id = (model.model.eventId)!
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customNavView.title = "人物详情"
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }
    
}

class PersonageCareerViewModel: CommonViewModel {

    var model:CareerDataModel?
}
class PersonageInstitutionViewModel: CommonViewModel {
  
    var model:InstitutionDataModel?
}
