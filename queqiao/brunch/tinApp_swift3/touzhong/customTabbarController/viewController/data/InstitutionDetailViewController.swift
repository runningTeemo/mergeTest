//
//  InstitutionDetailViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/17.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class InstitutionDetailViewController: CommonDataDetailViewController,UITableViewDelegate,UITableViewDataSource {

    lazy var headView: InstitutionDetailHeadView = {
        let one = InstitutionDetailHeadView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW, height: one.viewHeight)
        one.respondCollect = { [unowned self] in
            self.handleCollect()
        }
        return one
    }()
    var id:String = "" {
        didSet{
            self.getData(false)
        }
    }
    var headViewHidden:[Bool] = [Bool]()
    
    var sectionTiltleArr:[String] = [String]()
    var unfoldModel:DetailViewModel = DetailViewModel()

    
    /// viewmodel赋值
    var viewModel:InstitutionViewModel = InstitutionViewModel(){
        didSet{
            headView.model = viewModel.model
            weak var ws = self
            headView.segView.respondInvestEvents = {//融资事件
                if Account.sharedOne.user.author ==  .isAuthed{
                    let vc = FinancingViewController()
                    vc.id = ws?.viewModel.model.id
                    vc.tableViewFrame = true
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    ws?.remindCertification()
                }
            
            }
            headView.segView.respondExsitEvents = {//退出事件
                if Account.sharedOne.user.author ==  .isAuthed{
                    let vc = ExitEventViewController()
                    vc.id = ws?.viewModel.model.id
                    vc.tableViewFrame = true
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    ws?.remindCertification()
                }
            }
            headView.segView.respondAnalyze = { [unowned self] in
                if Account.sharedOne.user.author ==  .isAuthed{
                    let vc = InstitutionChartViewController()
                    vc.id = self.viewModel.model.id
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    ws?.remindCertification()
                }
            }
            
            unfoldModel.showStr = viewModel.model.desc
            personageArr = [PersonageViewModel]()
            if viewModel.model.users != nil{
                var personageA:[PersonageViewModel] = [PersonageViewModel]()
                for model in viewModel.model.users! {
                    let viewModel = PersonageViewModel()
                    viewModel.model = model
                    personageA.append(viewModel)
                }
                personageArr = personageA
            }
            if viewModel.model.funds != nil {
                var fundA:[Funds]? = [Funds]()
                for i in 0..<viewModel.model.funds!.count{
                    fundA?.append(viewModel.model.funds![i])
                }
                fundsArr = fundA
                sectionTiltleArr = ["","团队成员","基本信息","投资领域","管理基金(\(SafeUnwarp(viewModel.model.funds!.count, holderForNull: 0)))","联系方式","相关新闻"]
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
            tableView?.reloadData()
            DispatchQueue.global(qos: .default).async {
                ws?.getRelevantNews()
            }
        }
    }

    var personageArr:[PersonageViewModel] = [PersonageViewModel]()
    var fundsArr:[Funds]? = [Funds]()
    var contactArr:[ContactViewModel] = [ContactViewModel]()
    var relevantNewsArr:[News] = [News]()
    var isCollect: Bool = false
    var setNeedsUpdateCollect = true

    
    //MARK:收藏
    func checkOrLoadCollect() {
        
        if !Account.sharedOne.isLogin { return }
        
        if !setNeedsUpdateCollect { return }
       
        let me = Account.sharedOne.user
        headView.attentionBtn.forceDown(true)
        
        MyselfManager.shareInstance.checkCollect(user: me, id: id, type: .institution, success: { [weak self] (code, msg, ret) in
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
        collection.type = .institution
        
        collection.targetId = "\(SafeUnwarp(model.id, holderForNull: ""))"
        collection.targetUrl = model.webSite
        if let name = model.shortCnName {
            collection.targetContent = name
        } else if let name = model.cnName {
            collection.targetContent = name
        } else if let name = model.enName {
            collection.targetContent = name
        }
        collection.targetImage = model.logoUrl
        collection.targetDescri = model.desc
        
        headView.attentionBtn.forceDown(true)
        headView.changeLikeImage(collect)
        headView.changeCollectionCount(collection: collect, success: true)
        weak var ws = self
        MyselfManager.shareInstance.collect(user: me, collect: collect, collection: collection, success: { [weak self] (code, msg, ret) in
            ws?.headView.attentionBtn.forceDown(false)
            if code == 0 {
                self?.isCollect = collect
            } else {
                ws?.headView.changeLikeImage(!collect)
                ws?.headView.changeCollectionCount(collection: collect, success: true)
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
        }) { [weak self] (error) in
            ws?.headView.attentionBtn.forceDown(false)
            ws?.headView.changeLikeImage(!collect)
            ws?.headView.changeCollectionCount(collection: collect, success: true)
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }

    }
    
    //MARK:获取数据
    /**
     获取数据
     
     - author: zerlinda
     - date: 16-09-28 14:09:36
     - parameter isFooterRefresh: <#isFooterRefresh description#>
     */
    override func getData(_ isFooterRefresh: Bool) {
        weak var ws = self
        if noData {
            return
        }
        DataListManager.shareInstance.geteInstitutionDetail(self.id, success: { (code, message, data) in
            if code == 0 {
                
                ws?.endRefresh(.done, view: nil, message: nil)
                ws?.viewModel = data!
            }else if code == SIGNERRORCODE{
                ws?.codesignError()
            }else{
                ws?.endRefresh(.doneErr, view: self.view, message: message+"\(code)")
            }
            
        }) { (error) in
             ws?.endRefresh(.doneErr, view: self.view, message: kWebErrMsg+"\(error.code)")
        }
        
    }
    
    
    /// 获取相关新闻
    func getRelevantNews(){
        weak var ws = self
        NewsManager.shareInstance.getRelevantNews(shortCnName: viewModel.model.shortCnName, cnName: viewModel.model.cnName, category: .institution,success: { (code, message, data) in
            if code == 0{
                ws?.getNewsSuccess(dataArr: data)
            }
        }) { (error) in
            debugPrint(error)
        }
    }
    
    /// 相关新闻获取成功后 回到主线程刷新界面
    ///
    /// - Parameter dataArr: 相关新闻模型数组
    func getNewsSuccess(dataArr:[News]?){
        relevantNewsArr = SafeUnwarp(dataArr, holderForNull: [News]())
        weak var ws = self
        let count  = relevantNewsArr.count
        let countStr = count == 0 ? "" : "\(count)"
        sectionTiltleArr = ["","团队成员","基本信息","投资领域","管理基金(\(SafeUnwarp(ws?.viewModel.model.funds?.count, holderForNull: 0)))","联系方式","相关新闻("+countStr+")"]
        DispatchQueue.main.async {
            
            ws?.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTiltleArr = ["","团队成员","基本信息","投资领域","管理基金","联系方式","相关新闻"]
        tableView.removeFromSuperview()
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
        checkOrLoadCollect()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNav()
    }
    
    //MARK:TableviewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTiltleArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 { //详情
            return 1
        }
        if section==1 {//团队成员
            return 1
        }
        if section==2 {//基本信息
            return 1
        }
        if section==3 {//所属行业
            return 1
        }
        if section==4 {//管理基金
            return min(SafeUnwarp(fundsArr?.count, holderForNull: 0), 5)
        }
        if section==5 {//联系方式
            return min(SafeUnwarp(contactArr.count, holderForNull: 0), 1)
        }
        if section==6 {//相关新闻
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
        if indexPath.section == 1 {//团队成员
            weak var ws = self
            let identity = "institutionCell"
            let cell = InstitutionTeamMumbersCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = self.viewModel
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            cell.tapAction = { [unowned self] userId in
                if Account.sharedOne.user.author ==  .isAuthed{
                    let vc = PersonageDetailViewController()
                    vc.id = userId
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    ws?.remindCertification()
                }
            }
            return cell
        }
        if indexPath.section==2 {//基本信息
            let identity = "institutionCell"
            let cell = InstitutionBaseInfoCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = self.viewModel
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            cell.respondUrl = { [unowned self] url in
                let vc = CommonWebViewController()
                vc.url = url
                vc.title = "机构网站"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        if indexPath.section==3 {//投资领域
            let identity = "institutionCell"
            let cell = InstitutionBelongCategoryCell(style: .default, reuseIdentifier: identity)
            cell.viewModel = self.viewModel
            cell.cellWidth = self.view.frame.size.width
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section==4 {//管理基金
            let identity = "institutionCell"
            let cell = InstitutionManageFundCell(style: .default, reuseIdentifier: identity)
            cell.indexPath = indexPath
            cell.cellWidth = self.view.frame.size.width
            cell.titleStr = SafeUnwarp(fundsArr![indexPath.row].cnName, holderForNull: "")
            cell.selectionStyle = .none
            cell.cellLine.isHidden = (indexPath.row == min(fundsArr!.count, 5) - 1)
            return cell
        }
        if indexPath.section==5 {//联系方式
            let identity = "institutionCell"
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
          let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return unfoldModel.cellHeight!
        }
        if indexPath.section == 1 {
            return viewModel.teamMembersCellHeght
        }
        if indexPath.section == 2 {
            return viewModel.baseInforCellHeight
        }
        if indexPath.section == 3 {
            return viewModel.belongCategoryHeight
        }
        if indexPath.section == 5 {
           return contactArr[indexPath.row].cellHeight!
        }
        if indexPath.section == 6 {
            return NewsCell.cellHeight()
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0 {
            return 0.0001
        }
        if section==1 && personageArr.count==0 {
            return 0.0001
        }
        if section==3  && viewModel.model.institutionFieldList==nil{//所属行业
            return 0.0001
        }
        if section==4 && fundsArr?.count==0 {//管理基金
            return 0.0001
        }
        if section==5 && contactArr.count==0 {//联系方式
            return 0.0001
        }
        if section==6 && relevantNewsArr.count==0 {//相关新闻
            return 0.0001
        }
        return 35
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section==1 && personageArr.count==0 {
            return 0.0001
        }
        if section==3  && viewModel.model.institutionFieldList==nil{//所属行业
            return 0.0001
        }
        if section==4 && fundsArr?.count==0 {//管理基金
            return 0.0001
        }
        if section==5 && contactArr.count==0 {//联系方式
            return 0.0001
        }
        if section==6 && relevantNewsArr.count==0 {//相关新闻
            return 0.0001
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        if section==1 && personageArr.count==0 {
            return nil
        }
        if section==3  && viewModel.model.institutionFieldList==nil{//所属行业
            return nil
        }
        if section==4 && fundsArr?.count==0 {//管理基金
            return nil
        }
        if section==5 && contactArr.count==0 {//联系方式
            return nil
        }
        if section==6 && relevantNewsArr.count==0 {//相关新闻
            return nil
        }
        let view   = UIView()
        view.backgroundColor = UIColor.white
        let label = LineLabel()
        view.addSubview(label)
        label.widthGap = 8
        label.text = sectionTiltleArr[section]
        label.mainColor = mainBlueColor
        label.frame = CGRect(x: leftStartX, y: 35-label.frame.size.height, width: self.view.frame.size.width-40,height: label.frame.size.height)
        label.lineView.frame = CGRect(x: 0, y: 2, width: 2, height: 12)
        if section == 4 && SafeUnwarp(fundsArr?.count, holderForNull: 0) > 5 {
            let arrow = ImageView()
            arrow.image = UIImage(named: "iconListMore")
            arrow.frame = CGRect(x: self.view.frame.width - leftStartX - 15, y: 17, width: 15, height: 15)
            view.addSubview(arrow)
            let btn = ButtonBack()
            btn.norBgColor = UIColor.clear
            btn.dowBgColor = UIColor.clear
            btn.signal_event_touchUpInside.head({ [unowned self] (signal) in
                let vc = FundsListViewController()
                vc.models = self.fundsArr!
                self.navigationController?.pushViewController(vc, animated: true)
            })
            btn.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 35)
            view.addSubview(btn)
        }
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
    
    
    //MARK:ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customNavView.title = "机构详情"
        customNavView.handleScroll(offsetY: scrollView.contentOffset.y, headHeight: headView.imgH)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        customNavView.handleScrollBegin()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavView.handleScrollEnd()
    }

    
}
