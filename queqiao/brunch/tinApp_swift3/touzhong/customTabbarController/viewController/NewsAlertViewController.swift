//
//  NewsAlertViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class NewsAlertViewController: RootViewController {
    //  var pushVC:((_ vc:UIViewController)->())?
    var isMoreData:Bool = false
    var numOfRow:Int = 1
    var anrchPoint:CGPoint?
    var tagtId:String = ""
    var tagType:String = ""
    var enterpriseViewModel:EnterpriseCueViewModel = EnterpriseCueViewModel()
    var personageViewModel:PersonageViewModel = PersonageViewModel()
    var institutionViewModel:InstitutionCueViewModel = InstitutionCueViewModel()
    
    var enterpriseView:EnterpriseView = EnterpriseView()
    var institutionView:InstitutionView = InstitutionView()
    var personageView:PersonView = PersonView()
    var deleteView:UIView = {
        let view = UIView()
        let imageV = UIImageView()
        imageV.image = UIImage(named: "newsClose")
        imageV.frame = CGRect(x: 8, y: 8, width: 14, height: 14)
        view.addSubview(imageV)
        return view
    }()
    
    var bgView:UIView = {
        let view = UIView()
        return view
    }()
    var finalFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    //var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNav()
        view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
        bgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 64)
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0
        view.addSubview(bgView)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(NewsAlertViewController.hideSelf))
        bgView.addGestureRecognizer(tapGes)
        addView()
        view.addSubview(deleteView)
        deleteView.isHidden = true
        self.view.bringSubview(toFront: deleteView)
        self.enterpriseView.enterpriseViewModel = self.enterpriseViewModel
        self.institutionView.institutionViewModel = self.institutionViewModel
        self.personageView.personageViewModel = self.personageViewModel
        self.showMainView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    ///MARK:Action
    
    func getData() {
        weak var ws = self
        if tagType == "1"{//机构
            DataListManager.shareInstance.getInstitutionCue(tagtId, success: { (code, message, data) in
                if code == 0{
                    ws?.institutionView.institutionViewModel = data!
                    ws?.showMainView()
                }else if code == SIGNERRORCODE{
                    Account.sharedOne.logout()
                    self.dismiss(animated: false, completion: nil)
                }else{
                    print(message)
                    self.dismiss(animated: false, completion: nil)
                }
            }) { (error) in
                print(error)
                ws?.dismiss(animated: false, completion: nil)
            }
        }
        if tagType == "2"{//企业
            DataListManager.shareInstance.geteEnterpriseCue(tagtId, success: { (successTuple) in
                if successTuple.code == 0{
                    //  ws?.endRefresh(.done, view: nil, message: nil)
                    let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                    if let dataDic = data{
                        let viewModel = EnterpriseCueViewModel()
                        let investDic = dataDic["events"] as? [Dictionary<String,AnyObject>]
                        let model = EnterpriseCueDataModel.objectWithKeyValues(dataDic as NSDictionary) as! EnterpriseCueDataModel
                        if investDic != nil{
                            model.parseEventsModel(investEvents:investDic!)
                        }
                        viewModel.model = model
                        
                        ws?.enterpriseView.enterpriseViewModel = viewModel
                        ws?.showMainView()
                    }
                }else if successTuple.code == SIGNERRORCODE{
                    Account.sharedOne.logout()
                    self.dismiss(animated: false, completion: nil)
                }else{
                   self.dismiss(animated: false, completion: nil)
                }
            }) { (error) in
                ws?.dismiss(animated: false, completion: nil)
            }
        }
        if tagType == "3"{//人物
            DataListManager.shareInstance.getePersonageDetail(tagtId, success: { (code, message, data) in
                if code == 0{
                    ws?.personageView.personageViewModel = data!
                    ws?.showMainView()
                }else if code == SIGNERRORCODE{
                    Account.sharedOne.logout()
                    self.dismiss(animated: false, completion: nil)
                }else{
                    print(message)
                    self.dismiss(animated: false, completion: nil)
                }
            }) { (error) in
                ws?.dismiss(animated: false, completion: nil)
            }
        }
    }
    func addView(){
        if tagType == "1"{
            view.addSubview(institutionView)
            institutionView.frame = CGRect(x: SafeUnwarp(anrchPoint?.x, holderForNull: 0), y: SafeUnwarp(anrchPoint?.y, holderForNull: 0), width: 0, height: 0)
            institutionView.cellWidth = self.view.frame.width-25
            institutionView.pushVC = { vc in
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            institutionView.layer.cornerRadius = 5
            institutionView.layer.masksToBounds = true
        }
        if tagType == "2"{
            view.addSubview(enterpriseView)
            enterpriseView.frame = CGRect(x: SafeUnwarp(anrchPoint?.x, holderForNull: 0), y: SafeUnwarp(anrchPoint?.y, holderForNull: 0), width: 0, height: 0)
            enterpriseView.cellWidth = self.view.frame.width-25
            enterpriseView.pushVC = {vc in
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            enterpriseView.layer.cornerRadius = 5
            enterpriseView.layer.masksToBounds = true
        }
        if tagType == "3"{
            view.addSubview(personageView)
            personageView.frame = CGRect(x: SafeUnwarp(anrchPoint?.x, holderForNull: 0), y: SafeUnwarp(anrchPoint?.y, holderForNull: 0), width: 0, height: 0)
            personageView.cellWidth = self.view.frame.width-25
            personageView.pushVC = { vc in
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            personageView.layer.cornerRadius = 5
            personageView.layer.masksToBounds = true
        }
        deleteView.frame = CGRect(x: SafeUnwarp(anrchPoint?.x, holderForNull: 0), y: SafeUnwarp(anrchPoint?.y, holderForNull: 0), width: 40, height: 40)
    }
    
    func showMainView(){
        weak var ws = self
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            ws?.bgView.backgroundColor = UIColor.black
            ws?.bgView.alpha = 0.4
            ws?.showFinalView()
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(NewsAlertViewController.hideSelf))
            ws?.deleteView.isHidden = false
            ws?.deleteView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            ws?.deleteView.center = CGPoint(x: (ws?.view.frame.width)!-leftStartX-25, y: ((ws?.view.frame.height)!-(ws?.finalFrame.height)!)/2+25)
            ws?.deleteView.addGestureRecognizer(tapGes)
            ws?.deleteView.layer.cornerRadius = 15
            ws?.deleteView.layer.masksToBounds = true
            ws?.view.bringSubview(toFront: (ws?.deleteView)!)
        }) { (comple) in
            
        }
    }
    
    func showFinalView(){
        //var finalFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if tagType == "1"{
            finalFrame = institutionView.finalFame
            self.institutionView.frame = CGRect(x: 12.5, y: (self.view.frame.height-finalFrame.height)/2, width: finalFrame.width, height:finalFrame.height)
            self.institutionView.tableView.frame = CGRect(x: 0, y: 0, width: finalFrame.width, height: finalFrame.height)
        }
        if tagType == "2"{
            finalFrame = enterpriseView.finalFame
            self.enterpriseView.frame = CGRect(x: 12.5, y: (self.view.frame.height-finalFrame.height)/2, width: finalFrame.width, height:finalFrame.height)
            self.enterpriseView.tableView.frame = CGRect(x: 0, y: 0, width: finalFrame.width, height: finalFrame.height)
        }
        if tagType == "3"{
            finalFrame = personageView.finalFame
            self.personageView.frame = CGRect(x: 12.5, y: (self.view.frame.height-finalFrame.height)/2, width: finalFrame.width, height:finalFrame.height)
            self.personageView.tableView.frame = CGRect(x: 0, y: 0, width: finalFrame.width, height: finalFrame.height)
        }
    }
    
    func hideSelf(){
        self.dismiss(animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class InstitutionView: RootView,UITableViewDelegate,UITableViewDataSource{
    
    var pushVC:((_ vc:UIViewController)->())?
    var tableView:UITableView!
    var eventViewModelArr:[CommonViewModel] = [CommonViewModel]()
    var cellWidth:CGFloat = 0
    var finalFame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var height:CGFloat = 0.001
    var institutionViewModel:InstitutionCueViewModel = InstitutionCueViewModel(){
        didSet{
            eventViewModelArr = getEventViewModel()
            getViewHeight()
            height = 0
            for viewModel in eventViewModelArr {
                height += viewModel.cellHeight!
            }
            self.tableView.reloadData()
            self.finalFame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:cellWidth, height: 76.5+height)
        }
    }
    
    func getEventViewModel()->[CommonViewModel]{
        
        var arr:[CommonViewModel] = [CommonViewModel]()
        if let events = institutionViewModel.model?.investEvents {
            for dataModel in events {
                if dataModel.objectType == cueEventType.invest.rawValue {
                    let viewModel = FinacingViewModel()
                    let model = dataModel as? InvestEventDataModel
                    if model != nil{
                        viewModel.model = model!
                        arr.append(viewModel)
                    }
                }
                if dataModel.objectType == cueEventType.merger.rawValue {
                    let viewModel = MergerViewModel()
                    let model = dataModel as? MergerDataModel
                    if model != nil{
                        viewModel.model = model!
                        arr.append(viewModel)
                    }
                }
                if dataModel.objectType == cueEventType.exite.rawValue {
                    let viewModel = ExitEventViewModel()
                    let model = dataModel as? ExitEventDataModel
                    if model != nil{
                        viewModel.model = model!
                        arr.append(viewModel)
                    }
                }
            }
        }
        return arr
    }
    
    //MARK:计算高度
    func getViewHeight(){
        if let events = institutionViewModel.model?.investEvents {
            for i in 0..<events.count {
                let dataModel = events[i]
                if dataModel.objectType == cueEventType.invest.rawValue {
                    let viewModel:FinacingViewModel? = eventViewModelArr[i] as? FinacingViewModel
                    getInvestCellHeight(viewModel:viewModel)
                }
                if dataModel.objectType == cueEventType.merger.rawValue {
                    let viewModel:MergerViewModel? = eventViewModelArr[i] as? MergerViewModel
                    getMergerCellHeight(viewModel:viewModel!)
                }
                if dataModel.objectType == cueEventType.exite.rawValue {
                    let viewModel:ExitEventViewModel? = eventViewModelArr[i] as? ExitEventViewModel
                    getExitCellHeight(viewModel:viewModel!)
                }
            }
        }
    }
    
    //获取cell高度
    func getInvestCellHeight(viewModel:FinacingViewModel?){
        viewModel?.cellHeight = 100
        //前面的需求 后面改的 代码不删 防止改回来
//        if viewModel?.model.investInstitutionList != nil && viewModel?.model.aimedEnterprise != nil{
//            viewModel?.cellHeight = 104
//        }else{
//            viewModel?.cellHeight = 76
//        }
//        var cellHeight:CGFloat = 0.001
//        if viewModel?.model.investInstitutionList != nil {
//            let titleArr = getTitleArr(modelArr:(viewModel?.model.investInstitutionList)!)
//            cellHeight = calculateHeight(arr: titleArr)
//        }else{
//            cellHeight = 45
//        }
//        viewModel?.cellHeight = cellHeight
    }
    //获取merger高度
    func getMergerCellHeight(viewModel:MergerViewModel){
         //前面的需求 后面改的 代码不删 防止改回来
        viewModel.cellHeight = 100
//        if viewModel.model.buyEnterpriseList != nil && viewModel.model.aimedEnterprise != nil{
//            viewModel.cellHeight = 104
//        }else{
//            viewModel.cellHeight = 76
//        }
//        var cellHeight:CGFloat = 0.001
//        if viewModel.model.buyEnterpriseList != nil {
//            var titleArr = [String]()
//            for enterprise in viewModel.model.buyEnterpriseList! {
//                if enterprise.shortCnName != nil {
//                    titleArr.append(enterprise.shortCnName!)
//                }
//            }
//            cellHeight = calculateHeight(arr: titleArr)
//        }else{
//            cellHeight = 45
//        }
//        viewModel.cellHeight = cellHeight
    }
    
    func getExitCellHeight(viewModel:ExitEventViewModel){
        
        viewModel.cellHeight = 110.5
    }
    //获取融资cell中得机构列表
    func getTitleArr(modelArr:[InstitutionDataModel])->[String]{
        var titleArr:[String] = [String]()
        for intitutionModel in modelArr {
            if intitutionModel.shortCnName != nil {
                titleArr.append("\(SafeUnwarp(intitutionModel.shortCnName, holderForNull: "")) \(SafeUnwarp(intitutionModel.amount, holderForNull: ""))")
            }
        }
        return titleArr
    }
    
    //计算融资高度
    func calculateHeight(arr:[String])->CGFloat{
        if arr.count == 0{
            return 45
        }
        let view = LeftAndRightLabel()
        view.textArr = arr
        view.frame = CGRect(x: leftStartX+15, y: 45, width: cellWidth - leftStartX*2-15, height: 30)
        view.update()
        return view.frame.maxY+15
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = false
        self.addSubview(tableView)
        
    }
    func getCell(indexPath: IndexPath,dataModel:RootEventDataModel)->UITableViewCell{
        if dataModel.objectType == cueEventType.invest.rawValue {
            let identityId = "finanCell"
            var cell: NewsAlertFinanceEventCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? NewsAlertFinanceEventCell
            if cell == nil {
                cell = NewsAlertFinanceEventCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell?.enterPriseId = institutionViewModel.model?.id
            cell!.cellWidth = cellWidth
            let model = eventViewModelArr[indexPath.row-1] as? FinacingViewModel
            cell!.viewModel = SafeUnwarp(model, holderForNull: FinacingViewModel())
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        }
        if dataModel.objectType == cueEventType.merger.rawValue {
            
            let identityId = "mergerCell"
            var cell: NewsAlertMergerEventCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? NewsAlertMergerEventCell
            if cell == nil {
                cell = NewsAlertMergerEventCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell!.cellWidth = cellWidth
            cell?.enterPriseId = institutionViewModel.model?.id
            let model = eventViewModelArr[indexPath.row-1] as? MergerViewModel
            cell!.viewModel = SafeUnwarp(model, holderForNull: MergerViewModel())
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
            
        }
        if dataModel.objectType == cueEventType.exite.rawValue {
            let identityId = "exitCell"
            var cell: ExitEventCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? ExitEventCell
            if cell == nil {
                cell = ExitEventCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell!.cellWidth = cellWidth
            let model = eventViewModelArr[indexPath.row-1] as? ExitEventViewModel
            cell!.viewModel = SafeUnwarp(model, holderForNull: ExitEventViewModel())
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }

    
    //MARK:TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventViewModelArr.count>3 {
            return 4
        }
        return eventViewModelArr.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{//机构
            return  institutionViewModel.cellHeight!
        }
        return eventViewModelArr[indexPath.row-1].cellHeight!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{//机构
            let identityId = "InstitutionCell"
            var cell: InstitutionCueCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? InstitutionCueCell
            if cell == nil {
                cell = InstitutionCueCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell!.cellWidth = cellWidth
            cell?.viewModel = institutionViewModel
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        }
        if let events = institutionViewModel.model?.investEvents {
            
            let dataModel = events[indexPath.row-1]
            let cell = getCell(indexPath:indexPath,dataModel:dataModel)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InstitutionDetailViewController()
        vc.id = (institutionViewModel.model?.id)!
        pushVC?(vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class EnterpriseView: RootView,UITableViewDelegate,UITableViewDataSource{
    
    var pushVC:((_ vc:UIViewController)->())?
    var tableView:UITableView!
    var eventViewModelArr:[CommonViewModel] = [CommonViewModel]()
    var cellWidth:CGFloat = 0
    var finalFame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var height:CGFloat = 0
    var enterpriseViewModel:EnterpriseCueViewModel = EnterpriseCueViewModel(){
        didSet{
            eventViewModelArr = getEventViewModel()
            getViewHeight()
            height = 0
            for viewModel in eventViewModelArr {
                height += viewModel.cellHeight!
            }
            self.tableView.reloadData()
            self.finalFame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:cellWidth, height: 70+height)
        }
    }
    
    func getEventViewModel()->[CommonViewModel]{
        
        var arr:[CommonViewModel] = [CommonViewModel]()
        if let events = enterpriseViewModel.model.events {
            for dataModel in events {
                if dataModel.objectType == cueEventType.invest.rawValue {
                    let viewModel = FinacingViewModel()
                    let model = dataModel as? InvestEventDataModel
                    if model != nil{
                        viewModel.model = model!
                        arr.append(viewModel)
                    }
                }
                if dataModel.objectType == cueEventType.merger.rawValue {
                    let viewModel = MergerViewModel()
                    let model = dataModel as? MergerDataModel
                    if model != nil{
                        viewModel.model = model!
                        arr.append(viewModel)
                    }
                }
                if dataModel.objectType == cueEventType.exite.rawValue {
                    let viewModel = ExitEventViewModel()
                    let model = dataModel as? ExitEventDataModel
                    if model != nil{
                        viewModel.model = model!
                        arr.append(viewModel)
                    }
                }
            }
        }
        return arr
    }
     //MARK:计算高度
    func getViewHeight(){
        if let events = enterpriseViewModel.model.events {
            for i in 0..<events.count {
                let dataModel = events[i]
                if dataModel.objectType == cueEventType.invest.rawValue {
                    let viewModel:FinacingViewModel? = eventViewModelArr[i] as? FinacingViewModel
                    getInvestCellHeight(viewModel:viewModel)
                }
                if dataModel.objectType == cueEventType.merger.rawValue {
                    let viewModel:MergerViewModel? = eventViewModelArr[i] as? MergerViewModel
                    getMergerCellHeight(viewModel:viewModel!)
                }
                if dataModel.objectType == cueEventType.exite.rawValue {
                    let viewModel:ExitEventViewModel? = eventViewModelArr[i] as? ExitEventViewModel
                    getExitCellHeight(viewModel:viewModel!)
                }
            }
        }
    }
    
    //获取cell高度
    func getInvestCellHeight(viewModel:FinacingViewModel?){
        //前面的需求 后面改的 代码不删 防止改回来
        viewModel?.cellHeight = 100
//        if viewModel?.model.investInstitutionList != nil && viewModel?.model.aimedEnterprise != nil{
//            viewModel?.cellHeight = 104
//        }else{
//            viewModel?.cellHeight = 76
//        }
//        var cellHeight:CGFloat = 0.001
//        if viewModel?.model.investInstitutionList != nil {
//            let titleArr = getTitleArr(modelArr:(viewModel?.model.investInstitutionList)!)
//            cellHeight = calculateHeight(arr: titleArr)
//        }else{
//            cellHeight = 45
//        }
//        viewModel?.cellHeight = cellHeight
    }
    //获取merger高度
    func getMergerCellHeight(viewModel:MergerViewModel){
        viewModel.cellHeight = 100
        //前面的需求 后面改的 代码不删 防止改回来
//        if viewModel.model.buyEnterpriseList != nil && viewModel.model.aimedEnterprise != nil{
//            viewModel.cellHeight = 104
//        }else{
//            viewModel.cellHeight = 76
//        }
        
//        if viewModel.model.buyEnterpriseList != nil {
//            var titleArr = [String]()
//            for enterprise in viewModel.model.buyEnterpriseList! {
//                if enterprise.shortCnName != nil {
//                    titleArr.append(enterprise.shortCnName!)
//                }
//            }
//            cellHeight = calculateHeight(arr: titleArr)
//        }else{
//            cellHeight = 45
//        }
//        viewModel.cellHeight = cellHeight
    }
    
    func getExitCellHeight(viewModel:ExitEventViewModel){
        
        viewModel.cellHeight = 110.5
    }
    //获取融资cell中得机构列表
    func getTitleArr(modelArr:[InstitutionDataModel])->[String]{
        var titleArr:[String] = [String]()
        for intitutionModel in modelArr {
            if intitutionModel.shortCnName != nil {
                titleArr.append("\(SafeUnwarp(intitutionModel.shortCnName, holderForNull: "")) \(SafeUnwarp(intitutionModel.amount, holderForNull: ""))")
            }
        }
        return titleArr
    }
    
    //计算融资高度
    func calculateHeight(arr:[String])->CGFloat{
        if arr.count == 0{
            return 45
        }
        let view = LeftAndRightLabel()
        view.textArr = arr
        view.frame = CGRect(x: leftStartX+15, y: 45, width: cellWidth - leftStartX*2-15, height: 30)
        view.update()
        return view.frame.maxY+15
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = false
        
        self.addSubview(tableView)
    }
    //MARK:获取cell
    func getCell(indexPath: IndexPath,dataModel:RootEventDataModel)->UITableViewCell{
         //融资的cell
        if dataModel.objectType == cueEventType.invest.rawValue {
            let identityId = "finanCell"
            var cell: NewsAlertFinanceEventCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? NewsAlertFinanceEventCell
            if cell == nil {
                cell = NewsAlertFinanceEventCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell!.cellWidth = cellWidth
            cell?.enterPriseId = enterpriseViewModel.model.id
            let model = eventViewModelArr[indexPath.row-1] as? FinacingViewModel
            cell!.viewModel = SafeUnwarp(model, holderForNull: FinacingViewModel())
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        }
        //并购的cell
        if dataModel.objectType == cueEventType.merger.rawValue {
            
            let identityId = "mergerCell"
            var cell: NewsAlertMergerEventCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? NewsAlertMergerEventCell
            if cell == nil {
                cell = NewsAlertMergerEventCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell?.enterPriseId = enterpriseViewModel.model.id
            cell!.cellWidth = cellWidth
            let model = eventViewModelArr[indexPath.row-1] as? MergerViewModel
            cell!.viewModel = SafeUnwarp(model, holderForNull: MergerViewModel())
           cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
            
        }
        //退出的cell
        if dataModel.objectType == cueEventType.exite.rawValue {
            let identityId = "exitCell"
            var cell: ExitEventCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? ExitEventCell
            if cell == nil {
                cell = ExitEventCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell!.cellWidth = cellWidth
            let model = eventViewModelArr[indexPath.row-1] as? ExitEventViewModel
            cell!.viewModel = SafeUnwarp(model, holderForNull: ExitEventViewModel())
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = 0
        for viewModel in eventViewModelArr {
            height += viewModel.cellHeight!
        }
        self.finalFame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:cellWidth, height: 81.5+height)
    }
    
    //MARK:TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventViewModelArr.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return  enterpriseViewModel.cellHeight!
        }
        return eventViewModelArr[indexPath.row-1].cellHeight!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let identityId = "enterpriseCell"
            var cell: alertEnterpriseCell?
            cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? alertEnterpriseCell
            if cell == nil {
                cell = alertEnterpriseCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell!.cellWidth = cellWidth
            cell?.viewModel = enterpriseViewModel
            return cell!
        }
        if let events = enterpriseViewModel.model.events {
            
            let dataModel = events[indexPath.row-1]
            let cell = getCell(indexPath:indexPath,dataModel:dataModel)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if enterpriseViewModel.model.id != nil {
            let vc = EnterpriseDetailViewController()
            vc.id = (enterpriseViewModel.model.id)!
            vc.hidesBottomBarWhenPushed = true
            pushVC?(vc)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class alertEnterpriseCell: CommonCell {
    
    var viewModel:EnterpriseCueViewModel = EnterpriseCueViewModel(){
        didSet{
            let name = SafeUnwarp(viewModel.model.cnName, holderForNull: "")
            nameLabel.text = SafeUnwarp(viewModel.model.shortCnName, holderForNull: name)
            nameLabel.sizeToFit()
            Tools.setHighLightAttibuteColor(label: nameLabel, startStr: "<hlt>", endStr: "</hlt>", attributeColor: UIColor.red, attributeFont: UIFont.systemFont(ofSize: 16))
            timeLabel.text = SafeUnwarp(viewModel.model.setUpTime, holderForNull: "")
            timeLabel.sizeToFit()
            insTypeLabel.text = SafeUnwarp(viewModel.model.industryName, holderForNull: "")
            if viewModel.model.list == "0" {
                userNameLabel.text = "未上市"
            }else{
                if let stock = viewModel.model.stocks?[0] {
                    userNameLabel.text = "\(SafeUnwarp(stock.stockExchange, holderForNull: "")) \(SafeUnwarp(stock.stockCode, holderForNull: ""))"
                }
            }
            addModuleAndChangeFrame()
        }
    }
    
    fileprivate var selfH:CGFloat = 0
    var indexPath : IndexPath?
    
    var nameLabel:CommonLabel = {
        let label = CommonLabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#999999")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    var insTypeLabel:LineLabel = {
        let label = LineLabel()
        label.label.font = UIFont.systemFont(ofSize: 12)
        label.mainColor = MyColor.colorWithHexString("#999999")
        label.label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    var userNameLabel:LineLabel = {
        let label = LineLabel()
        label.label.font = UIFont.systemFont(ofSize: 12)
        label.mainColor = MyColor.colorWithHexString("#999999")
        label.label.textColor = MyColor.colorWithHexString("#999999")
        return label
    }()
    
    var reloadCell : ReloadCellClosure?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(timeLabel)
        self.addSubview(insTypeLabel)
        self.addSubview(userNameLabel)
        self.contentView.addSubview(nameLabel)
    }
    
    override func addModuleAndChangeFrame() {
        if cellWidth==0 {
            return
        }
        nameLabel.frame = CGRect(x: 20, y: 20, width: nameLabel.frame.width, height: nameLabel.frame.height)
        timeLabel.frame = CGRect(x: 20, y: nameLabel.frame.maxY + 6, width: timeLabel.frame.width, height: timeLabel.frame.height)
        if timeLabel.text == "" || insTypeLabel.text == "" {
            insTypeLabel.lineHidden = true
        }else{
            insTypeLabel.lineHidden = false
        }
        insTypeLabel.frame = CGRect(x: timeLabel.frame.maxX + 6,  y: nameLabel.frame.maxY + 15, width: insTypeLabel.frame.width, height: insTypeLabel.frame.height)
        insTypeLabel.center = CGPoint(x: insTypeLabel.center.x, y: timeLabel.center.y)
        userNameLabel.frame = CGRect(x: insTypeLabel.frame.maxX + 6,  y: nameLabel.frame.maxY + 15, width: userNameLabel.frame.width, height: userNameLabel.frame.height)
        userNameLabel.center = CGPoint(x: userNameLabel.center.x, y: timeLabel.center.y)
        cellLine.frame = CGRect(x: 0, y: timeLabel.frame.maxY+10, width: cellWidth, height: 0.5)
        viewModel.cellHeight = cellLine.frame.maxY + 1
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

class PersonView: RootView,UITableViewDelegate,UITableViewDataSource{
    var pushVC:((_ vc:UIViewController)->())?
    var tableView:UITableView!
    var eventViewModel:[FinacingViewModel] = [FinacingViewModel]()
    var cellWidth:CGFloat = 0
    var finalFame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var personageViewModel:PersonageViewModel = PersonageViewModel(){
        didSet{
            var financingModelA:[FinacingViewModel] = [FinacingViewModel]()
            if let financingS = personageViewModel.model.invests {
                for model in financingS {
                    let finanViewModel = FinacingViewModel()
                    finanViewModel.model = model
                    financingModelA.append(finanViewModel)
                }
                eventViewModel = financingModelA
            }
            self.finalFame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:cellWidth, height: 400)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
        tableView.isScrollEnabled = false
    }
    
    //MARK:TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventViewModel.count>3 {
            return 4
        }
        return eventViewModel.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return  personageViewModel.cellHeight!
        }
        return eventViewModel[indexPath.row-1].cellHeight!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{//人物
            let cell = PersonageCell(style: UITableViewCellStyle.default, reuseIdentifier: "personCell")
            cell.viewModel = personageViewModel
            cell.cellWidth = cellWidth
            return cell
        }
        let identityId = "finanCell"
        var cell: FinancingCell?
        cell = tableView.dequeueReusableCell(withIdentifier: identityId) as? FinancingCell
        if cell == nil {
            cell = FinancingCell(style: UITableViewCellStyle.default, reuseIdentifier: identityId)
        }
        cell!.cellWidth = cellWidth
        let model = eventViewModel[indexPath.row-1]
        cell!.viewModel = SafeUnwarp(model, holderForNull: FinacingViewModel())
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PersonageDetailViewController()
        vc.id = (personageViewModel.model.userId)!
        vc.hidesBottomBarWhenPushed = true
        pushVC?(vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


