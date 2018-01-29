//
//  SettingsViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/3.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SettingsViewController: StaticCellBaseViewController {
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
//    lazy var nightModeItem: StaticCellSwitchItem = {
//        let one = StaticCellSwitchItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.title = "夜间模式"
//        one.showBottomLine = true
//        return one
//    }()
    
    lazy var fontItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 16)
        one.subTitleColor = HEX("666666")
        one.title = "正文字号"
        one.subTitle = "小"
        one.responder = { [unowned self] in
            let vc = ChooseFontViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.showBottomLine = true
        return one
    }()
    
    lazy var cleanCacheItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 16)
        one.subTitleColor = HEX("666666")
        one.title = "清理缓存"
        one.responder = { [unowned self] in
            let wait = QXTiper.showWaiting("删除中...", inView: self.view, cover: true)
            TinFileCacher.sharedOne.cleanCacheInBackgroud { [weak self] in
                QXTiper.hideWaiting(wait)
                QXTiper.showSuccess("删除完成", inView: self?.view, cover: true)
                self?.tryUpdateCacheSizeInBackground()
            }
        }
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var changePwdItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 14)
        one.subTitleColor = HEX("#333333")
        one.title = "修改密码"
        one.responder = { [unowned self] in
            let vc = ChangePwdViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var spaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var briefItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "版本介绍"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "版本介绍"
            vc.url = PREFIXURL + "ui/page/help/version.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var helpItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "帮助"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = HelpListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
//    lazy var adviseItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.title = "反馈"
//        one.showBottomLine = true
//        one.responder = { [unowned self] in
//            let vc = AdviseViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
    
    lazy var markItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "去评分"
        one.responder = { [unowned self] in
            let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=886488095")!
            UIApplication.shared.openURL(url)
        }
        return one
    }()
    
    lazy var spaceItem3: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var logoutItem: StaticCellTextButtonItem = {
        let one = StaticCellTextButtonItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "退出登录"
        one.responder = { [unowned self] in
            self.handleLogout()
        }
        return one
    }()

    lazy var spaceItem4: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        
        setupNavBackBlackButton(nil)

        staticItems = [spaceItem, fontItem, cleanCacheItem, spaceItem1, briefItem, helpItem, /*adviseItem,*/ markItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Account.sharedOne.isLogin {
            staticItems = [spaceItem, fontItem, cleanCacheItem, spaceItem1, changePwdItem, spaceItem2, briefItem, helpItem, /*adviseItem,*/ markItem, spaceItem3, logoutItem, spaceItem4]
        } else {
            staticItems = [spaceItem, fontItem, cleanCacheItem, spaceItem1, briefItem, helpItem, /*adviseItem,*/ markItem]
        }
        
        if let size = UserDefaults.standard.value(forKey: kUserDefaultKeyFontSize) as? String {
            if size == "L" {
                fontItem.subTitle = "大"
            } else if size == "M" {
                fontItem.subTitle = "中"
            } else if size == "S" {
                fontItem.subTitle = "小"
            }
        } else {
            fontItem.subTitle = "中"
        }
        
        tableView.reloadData()
        showNav()
        
        tryUpdateCacheSizeInBackground()
    }
    
    func tryUpdateCacheSizeInBackground() {
        TinFileCacher.sharedOne.getCacheSizeInBackground { [weak self] size in
            if size < 1000 {
                self?.cleanCacheItem.subTitle = "\(size) B"
            } else if size < 1000 * 1000 {
                self?.cleanCacheItem.subTitle = String(format: "%.2f KB", Double(size) / 1000)
            } else if size < 1000 * 1000 * 1000 {
                self?.cleanCacheItem.subTitle = String(format: "%.2f MB", Double(size) / (1000 * 1000))
            } else if size < 1000 * 1000 * 1000 * 1000 {
                self?.cleanCacheItem.subTitle = String(format: "%.2f GB", Double(size) / (1000 * 1000 * 1000))
            } else {
                self?.cleanCacheItem.subTitle = String(format: "%.2f TB", Double(size) / (1000 * 1000 * 1000 * 1000))
            }
            self?.tableView.reloadData()
        }
    }
    
    func handleLogout() {
        
        if Account.sharedOne.isLogin {
            if let mobile = Account.sharedOne.user.mobile {
                LoginManager.shareInstance.logout(mobile, success: { code, msg, _ in
                    if code == 0 {
                        print("调用退出接口成功！")
                    } else {
                        print("调用退出接口失败！")
                    }
                }, failed: { error in
                    print("调用退出接口失败！")
                })
            }
            Account.sharedOne.logout()
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
