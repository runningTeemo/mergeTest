//
//  DataViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/8/31.
//  Copyright © 2016年 zerlinda. All rights reserved.
//


import UIKit

class DataViewController: RootViewController {
    
    var topScroll:QXYTitleScrollView = QXYTitleScrollView()
    var filterVC = DataFilterController()
    var advanceT:AdvanceType = .invest{
        didSet{
            filterVC.advanceT = advanceT
        }
    }
    var homeV:HomeView = HomeView()
    var chartView: UIView {
        return chartVC.view
    }
    var selectIndex:Int = 0{
        didSet{
            seg.selectedSegmentIndex = 0
            homeV.alpha = 1
            chartView.alpha = 0
            selectTopBtn(selectIndex)
        }
    }
    var filtDataDic:[String:AnyObject] = [String:AnyObject]()
    var vcArr:[CommonDataListViewController] = [CommonDataListViewController]()
    var selectShowDic:[String:AnyObject]?
    var selectShowDicArr:[[String:AnyObject]]?
    var seg:UISegmentedControl = UISegmentedControl()
    var loaded:Bool = false//是否是第一次加载，默认是第一次加载
//    lazy var chartVC:DataSummariseViewController = {
//        let vc = DataSummariseViewController()//图表
//        vc.view.alpha = 0
//        return vc
//    }()
    
    lazy var chartVC:QxyViewController = {
        let vc = QxyViewController()//图表
        vc.view.alpha = 0
        return vc
    }()
    lazy var loginView: ToLoginView = {
        let one = ToLoginView()
        weak var ws = self
        one.respondLogin = {
            let vc = LoginViewController()
            vc.responceAfterLogin = {
                let vc = ws?.vcArr[(ws?.selectIndex)!]
                vc?.getData(false)
            }
            vc.showRegistOnAppear = false
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondRegist = {
            let vc = LoginViewController()
            vc.responceAfterLogin = {
                let vc = ws?.vcArr[(ws?.selectIndex)!]
                vc?.getData(false)
            }
            vc.showRegistOnAppear = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    ///创建高级搜索
    lazy var searchNavItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconNewsSearch", responder: { [unowned self] in
            self.search()
        })
        return one
    }()
    
