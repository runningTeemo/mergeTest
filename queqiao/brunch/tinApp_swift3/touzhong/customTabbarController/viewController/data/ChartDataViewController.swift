//
//  ChartViewController.swift
//  touzhong
//
//  Created by zerlinda on 2016/12/29.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ChartDataViewController: QXYRootTableViewController,UIScrollViewDelegate {
    
    var topScroll:QXYTitleScrollView = QXYTitleScrollView()
    var offSetY:CGFloat = 0{
        didSet{
            for vc in vcArr {
                if offSetY>0{
                    vc.allowSlide = false
                }else{
                   vc.allowSlide = true
                }
            }
        }
    }
    var filterVC = DataFilterController()
    var advanceT:AdvanceType = .invest{
        didSet{
            filterVC.advanceT = advanceT
        }
    }
    var homeV:HomeView = HomeView()
    var selectIndex:Int = 0{
        didSet{
            selectTopBtn(selectIndex)
        }
    }
    var filtDataDic:[String:AnyObject] = [String:AnyObject]()
    var vcArr:[CommonDataListViewController] = [CommonDataListViewController]()
    var mainScrollView:UIScrollView = UIScrollView()
    
    /// 登录页面，当验签失败的时候 跳转登录
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
        title = "数据"
        createMainContent()
        createLeftNaviItem()
        createRightNavItem()
        addChildVC()
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
            // hideNav()
            loginView.isHidden = false
            self.navigationController?.isNavigationBarHidden = true
            self.statusBarStyle = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
        }
        loginView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height+20)
    }
    
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
    // MARK:创建主界面
    func createMainContent(){
        view.addSubview(mainScrollView)
        mainScrollView.tag = 100
        mainScrollView.frame = view.frame
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 150)
        mainScrollView.backgroundColor = UIColor.red
        mainScrollView.delegate = self
        createTopScroll()
        mainScrollView.addSubview(homeV)
        homeV.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: self.view.frame.height)
        homeV.updateFrame()
       
    }
    
    // MARK:创建homeV
    func createTopScroll(){
        let titles:[String] = ["融资","并购","退出","机构","企业","人物"]
        let fvc = FinancingViewController()
        let mergerVC = MergerViewController()
        let exitEventVC = ExitEventViewController()
        let personageVC = PersonageViewController()
        let institutionVC = InstitutionViewController()
        let enterpriseVC = EnterpriseViewController()
        vcArr = [fvc,mergerVC,exitEventVC,institutionVC,enterpriseVC,personageVC]
        codeSignErr()//给每个列表加上验签错误判断
        homeV.backgroundColor = UIColor.white
        homeV.titles = titles
        homeV.viewArr = vcArr
        homeV.topBigRGB = (R: CGFloat(51)/CGFloat(255), G: CGFloat(51)/CGFloat(255), B: CGFloat(51)/CGFloat(255))
        homeV.topSmallRGB = (R: CGFloat(102)/CGFloat(255), G: CGFloat(102)/CGFloat(255), B: CGFloat(102)/CGFloat(255))
        homeV.toplabelLineColor = MyColor.colorWithHexString("d61f26")
        weak var ws = self
        homeV.titleClickIndex = { index in
            print("你点击了\(index)")
            ws?.selectIndex = index
            ws?.createLeftNaviItem()
        }
    }
    //添加子vc
    func addChildVC(){
        for vc:UIViewController in vcArr {
            self.addChildViewController(vc)
        }
    }

    func createLeftNaviItem(){
        if self.selectIndex < self.vcArr.count - 1 {
            let arr = ["invest","merge","exit","institution","enterprise","personage"]
            let advanceType = AdvanceType(rawValue: arr[self.selectIndex])
            if advanceType != nil {
                self.advanceT = advanceType!
            }
            setupLeftNavItems(items: filterNavItem)
            //createLeftNavigateItems(["iconTopFilter"], selector: [ #selector(DataViewController.filter)])
        }else{
            removeLeftNavItems()
        }
    }

    func createRightNavItem(){
        
        setupRightNavItems(items: searchNavItem)
        //createRightNavigateItems(["iconNewsSearch"], selector: [ #selector(DataViewController.search)])
    }
    
    func selectTopBtn(_ index:Int){
        homeV.selectIndex = index
        homeV.selectTopBtn(index)
    }
    //筛选
    func filter(){
        filterVC = DataFilterController()
        filterVC.selectDic = filtDataDic
        weak var ws = self
        filterVC.getFiltData = { dic in
            let vc = ws?.vcArr[(ws?.selectIndex)!]
            vc?.filtDataDic = dic
            ws?.filtDataDic = dic
        }
        filterVC.modalPresentationStyle = .custom
        filterVC.transitioningDelegate = self
        filterVC.widthProportion = 0.8
        filterVC.entranceDirection = .left
        filterVC.advanceT = self.advanceT
        self.present(filterVC, animated: true, completion: nil)
    }
    //搜索
    func search() {
        let vc = MainSearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.tag)
        print(scrollView.contentOffset.y)
        offSetY = scrollView.contentOffset.y
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
