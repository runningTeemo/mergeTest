//
//  AppDelegate.swift
//  touzhong
//
//  Created by zerlinda on 16/8/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration
import UserNotifications

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,EMChatManagerDelegate{

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        chooseUrl()
        ///注册微信分享
        registerWeixinShare()
        ///腾讯云分析
        MTA.start(withAppkey: "IN6M3UN19GBK");
        registerNotification(application: application)
        registerHuanxin(application: application, didFinishLaunchingWithOptions: launchOptions)
        if Account.sharedOne.loadLocal() {
            ChatManage.shareInstance.getAllUnReadMessage()
            LoginManager.shareInstance.sendLoginLogInBackground()
        }
        
//        setupTest()
//
        if isUpdated() {
            Account.sharedOne.logout()
            setupWelcomeView()
        } else {
            setupMainView()
        }
        
        self.window?.makeKeyAndVisible()
        initCacheInBackground()
        
//        setupFpsTest()

        return true
    }
    
    /// 初始化缓存
    func initCacheInBackground() {
        // 缓存城市数据
        DispatchQueue.global().async {
            _ = LocationDataEntry.sharedOne.allModels
            _ = LocationDataEntry.sharedOne.modelsWithoutChina
            _ = LocationDataEntry.sharedOne.modelsWithoutChinaGroups
            _ = LocationDataEntry.sharedOne.chinaModel
        }
        
        // 缓存首页banner的默认图及模型
        NewsManager.shareInstance.getIndexDefaultBanner(success: { (_, _, banner) in
            if let banner = banner {
                topBannerDefaultBanner = banner
                if let urlStr = banner.picture {
                    if let url = URL(string: urlStr) {
                        SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions(), progress: { (_, _) in
                        }, completed: { (img, _, _, _, _) in
                            if let img = img {
                                topBannerDefaultImage = img
                                do {
                                    let path = PathTool.cache + "/" + kTopBannerDefaultImageName
                                    let url = URL(fileURLWithPath: path)
                                    try UIImagePNGRepresentation(img)?.write(to: url)
                                } catch {
                                }
                            }
                        })
                    }
                }
            }
        }, failed: { err in
        
        })
        
    }
    
    
    let kUserDefaultVersionKey = "userVersionKey"
    func isUpdated() -> Bool {
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            if let savedVersion = UserDefaults.standard.object(forKey: kUserDefaultVersionKey) as? String {
                let fVersion = (version as NSString).floatValue
                let fSavedVersion = (savedVersion as NSString).floatValue
                if fVersion > fSavedVersion {
                    UserDefaults.standard.setValue(version, forKey: kUserDefaultVersionKey)
                    return true
                } else {
                    return false
                }
            } else {
                UserDefaults.standard.setValue(version, forKey: kUserDefaultVersionKey)
                return true
            }
        } else {
            return false
        }
    }
    
    func setupMainView() {
        window!.rootViewController = MainTabBarController()
    }
    func setupWelcomeView() {
        window!.rootViewController = WelcomeViewController()
    }
    func setupTest() {
        
//        let tab = CustomTabBarController()
//        let nav = RootNavigationController(rootViewController: DataViewController())
//        tab.viewControllers = [nav]
//        self.window?.rootViewController = tab
        self.window?.rootViewController = RootNavigationController(rootViewController: QXTestVc())

    }
    
    func setupFpsTest() {
        let w: CGFloat = 45
        let h: CGFloat = 10
        let x = UIScreen.main.bounds.size.width - w - 5
        let y = UIScreen.main.bounds.size.height - 49
        let memoryLabel = JYMemoryLabel(frame: CGRect(x: x, y: y - 15, width: w, height: h))
        memoryLabel.font = UIFont.systemFont(ofSize: 6)
        window!.addSubview(memoryLabel)
        let fpsLabel = YYFPSLabel(frame: CGRect(x: x, y: y - 30, width: w, height: h))
        fpsLabel.font = UIFont.systemFont(ofSize: 6)
        window!.addSubview(fpsLabel)
        memoryLabel.alpha = 0.5
        fpsLabel.alpha = 0.5
    }
    
    //MARK:ACTION
    func chooseUrl(){
        let dic = Bundle.main.infoDictionary
        if let bundName = dic?.nullableString("CFBundleName") {
            if bundName.components(separatedBy: "联调").count > 1 {
//                // 李俊杰
//                SSOPREFIXURL = "http://192.168.1.54:70/ucService/"
                PREFIXURL = "http://192.168.1.98:8080/cv_api/"
//                SSOPREFIXURL = "http://192.168.1.54:70/ucService/"
//                PREFIXURL = "http://192.168.1.98:8080/cv_api/"
            } else if bundName.components(separatedBy: "测试").count > 1 {
             
            }
        }
    }
    
    //注册环信云
    private func registerHuanxin(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        let isAutoLogin = EMClient.shared().isLoggedIn
        if isAutoLogin {
            //发送通知
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: KNOTIFICATION_LOGINCHANGE), object: true, userInfo: nil)
        } else {
            //发送通知
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: KNOTIFICATION_LOGINCHANGE), object: false, userInfo: nil)
        }
        
        let appCerName: String
