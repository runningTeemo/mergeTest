//
//  MainTabBarController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

protocol LogoutProtocol {
    func performLogout()
    func performLogin()
}

class MainTabBarController: RootTabBarController {
    
    lazy var indexVc: IndexViewController = IndexViewController()
    lazy var newsVc: NewsMainViewController = NewsMainViewController()
    lazy var dataVc: DataViewController = DataViewController()
    lazy var articleVc: ArticleMainViewControler = ArticleMainViewControler()
    lazy var meVc: MeMainViewController = MeMainViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        DataManager.shareInstance.dataVC = dataVc
        
        viewControllers = [
            makeNavRootViewController(indexVc, title: "首页", iconName: "tagHome"),
            makeNavRootViewController(newsVc, title: "资讯", iconName: "tagNews"),
            makeNavRootViewController(dataVc, title: "数据", iconName: "tagData"),
            makeNavRootViewController(articleVc, title: "发现", iconName: "tagCircle"),
            makeNavRootViewController(meVc, title: "我的", iconName: "tagMy"),
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.didRecieveAuthorSuccessNotification), name: kNotificationAuthorSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.didRecieveAuthorFailedNotification), name: kNotificationAuthorFailed, object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.didRecieveLoginInOtherPlaceNotification), name: kNotificationLoginInOtherPlace, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.didRecieveTokenErrorNotification), name: kNotificationTokenErrorFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.didRecieveLoginNotification), name: kNotificationLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.didRecieveLogoutNotification), name: kNotificationLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.reciveMessage), name: ReciveMessage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTabBarController.reciveReplyApplyCheck(notification:)), name: replyApplyCheck, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reciveMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// 收到推送消息
    func reciveMessage(){
        if Account.sharedOne.amountBadge>0 {
            tabBar.showBadge(idx: 3)
        }else{
            tabBar.removeBadge(idx: 3)
        }
    }
    
    func didRecieveAuthorSuccessNotification() {
        tabBar.showBadge(idx: 4)
        meVc.setNeedsUpdate()
    }
    func didRecieveAuthorFailedNotification() {
        tabBar.showBadge(idx: 4)
        meVc.setNeedsUpdate()
    }
    
    ///处理收到项目申请回复
    func reciveReplyApplyCheck(notification:Notification){
        if let userInfo = notification.userInfo {
            let projectId = userInfo["projectid"]
            if let id = projectId as? String {
                self.selectedIndex = 3
                let article = Article()
                article.id = id
                article.type = .project
                let viewC = ArticleDetailViewControler()
                viewC.orgienArticle = article
                viewC.hidesBottomBarWhenPushed = true
                articleVc.navigationController?.pushViewController(viewC, animated: true)
            }
        }
    }
    
    // 收到异地登陆推送
    func didRecieveLoginInOtherPlaceNotification() {
        if Account.sharedOne.isLogin {
            Account.sharedOne.logout()
            QXTiper.showWarning("异地登陆", inView: UIApplication.shared.keyWindow, cover: true)
        }
    }
    
    // 收到token失效消息
    func didRecieveTokenErrorNotification() {
        if Account.sharedOne.isLogin {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                Account.sharedOne.logout()
                //QXTiper.showWarning("登陆信息失效", inView: UIApplication.shared.keyWindow, cover: true)
            }
        }
    }
    
    // 登陆成功
    func didRecieveLoginNotification() {
        indexVc.performLogin()
        newsVc.performLogin()
        articleVc.performLogin()
        meVc.performLogin()
    }
    
    // 退出登陆
    func didRecieveLogoutNotification() {
        indexVc.performLogout()
        newsVc.performLogout()
        articleVc.performLogout()
        meVc.performLogout()
        dataVc.performLogout()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "我的" {
            tabBar.removeBadge(idx: 4)
        }
    }
    
}
