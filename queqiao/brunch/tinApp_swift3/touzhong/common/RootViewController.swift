//
//  RootViewController.swift
//  NewProject
//
//  Created by Zerlinda on 16/5/18.
//  Copyright © 2016年 Zerlinda. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // 重写这两个方法以在界面加载完成后执行操作
    func onFirstWillAppear() { }
    func onFirstAppear() { }

    var statusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return statusBarStyle
    }
    
    private(set) var isShowingNow: Bool = false
    
    func clearFirstInStatus() {
        isFirstWillAppear = true
        isFirstAppear = true
    }
    
    fileprivate var isFirstWillAppear = true
    // 默认进入视图的时候，导航条是白色的，如果要改变，重写此方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstWillAppear {
            onFirstWillAppear()
            isFirstWillAppear = false
        }
    }
    fileprivate var isFirstAppear = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MTA.trackPageViewBegin(self.navigationItem.title==nil ? "":self.navigationItem.title)
        if isFirstAppear {
            onFirstAppear()
            isFirstAppear = false
        }
        isShowingNow = true
        if let s = self as? UIGestureRecognizerDelegate {
            navigationController?.interactivePopGestureRecognizer?.delegate = s
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowingNow = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        MTA.trackPageViewEnd(self.navigationItem.title==nil ? "":self.navigationItem.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ChangeModel.changeControllerModelColor()
//        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
//        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
//        let bgImage = UIImage(named: "navigationBg")
//        self.navigationController?.navigationBar.setBackgroundImage(bgImage!, forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = bgImage
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        /// 改变夜间模式的通知
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(RootViewController.changeModel), name: NSNotification.Name(rawValue: "changeModel"), object: nil);
    }
    func changeModel(){
        self.view.backgroundColor = ChangeModel.changeControllerModelColor()
        
    }

    deinit {
        print("deinit:\(self)")
    }

    lazy var customNavView: CustomNavView = {
        let one = CustomNavView()
        return one
    }()
    func setupCustomNav() {
        view.addSubview(customNavView)
        customNavView.changeAlpha(0)
        customNavView.IN(view).LEFT.RIGHT.TOP.HEIGHT(customNavView.viewHeight).MAKE()
    }
    func hideNav() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func showNav() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    /**
     创建导航栏左边的按钮
     
     - author: zerlinda
     - date: 16-08-15 15:08:10
     
     - parameter images:   图片数组
     - parameter selector: 方法数组
     */
    func createLeftNavigateItems(_ images:[String],selector:[Selector]){
        var i : Int = 0
        var leftItemArrs : [UIBarButtonItem] = [UIBarButtonItem]()
        for imageStr in images{
            let image = UIImage(named: imageStr)
            let leftButton = UIButton(type: UIButtonType.custom)
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
            leftButton.setImage(image, for: UIControlState())
            leftButton.setImage(image, for: UIControlState.highlighted)
            leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 10)
            leftButton.addTarget(self, action: selector[i], for: UIControlEvents.touchUpInside)
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
            view.addSubview(leftButton)
            let leftItem = UIBarButtonItem(customView: view)
            leftItemArrs.append(leftItem)
            i+=0
        }
        self.navigationItem.leftBarButtonItems = leftItemArrs
    }
    /**
     创建右边导航
     
     - author: zerlinda
     - date: 16-08-15 15:08:34
     
     - parameter images:         图片
     - parameter selector:       方法
     - parameter navigationItem: 默认创建在当前的导航栏上面
     */
    
    func createRightNavigateItems(_ images:[String],selector:[Selector],navigationItem:UINavigationItem?=nil){
        var i : Int = 0
        var rightItemArrs : [UIBarButtonItem] = [UIBarButtonItem]()
        for imageStr in images{
            let image = UIImage(named: imageStr)
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
            rightButton.setImage(image, for: UIControlState())
            rightButton.imageEdgeInsets = UIEdgeInsetsMake(12, 10, 12, 0)
            rightButton.addTarget(self, action: selector[i], for: UIControlEvents.touchUpInside)
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
            view.addSubview(rightButton)
            let rightItem = UIBarButtonItem(customView: view)
            rightItemArrs.append(rightItem)
            i+=1
        }
        if navigationItem==nil{
            
            self.navigationItem.rightBarButtonItems = rightItemArrs
            
        }else{
            
            navigationItem!.rightBarButtonItems = rightItemArrs
            
        }
        
    }
    //MARK:让用户去认证
    func remindCertification(){
        
        if Account.sharedOne.user.author ==  .isAuthed{
            return//认证成功可以直接查看
        }
        var str = "用户尚未认证，马上认证？"
        if Account.sharedOne.user.author ==  .progressing{
            str = "用户正在认证中，请耐心等待"
        }
        let alertController = UIAlertController(title: "提示",
                                                message: str, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "认证", style: .default, handler: {
            action in
            debugPrint("点击了确定")
            self.tabBarController?.selectedIndex = 4
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}

extension UIViewController {
    
    func removeLeftNavItems() {
        _removeNavItems(left: true)
    }
    func setupLeftNavItems(items: UIBarButtonItem?...) {
        var _items = [UIBarButtonItem]()
        for item in items {
            if let item = item {
                _items.append(item)
            }
        }
        if _items.count > 0 {
            _setupNavItems(left: true, items: _items)
        } else {
            _removeNavItems(left: true)
        }
    }
    func removeRightNavItems() {
        _removeNavItems(left: false)
    }
    func setupRightNavItems(items: UIBarButtonItem?...) {
        var _items = [UIBarButtonItem]()
        for item in items {
            if let item = item {
                _items.append(item)
            }
        }
        if _items.count > 0 {
            _setupNavItems(left: false, items: _items)
        } else {
            _removeNavItems(left: false)
        }
    }
    
    private func _removeNavItems(left: Bool) {
        if left {
            navigationItem.leftBarButtonItems = nil
        } else {
            navigationItem.rightBarButtonItems = nil
        }
    }
    private func _setupNavItems(left: Bool, items: [UIBarButtonItem]) {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -15
        var _items = [UIBarButtonItem]()
        _items.append(space)
        _items += items
        if left {
            navigationItem.leftBarButtonItems = _items
        } else {
            navigationItem.rightBarButtonItems = _items
        }
    }
    
    /// 设置返回按钮(没有返回操作，默认直接返回)
    func setupNavBackBlackButton(_ handler: (() -> ())?) {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -15
        let item = BarButtonItem(iconName: "iconTopBackBlack", responder: { [unowned self] in
            if let handler = handler {
                handler()
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
        navigationItem.leftBarButtonItems = [space, item]
    }
    
    /// 设置返回按钮(没有返回操作，默认直接返回)
    func setupNavBackWhiteButton(_ handler: (() -> ())?) {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -15
        let item = BarButtonItem(iconName: "iconTopBackWhite", responder: { [unowned self] in
            if let handler = handler {
                handler()
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        })
        navigationItem.leftBarButtonItems = [space, item]
    }
    
    //    /// 设置导航栏的透明度 0-1 (0 表示透明， 1表示白色)，当透明度大于0.9的时候，有下划线
    //    func setNavigationAlpha1(_ alpha: CGFloat) {
    //        let color = UIColor(white: 1, alpha: alpha)
    //        let image = UIImage.image(CGSize(width: 1, height: 1), color: color)
    //        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    //        if alpha > 0.9 {
    //            navigationController?.navigationBar.shadowImage = UIImage.image(CGSize(width: kScreenW, height: 0.1), color: UIColor.black)
    //        } else {
    //            navigationController?.navigationBar.shadowImage = UIImage.image(CGSize(width: kScreenW, height: 0.1), color: UIColor.clear)
    //        }
    //    }
        /// 设置导航栏的透明度 0-1 (0 表示透明， 1表示白色)，当透明度大于0.9的时候，有下划线
    func setNavigationColor(_ color: UIColor,aimated:Bool,duration:TimeInterval) {
            //let alpha = 0
            let image = UIImage.image(CGSize(width: 1, height: 1), color: color)
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        
//            if alpha > 0.9 {
//                navigationController?.navigationBar.shadowImage = UIImage.image(CGSize(width: kScreenW, height: 0.1), color: UIColor.black)
//            } else {
//                navigationController?.navigationBar.shadowImage = UIImage.image(CGSize(width: kScreenW, height: 0.1), color: UIColor.clear)
//            }
        }
 
}


// MARK: - UIViewControllerTransitioningDelegate
extension RootViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimate = PresentingAnimator()
        presentAnimate.originFrame = CGRect.zero
        presentAnimate.finalFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height+64)
        return presentAnimate
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimator = DismissAnimator()
        dismissAnimator.finalFrame = CGRect.zero
        return dismissAnimator
    }
}

extension RootViewController {

    func confirmToLoginVc(comeFromVc: UIViewController?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self] in
            Confirmer.show("提示", message: "登陆信息失效, 是否去登陆？", confirmHandler: { [weak self] in
                self?.push2ToLoginVc(comeFromVc: comeFromVc)
                }, inVc: self)
        }
    }
    
    func push2ToLoginVc(comeFromVc: UIViewController?) {
        let vc = ToLoginViewController()
        vc.comeFromVc = comeFromVc
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


