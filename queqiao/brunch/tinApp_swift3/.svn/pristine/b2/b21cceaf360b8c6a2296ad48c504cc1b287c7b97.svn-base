//
//  ChangePwdViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ChangePwdViewController: StaticCellBaseViewController {
    
    lazy var spaceItem0: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var origenPwdItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "至少6位"
        one.title = "原密码"
        one.security = true
        return one
    }()
    
    lazy var newPwdItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "至少6位"
        one.title = "新密码"
        one.security = true
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "保存", responder: { [unowned self] in
            self.handleSave()
            })
        return one
    }()
    lazy var loadingNavItem: BarButtonItem = {
        let one = BarButtonItem(indicatorStyle: .gray)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "修改密码"
        setupRightNavItems(items: saveNavItem)

        staticItems = [spaceItem0, origenPwdItem, newPwdItem, spaceItem1]
        setupNavBackBlackButton(nil)
    }
    
    func handleSave() {
        
        view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            let orginPwd = SafeUnwarp(self?.origenPwdItem.text, holderForNull: "")
            let newPwd = SafeUnwarp(self?.newPwdItem.text, holderForNull: "")
            let rightPwd = UserDefaults.standard.object(forKey: kUserDefaultUserPwd) as! String
            if  orginPwd.characters.count < 6 {
                QXTiper.showWarning("密码不能少于6位", inView: self?.view, cover: true)
                return
            }
            if  newPwd.characters.count < 6 {
                QXTiper.showWarning("密码不能少于6位", inView: self?.view, cover: true)
                return
            }
            if  orginPwd != rightPwd {
                QXTiper.showWarning("原始密码不正确", inView: self?.view, cover: true)
                return
            }
            
            self?.setupRightNavItems(items: self?.loadingNavItem)
            
            let wait = QXTiper.showWaiting("修改中...", inView: self?.view, cover: true)

            MyselfManager.shareInstance.modifyPassword(orginPwd, newPassword: newPwd, success: { [weak self] (code, msg, data) in
                QXTiper.hideWaiting(wait)
                
                self?.setupRightNavItems(items: self?.saveNavItem)
                if code == 0 {
                    QXTiper.showSuccess("修改成功", inView: self?.view, cover: true)
                    UserDefaults.standard.set(newPwd, forKey: kUserDefaultUserPwd)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                        _ = self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
            }) { [weak self] (error) in
                QXTiper.hideWaiting(wait)
                self?.setupRightNavItems(items: self?.saveNavItem)
                QXTiper.showWarning(kWebErrMsg + "(\(error.code))" , inView: self?.view, cover: true)
            }
            
        }
        
    }
    
}