//        #if DEBUG
//            appCerName = kEMAppSerDev
//        #else
        appCerName = kEMAppSerRelease
//        #endif
        let appKey = kEMAppKey
        let options = EMOptions(appkey: appKey)
        options?.apnsCertName = appCerName

        EMClient.shared().initializeSDK(with: options);
        EaseSDKHelper.share().hyphenateApplication(application, didFinishLaunchingWithOptions: launchOptions, appkey: appKey, apnsCertName: appCerName, otherConfig: [kSDKConfigEnableConsoleLogger:true])
        EMClient.shared().chatManager.add(self)
    }
    
    ///推送
    func registerNotification(application: UIApplication){
        ///推送
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                if granted{
                    print("用户授权成功")
                    center.getNotificationSettings(completionHandler: { (settings) in
                        print(settings)
                    })
                }else{
                    print("用户禁用通知")
                    let settings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
                    application.registerUserNotificationSettings(settings)
                }
            }
            application.registerForRemoteNotifications()
        } else {
            let settings = UIUserNotificationSettings(types:[.alert,.badge,.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
    }
    
    ///微信分享登录
    func registerWeixinShare(){
        ShareSDK.registerApp("TouZhong", activePlatforms:[
            SSDKPlatformType.typeWechat.rawValue],
                             onImport: { (platform : SSDKPlatformType) in
                                switch platform
                                {
                                case SSDKPlatformType.typeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                default:
                                    break
                                }
                                
        }) { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
            switch platform
            {
            case SSDKPlatformType.typeWechat:
                //设置微信应用信息
                appInfo?.ssdkSetupWeChat(byAppId: "wxa1d1d3b7e3537c02", appSecret: "2cb0f9a9a5bcd3b4b882d8d32e7f197b")
            default:
                break
            }
        }
    }
    //MARK:EMChatManagerDelegate
    func messagesDidReceive(_ aMessages: [Any]!) {
        ChatManage.shareInstance.getAllUnReadMessage()
        if aMessages.count>0 {
            let lastMessage = aMessages[aMessages.count-1]
            Account.sharedOne.lastMessage = lastMessage as? EMMessage
        }
        Tools.postNotification(notificationName: ReciveMessage,object:nil)
       self.localNotification(code: 0)
    }
    //MARK:获取deviceTocken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        DataManager.shareInstance.deviceIdGetted(id: token)
        print("deviceToken="+token)
        DispatchQueue.global().async {
            EMClient.shared().bindDeviceToken(deviceToken)
        }
    }
    //接受本地退送
    private func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print(notification.alertTitle ?? "nil")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
        print("9。0走这个方法推送成功")
        print(userInfo)
        handleNotification(userInfo: userInfo)
        let data = UIBackgroundFetchResult.newData
        completionHandler(data)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void){
        print("10项目在运行状态将要收到推送")
        print(notification.request.content.userInfo)
        handleNotification(userInfo: notification.request.content.userInfo)
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){
        if (UIApplication.shared.applicationState != UIApplicationState.background && UIApplication.shared.applicationState != UIApplicationState.active) {
           handleNotification(userInfo: response.notification.request.content.userInfo,isNoticeBoard: true)
        }else{
            handleNotification(userInfo: response.notification.request.content.userInfo)
        }
        completionHandler()
    }
    
    func handleNotification(userInfo:[AnyHashable : Any],isNoticeBoard:Bool? = false){
        let type1:Int = SafeUnwarp(userInfo["type1"] as? Int, holderForNull: 999)
        let type2:Int = SafeUnwarp(userInfo["type2"] as? Int, holderForNull: 999)
        let userId:String = SafeUnwarp(userInfo["userid"] as? String, holderForNull: "")
        let projectId:String = SafeUnwarp(userInfo["projectid"] as? String, holderForNull: "")
        switch type1 {
        case 1://好友请求
            if type2==0 {//请求添加您为好友
                Account.sharedOne.friendsBadge+=1
            }
            if type2==1 {//同意添加您为好友
                Account.sharedOne.friendsBadge+=1
            }
            if type2==2 {//忽略您的好友请求
                
            }
            if type2==3 {//拒绝添加您为好友
                
            }
            break
        case 2://与我相关
            if type2==1 {//评论了您的投资圈
                Account.sharedOne.associateBadge+=1
            }
            if type2==2 {//回复了您的评论
                Account.sharedOne.associateBadge+=1
            }
            
            break
        case 3://用户认证
            if type2==2 {//您的个人资料已经认证成功
                NotificationCenter.default.post(name: kNotificationAuthorSuccess, object: nil)
            }
            if type2==3 {//您的个人资料认证未通过
                NotificationCenter.default.post(name: kNotificationAuthorFailed, object: nil)
            }
            break
        case 4://其他设备登录
            if type2 == 1 { //您的账号在其他设备登录
                if Account.sharedOne.isLogin && userId == Account.sharedOne.user.id {
                    NotificationCenter.default.post(name: kNotificationLoginInOtherPlace, object: nil)
                }
            }
            break
        case 5://项目申请
            if type2 == 1 { //同意项目申请
                if isNoticeBoard == true{
                    Tools.postNotification(notificationName: replyApplyCheck,object:projectId as AnyObject?,userInfo:["projectId":projectId])
                }
            }
            break
        default:
            break
        }
        Tools.postNotification(notificationName: ReciveMessage,object:nil)
    }
    
    func localNotification(code:Int){
        let localNoti = UILocalNotification()
        if code == 0 {
            // 通知的触发时间，例如即刻起15分钟后
            let fireDate = NSDate().addingTimeInterval(0)
            localNoti.fireDate = fireDate as Date
            // 设置时区
            localNoti.timeZone = NSTimeZone.default
            // 通知上显示的主题内容
            localNoti.alertBody = "你有一条新消息"
            // 收到通知时播放的声音，默认消息声音
            localNoti.soundName = UILocalNotificationDefaultSoundName
            //待机界面的滑动动作提示
            localNoti.alertAction = "打开应用"
            // 应用程序图标右上角显示的消息数
            localNoti.applicationIconBadgeNumber = 0
            // 通知上绑定的其他信息，为键值对
            localNoti.userInfo = nil
            // 添加通知到系统队列中，系统会在指定的时间触发
            UIApplication.shared.scheduleLocalNotification(localNoti)
        }
    }
  
    //MARK:application
    //app即将进入休眠状态
    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }
    //app进入活跃状态
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    //app即将进入活跃状态
    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
        if Account.sharedOne.isLogin{
            DispatchQueue.global().async {
                ChatManage.shareInstance.loginHuanxin()
            }
        }
    }
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Zerlinda.touzhong" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "touzhong", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

