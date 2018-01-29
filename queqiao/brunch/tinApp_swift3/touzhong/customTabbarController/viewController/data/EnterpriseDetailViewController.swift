//
//  EnterpriseDetailViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class EnterpriseDetailViewController: CommonDataDetailViewController,UITableViewDelegate,UITableViewDataSource {
    
    var sectionTiltleArr:[String] = [String]()
    var unfoldModel:DetailViewModel = DetailViewModel()
    var financingArr:[FinacingViewModel] = [FinacingViewModel]()
    var mergerArr:[MergerViewModel] = [MergerViewModel]()
    var contactArr:[ContactViewModel] = [ContactViewModel]()
    var relevantNewsArr:[News] = [News]()
    var id:String = ""{
        didSet{
            getData(false)
        }
    }
    
    var isCollect: Bool = false
    var setNeedsUpdateCollect = true
    
    fileprivate var viewModel:EnterpriseViewModel = EnterpriseViewModel(){
        didSet{
            headView.model = viewModel.model
            unfoldModel.showStr = viewModel.model.desc
            var arr:[FinacingViewModel] = [FinacingViewModel]()
            if viewModel.model.financingEvents != nil {
                for model in viewModel.model.financingEvents! {
                    let fViewModel = FinacingViewModel()
                    fViewModel.model = model
                    arr.append(fViewModel)
                }
                financingArr = arr
            }
            if viewModel.model.mergerEvents != nil {
                var mergerA:[MergerViewModel] = [MergerViewModel]()
                for model in viewModel.model.mergerEvents! {
                    let fViewModel = MergerViewModel()
                    fViewModel.model = model
                    mergerA.append(fViewModel)
                }
                mergerArr = mergerA
            }
            if viewModel.model.contact != nil {
                var contactA:[ContactViewModel] = [ContactViewModel]()
                for i in 0..<viewModel.model.contact!.count{
                    let contactViewModel = ContactViewModel()
                    contactViewModel.model = viewModel.model.contact![i]
                    contactA.append(contactViewModel)
                }
                contactArr = contactA
            }
            sectionTiltleArr = ["","基本信息","相关产品","融资(\(financingArr.count))","并购(\(mergerArr.count))","联系方式","相关新闻"]
            tableView.reloadData()
            weak var ws = self
            DispatchQueue.global(qos: .default).async {
                ws?.getRelevantNews()//获取相关新闻
            }
        }
    }
    
    /// 企业详情 头部界面
    lazy var headView: EnterpriseDetailHeadView = {
        let one = EnterpriseDetailHeadView()
        one.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: one.viewHeight)
        one.respondCollect = { [unowned self, unowned one] in
            self.handleCollect()
        }
        return one
    }()
    
    var attentionViewModel:AttentionViewModel = AttentionViewModel(){
        didSet{
            headView.attentionViewModel = attentionViewModel
        }
    }
    //MARK:获取数据
    /**
     获取数据
     
     - author: zerlinda
     - date: 16-09-22 10:09:01
     */
    override func getData(_ isFooterRefresh: Bool) {
        weak var ws = self
        if noData {
            return
        }
        DataListManager.shareInstance.geteEnterpriseDetail(id, success: { (successTuple) in
            if successTuple.code == 0{
                ws?.endRefresh(.done, view: nil, message: nil)
                let data:Dictionary? = (successTuple.data as? Dictionary<String,AnyObject>)
                if let dataDic = data{
                    let viewModel = EnterpriseViewModel()
                    let model = EnterpriseDataModel.objectWithKeyValues(dataDic as NSDictionary) as! EnterpriseDataModel
                    viewModel.model = model
                    ws?.viewModel = viewModel
                }
            }else if successTuple.code == SIGNERRORCODE{
                ws?.codesignError()
            }else{
                ws?.endRefresh(.doneErr, view: ws?.view, message: successTuple.message+"\(successTuple.code)")
            }
            
        }) { (error) in
            ws?.endRefresh(.doneErr, view: ws?.view, message: kWebErrMsg+"\(error.code)")
        }
    }
    
    /// 获取相关新闻
    func getRelevantNews(){
        var industryId:[String] = [String]()
        if viewModel.model.industry != nil{
            for industryModel in viewModel.model.industry! {
                if industryModel.id != nil{
                    industryId.append(industryModel.id!)
                }
            }
        }
        weak var ws = self
        NewsManager.shareInstance.getRelevantNews(shortCnName: viewModel.model.shortCnName, cnName: viewModel.model.cnName,category: .enterprise, industryIds:industryId,success: { (code, message, data) in
            if code == 0{
                ws?.getNewsSuccess(dataArr: data)
            }
        }) { (error) in
            debugPrint(error)
        }
    }
    
    func getNewsSuccess(dataArr:[News]?){
        relevantNewsArr = SafeUnwarp(dataArr, holderForNull: [News]())
        weak var ws = self
        let count  = relevantNewsArr.count
        let countStr = count == 0 ? "" : "\(count)"
        sectionTiltleArr = ["","基本信息","相关产品","融资(\(financingArr.count))","并购(\(mergerArr.count))","联系方式","相关新闻(" + countStr + ")"]
        DispatchQueue.main.async {
            ws?.tableView.reloadData()
        }
    }
    func checkOrLoadCollect() {
        
        if !Account.sharedOne.isLogin { return }
        
        if !setNeedsUpdateCollect { return }
        let me = Account.sharedOne.user
        headView.attentionBtn.forceDown(true)
        MyselfManager.shareInstance.checkCollect(user: me, id: id, type: .enterprise, success: { [weak self] (code, msg, ret) in
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
        collection.type = .enterprise
        
        collection.targetId = "\(SafeUnwarp(model.id, holderForNull: ""))"
        collection.targetUrl = model.website
        if let name = model.shortCnName {
            collection.targetContent = name
        } else if let name = model.cnName {
            collection.targetContent = name
        } else if let name = model.shortEnName {
            collection.targetContent = name
        } else if let name = model.enName {
            collection.targetContent = name
        }
        collection.targetImage = model.logoUrl
        collection.targetDescri = model.desc
        
        headView.attentionBtn.forceDown(true)
        headView.changeLikeImage(collect)
        weak var ws = self
        headView.changeCollectionCount(collection: collect, success: true)
        MyselfManager.shareInstance.collect(user: me, collect: collect, collection: collection, success: { [weak self] (code, msg, ret) in
            self?.headView.attentionBtn.forceDown(false)
            if code == 0 {
                self?.isCollect = collect
            } else {
                ws?.headView.changeLikeImage(!collect)
                ws?.headView.changeCollectionCount(collection: collect, success: false)
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            self?.headView.attentionBtn.forceDown(false)
            self?.headView.changeLikeImage(!collect)
            ws?.headView.changeCollectionCount(collection: collect, success: false)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionTiltleArr = ["","基本信息","相关产品","融资(\(financingArr.count))","并购(\(mergerArr.count))","联系方式","相关新闻"]
        tableViewType = .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = mainBgGray
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
        //获取关注状态
        checkOrLoadCollect()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNav()
    }
    
    //MARK:UITableviewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTiltleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 { //详情
            return 1
        }
        if section == 1 {//基本信息
            
            return 1
        }
        if section == 2 {
            return 1
        }
        if section==3 {//融资
            return financingArr.count
        }
        if section==4 {//并购
            return mergerArr.count
        }
        if section==5 {//联系方式
            return min(SafeUnwarp(contactArr.count, holderForNull: 0), 1)
        }
        if section == 6 {
            return relevantNewsArr.count
        }
        return 2
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
        
        if indexPath.section==1 && indexPath.row==0{//基本信息
            let identity = "baseInfoCell"
            let cell = EnterpriseBaseInfoCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = viewModel
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            cell.respondUrl = { [unowned self] url in
                let vc = CommonWebViewController()
                vc.title = "企业网站"
                vc.url = url
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        if indexPath.section==2{//相关产品
            let identity = "product"
            let cell = ProductCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = viewModel
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            return cell
        }
        
        if indexPath.section==3 {//融资
            let identity = "financingCell"
            let cell = EnterpriseFinancingCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = financingArr[indexPath.row]
            cell.cellWidth = self.view.frame.size.width
            cell.enterPriseId = viewModel.model.id
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section==4{//并购
            let identity = "mergerCell"
            let cell = EnterpriseMergerCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = mergerArr[indexPath.row]
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            cell.enterPriseId = viewModel.model.id
            return cell
        }
        if indexPath.section == 5 {//联系方式
            let identity = "contactCell"
            let cell = ContactCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = contactArr[indexPath.row]
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            cell.viewController = self
            return cell
        }
        if indexPath.section == 6 {//新闻
            let identity = "newsCell"
            var cell:NewsCell?
            cell = tableView.dequeueReusableCell(withIdentifier:identity) as? NewsCell
            if cell == nil {
               cell = NewsCell(style: .default, reuseIdentifier: identity)
            }
            cell?.news = relevantNewsArr[indexPath.row]
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return unfoldModel.cellHeight!
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                return viewModel.baseInforCellHeight!
            }
            if indexPath.row == 3 {
                return 84
            }
        }
        if indexPath.section == 2 {
            return viewModel.productCellHeight!
        }
        if indexPath.section == 3 {//融资
            return financingArr[indexPath.row].cellHeight!
        }
        if indexPath.section == 4 {//并购
            return mergerArr[indexPath.row].cellHeight!
        }
        if indexPath.section == 5 {//联系方式
            return contactArr[indexPath.row].cellHeight!
        }
        if indexPath.section == 6 {
            return NewsCell.cellHeight()
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001
        }
        if section == 2 && viewModel.model.products == nil{//融资
            return 0.0001
        }
        if section == 3 && financingArr.count == 0{//融资
            return 0.0001
        }
        if section == 4 && mergerArr.count == 0{//并购
            return 0.0001
        }
        if section == 5 && contactArr.count == 0{//联系方式
            return 0.0001
        }
        if section == 6 && relevantNewsArr.count == 0{//相关新闻
            return 0.0001
        }
        return 35
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 && viewModel.model.products == nil{//融资
            return 0.0001
        }
        if section == 3 && financingArr.count == 0{//融资
            return 0.0001
        }
        if section == 4 && mergerArr.count == 0{//并购
            return 0.0001
        }
        if section == 5 && contactArr.count == 0{//联系方式
            return 0.0001
        }
        if section == 6 && relevantNewsArr.count == 0{//相关新闻
            return 0.0001
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        if section == 2 && viewModel.model.products == nil{//融资
            return nil
        }
        if section == 3 && financingArr.count == 0{//融资
            return nil
        }
        if section == 4 && mergerArr.count == 0{//并购
            return nil
        }
        if section == 5 && contactArr.count == 0{//联系方式
            return nil
        }
        if section == 6 && relevantNewsArr.count == 0{//相关新闻
            return nil
        }
        let view   = UIView()
        view.backgroundColor = UIColor.white
        let label = LineLabel()
        label.widthGap = 8
        view.addSubview(label)
        label.text = sectionTiltleArr[section]
        label.mainColor = mainBlueColor
        label.frame = CGRect(x: leftStartX, y: 35-label.frame.size.height, width: self.view.frame.size.width-40,height: label.frame.size.height)
        label.lineView.frame = CGRect(x: 0, y: 2, width: 2, height: 12)
        if section == 5 && SafeUnwarp(contactArr.count, holderForNull: 0) > 1 {
            let arrow = ImageView()
            arrow.image = UIImage(named: "iconListMore")
            arrow.frame = CGRect(x: self.view.frame.width - leftStartX - 15, y: 17, width: 15, height: 15)
            view.addSubview(arrow)
            let btn = ButtonBack()
            btn.norBgColor = UIColor.clear
            btn.dowBgColor = UIColor.clear
            btn.signal_event_touchUpInside.head({ [unowned self] (signal) in
                let vc = ContactListViewController()
                vc.contactArr = self.contactArr
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            btn.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 35)
            view.addSubview(btn)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = mainBgGray
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {//融资
            let model = self.financingArr[indexPath.row]
            let vc = FinancingDetailViewController()
            if model.model.eventId != nil {
                vc.id = (model.model.eventId)!
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 4 {//并购
            let model = self.mergerArr[indexPath.row]
            let vc = MergerDetailViewController()
            if model.model.eventId != nil {
                vc.id = (model.model.eventId)!
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 6 {//相关新闻
            let news = relevantNewsArr[indexPath.row]
            let vc = NewsDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.news = news
            self.navigationController?.pushViewController(vc, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    //MARK:scrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customNavView.title = "企业详情"
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }
}