    ///创建筛选
    lazy var filterNavItem: BarButtonItem = {
        let one = BarButtonItem(iconName: "iconTopFilter", responder: { [unowned self] in
            self.filter()
        })
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        createView()
        createTitleLabel()
        createLeftNaviItem()
        createRightNavItem()
        addChildVC()
        removeLeftNavItems()
        selectShowDicArr = [[String:AnyObject]]()
        for _ in 0..<vcArr.count {
            let dic = [String:AnyObject]()
            selectShowDicArr?.append(dic)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
        selectTopBtn(selectIndex)
        view.addSubview(loginView)
        if Account.sharedOne.isLogin{
            loginView.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.statusBarStyle = .default
            self.setNeedsStatusBarAppearanceUpdate()
        }else{
            loginView.isHidden = false
            self.navigationController?.isNavigationBarHidden = true
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
        }
        loginView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height+20)
    }
    //MARK:验签失败
    func codeSignErr(){
        for vc in vcArr{
            weak var ws = self
            vc.codeSignError = {
                ws?.loginView.isHidden = false
                ws?.navigationController?.isNavigationBarHidden = true
                Account.sharedOne.logout()
            }
        }
    }
    //MARK:创建页面
    func createView(){
        let titles:[String] = ["融资","并购","退出","机构","企业","人物"]
        let fvc = FinancingViewController()
        let mergerVC = MergerViewController()
        let exitEventVC = ExitEventViewController()
        let personageVC = PersonageViewController()
        let institutionVC = InstitutionViewController()
        let enterpriseVC = EnterpriseViewController()
        vcArr = [fvc,mergerVC,exitEventVC,institutionVC,enterpriseVC,personageVC]
        codeSignErr()//给每个列表加上验签错误判断
        homeV.titles = titles
        homeV.viewArr = vcArr
        homeV.topBigRGB = (R: CGFloat(51)/CGFloat(255), G: CGFloat(51)/CGFloat(255), B: CGFloat(51)/CGFloat(255))
        homeV.topSmallRGB = (R: CGFloat(102)/CGFloat(255), G: CGFloat(102)/CGFloat(255), B: CGFloat(102)/CGFloat(255))
        homeV.toplabelLineColor = MyColor.colorWithHexString("d61f26")
        homeV.backgroundColor = UIColor.white
        self.view.addSubview(homeV)
        homeV.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        homeV.updateFrame()
        weak var ws = self
        homeV.titleClickIndex = { index in
            print("你点击了\(index)")
            ws?.selectIndex = index
            ws?.createLeftNaviItem()
        }
        chartView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.frame.height)
        view.addSubview(chartView)
        view.bringSubview(toFront: chartView)
        homeV.alpha = 1
        chartView.alpha = 0
        removeLeftNavItems()
    }
    //添加子vc
    func addChildVC(){
        for vc:UIViewController in vcArr {
            self.addChildViewController(vc)
        }
        self.addChildViewController(chartVC)
    }
    
    func createLeftNaviItem(){
        if self.selectIndex < self.vcArr.count - 1 && seg.selectedSegmentIndex == 0{
            let arr = ["invest","merge","exit","institution","enterprise","personage"]
            let advanceType = AdvanceType(rawValue: arr[self.selectIndex])
            if advanceType != nil {
                self.advanceT = advanceType!
            }
            setupLeftNavItems(items: filterNavItem)
        }else{
            removeLeftNavItems()
        }
    }
    
    func createRightNavItem(){
        setupRightNavItems(items: searchNavItem)
        //createRightNavigateItems(["iconNewsSearch"], selector: [ #selector(DataViewController.search)])
    }
    func createTitleLabel(){
        let items = ["数据","图表"]
        seg = UISegmentedControl(items: items)
        seg.frame = CGRect(x: 0, y: 7, width: 100, height: 30)
        seg.addTarget(self, action: #selector(DataViewController.segChange(seg:)), for: UIControlEvents.valueChanged)
        seg.selectedSegmentIndex = 0
        seg.tintColor = MyColor.colorWithHexString("#9d9da4")
        seg.setTitleTextAttributes([NSForegroundColorAttributeName:MyColor.colorWithHexString("#999999")], for: UIControlState.normal)
        seg.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13)], for: UIControlState.selected)
        
        seg.layer.borderColor = MyColor.colorWithHexString("#dcdcdc").cgColor
        seg.layer.borderWidth = 1
        seg.layer.cornerRadius = 5
        seg.layer.masksToBounds = true
        
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        v.addSubview(seg)
        self.navigationItem.titleView = v
    }
    //MARK:Action
    func selectTopBtn(_ index:Int){
        
        homeV.selectIndex = index
        homeV.selectTopBtn(index)
        if index == 5 {
            removeLeftNavItems()
        } else {
            setupLeftNavItems(items: filterNavItem)
        }
        //        if !loaded {
        //            seg.selectedSegmentIndex = 0
        //        }else{
        //            seg.selectedSegmentIndex = 1
        //            homeV.alpha = 0
        //            chartView.alpha = 1
        //            view.bringSubview(toFront: homeV)
        //        }
        //        loaded = true
    }
    
    func filter(){
        filterVC = DataFilterController()
        filterVC.selectShowDic = SafeUnwarp(selectShowDicArr?[selectIndex], holderForNull: [String:AnyObject]())
        weak var ws = self
        filterVC.getFiltData = { dic in
            let vc = ws?.vcArr[(ws?.selectIndex)!]
            vc?.filtDataDic = dic
        }
        filterVC.rememberFiltData = {dic in
           // ws?.selectShowDic = dic
            ws?.selectShowDicArr?[(ws?.selectIndex)!] = dic
        }
        filterVC.modalPresentationStyle = .custom
        filterVC.transitioningDelegate = self
        filterVC.widthProportion = 0.8
        filterVC.entranceDirection = .left
        filterVC.advanceT = self.advanceT
        self.present(filterVC, animated: true, completion: nil)
    }
    func search() {
        let vc = MainSearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func segChange(seg:UISegmentedControl){
        let index = seg.selectedSegmentIndex
        changeViewFrame(index: index)
        
        createLeftNaviItem()
    }
    
    func changeViewFrame(index:Int){
        seg.selectedSegmentIndex = index
        weak var ws = self
        if index == 1 {
            homeV.alpha = 1
            chartView.alpha = 0
            removeLeftNavItems()
            view.bringSubview(toFront: chartView)
            UIView.animate(withDuration: 0.3, animations: {
                ws?.chartView.alpha = 1
            }, completion: { comlete in
                ws?.homeV.alpha = 0
            })
        }else{
            homeV.alpha = 0
            chartView.alpha = 1
            setupLeftNavItems(items: filterNavItem)
            view.bringSubview(toFront: homeV)
            UIView.animate(withDuration: 0.3, animations: {
                ws?.homeV.alpha = 1
            }, completion: { comlete in
                ws?.chartView.alpha = 0
            })
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            if index == 1{
                ws?.chartView.alpha = 1
                ws?.homeV.alpha = 0
            }else{
                ws?.homeV.alpha = 1
                ws?.chartView.alpha = 0
            }
        }
        
    }
    
    func performLogout() {
        clearFiltInfo()
        selectIndex = 0
        if vcArr.count>0{
         let vc = vcArr[selectIndex];
         vc.getData(false)
        }
    }
    
    func clearFiltInfo(){
        selectShowDic = [String:AnyObject]()
        selectShowDicArr = [[String:AnyObject]]()
        for _ in 0..<vcArr.count {
            let dic = [String:AnyObject]()
            selectShowDicArr?.append(dic)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
