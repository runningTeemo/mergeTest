//
//  MeInformationViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

/// 个人信息页面，另一种样式，每一行进入别的界面修改
class MeInformationViewControllerTypeB: StaticCellBaseViewController {
    
//    lazy var spaceItem0: StaticCellSpaceItem = {
//        let one = StaticCellSpaceItem()
//        one.height = 10
//        return one
//    }()
//    
//    lazy var headIconItem: MeInformationImageItem = {
//        let one = MeInformationImageItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.showBottomLine = true
//        one.title = "头像"
//        one.url = nil
//        one.responder = { [unowned self] in
//            ActionSheet.show("选择头像", actions: [
//                ("拍照", {
//                    
//                }),
//                ("图片库选择", {
//                    let vc = AlbumPhotoMainViewController()
//                    vc.operateType = .singleSelectAndEdit
//                    let nav = RootNavigationController(rootViewController: vc)
//                    self.present(nav, animated: true) {
//                        
//                    }
//                })
//                ], inVc: self)
//        }
//        return one
//    }()
//    
//    lazy var nameItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.showBottomLine = true
//        one.tip = "未填写"
//        one.title = "真实姓名"
//        one.responder = { [unowned self, unowned one] in
//            let vc = SettingInputViewController()
//            vc.title = "修改真实姓名"
//            vc.text = one.subTitle
//            vc.maxCharCount = 99
//            vc.keyboardStyle = .default
//            vc.tip = "填写真实的姓名，不能有特殊字符"
//            vc.respondSave = { [weak self] text, success, fail in
//                self?.saveInfo("realname", value: text, success: { (msg) in
//                    if Account.sharedOne.isLogin {
//                        Account.sharedOne.user.realName = text
//                        Account.sharedOne.saveUser("realname", text)
//                    }
//                    success?(msg)
//                    }, fail: fail)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
//    
//    lazy var genderItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.showBottomLine = true
//        one.tip = "未填写"
//        one.title = "性别"
//        
//        one.responder = { [unowned self, unowned one] in
//            let vc = SettingInputViewController()
//            vc.title = "修改性别"
//            vc.text = one.subTitle
//            vc.maxCharCount = 10
//            let listPicker = ListPickerView()
//            listPicker.keys = ["", "男", "女"]
//            listPicker.responder = { [unowned vc] key in
//                vc.text = key
//            }
//            vc.customKeyboard = listPicker
//            vc.tip = "性别（男/女）"
//            vc.respondSave = { [weak self] text, success, fail in
//                var v: String? = nil
//                if text == "男" {
//                    v = "male"
//                } else if text == "女" {
//                    v = "female"
//                }
//                self?.saveInfo("gender", value: SafeUnwarp(v, holderForNull: ""), success: { (msg) in
//                    
//                    if Account.sharedOne.isLogin {
//                        Account.sharedOne.user.gender = nil
//                        if text == "男" {
//                            Account.sharedOne.user.gender = .Male
//                        } else if text == "女" {
//                            Account.sharedOne.user.gender = .Female
//                        }
//                        Account.sharedOne.saveUser("gender", v)
//                    }
//                    
//                    success?(msg)
//                    }, fail: fail)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
//    
//    lazy var mobileItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.showBottomLine = true
//        one.tip = "未填写"
//        one.title = "手机"
//        return one
//    }()
//    
//    lazy var nickNameItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.showBottomLine = true
//        one.tip = "未填写"
//        one.title = "账户名"
//        one.responder = { [unowned self, unowned one] in
//            let vc = SettingInputViewController()
//            vc.title = "修改真实姓名"
//            vc.text = one.subTitle
//            vc.maxCharCount = 99
//            vc.keyboardStyle = .default
//            vc.tip = "填写真实的姓名，不能有特殊字符"
//            vc.respondSave = { [weak self] text, success, fail in
//                self?.saveInfo("nickname", value: text, success: { (msg) in
//                    //Account.sharedOne.user.nickName = text
//                    Account.sharedOne.saveUser("nickname", text)
//                    success?(msg)
//                    }, fail: fail)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
//    
//    lazy var spaceItem1: StaticCellSpaceItem = {
//        let one = StaticCellSpaceItem()
//        one.showBottomLine = true
//        one.height = 10
//        return one
//    }()
//    
//    lazy var companyItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.showBottomLine = true
//        one.tip = "认证必填项"
//        one.title = "公司"
//        one.responder = { [unowned self, unowned one] in
//            let vc = SettingInputViewController()
//            vc.title = "修改公司"
//            vc.text = one.subTitle
//            vc.maxCharCount = 99
//            vc.keyboardStyle = .default
//            vc.tip = "公司名称（认证必填项，请如实填写）"
//            vc.respondSave = { [weak self] text, success, fail in
//                self?.saveInfo("company", value: text, success: { (msg) in
//                    Account.sharedOne.user.company = text
//                    Account.sharedOne.saveUser("company", text)
//                    success?(msg)
//                    }, fail: fail)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
//    
//    lazy var postionItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.showBottomLine = true
//        one.tip = "认证必填项"
//        one.title = "职位"
//        one.responder = { [unowned self, unowned one] in
//            let vc = SettingInputViewController()
//            vc.title = "修改职务"
//            vc.text = one.subTitle
//            vc.maxCharCount = 99
//            vc.keyboardStyle = .default
//            vc.tip = "在公司内的职务（认证必填项，请如实填写）"
//            vc.respondSave = { [weak self] text, success, fail in
//                self?.saveInfo("position", value: text, success: { (msg) in
//                    Account.sharedOne.user.position = text
//                    Account.sharedOne.saveUser("position", text)
//                    success?(msg)
//                    }, fail: fail)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
//    
//    lazy var roleItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.showBottomLine = true
//        one.tip = "认证必填项"
//        one.title = "身份"
//        one.responder = { [unowned self, unowned one] in
//            let vc = SettingInputViewController()
//            vc.title = "修改身份"
//            vc.text = one.subTitle
//            vc.maxCharCount = 10
//            vc.text = "GP"
//            let listPicker = ListPickerView()
//            listPicker.keys = ["", "GP", "LP", "企业"]
//            listPicker.responder = { [unowned vc] key in
//                vc.text = key
//            }
//            vc.customKeyboard = listPicker
//            vc.tip = "身份（GP/LP/企业，认证必填项）"
//            vc.respondSave = { [weak self] text, success, fail in
//                self?.saveInfo("roletype", value: text, success: { (msg) in
//                    Account.sharedOne.user.roleType = text
//                    Account.sharedOne.saveUser("roletype", text)
//                    success?(msg)
//                    }, fail: fail)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
//    
//    lazy var emailItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.tip = "认证必填项"
//        one.title = "邮箱"
//        one.responder = { [unowned self, unowned one] in
//            let vc = SettingInputViewController()
//            vc.title = "修改邮箱"
//            vc.text = one.subTitle
//            vc.maxCharCount = 99
//            vc.keyboardStyle = .emailAddress
//            vc.tip = "邮箱（认证必填项，可用于邮箱认证，请如实填写）"
//            vc.respondSave = { [weak self] text, success, fail in
//                self?.saveInfo("exmail", value: text, success: { (msg) in
//                    Account.sharedOne.user.email = text
//                    Account.sharedOne.saveUser("email", text)
//                    success?(msg)
//                    }, fail: fail)
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        return one
//    }()
//    
//    lazy var spaceItem2: StaticCellSpaceItem = {
//        let one = StaticCellSpaceItem()
//        one.height = 10
//        return one
//    }()
//    
//    lazy var changePwdItem: StaticCellArrowItem = {
//        let one = StaticCellArrowItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.subTitleFont = UIFont.systemFont(ofSize: 16)
//        one.subTitleColor = HEX("#333333")
//        one.title = "修改密码"
//        return one
//    }()
//    
//    lazy var spaceItem3: StaticCellSpaceItem = {
//        let one = StaticCellSpaceItem()
//        one.height = 40
//        return one
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "个人资料"
//        setupNavBackBlackButton(nil)
//        
//        tableView.register(MeInformationImageCell.self, forCellReuseIdentifier: "MeInformationImageCell")
//        staticItems = [spaceItem0, headIconItem, nameItem, genderItem, mobileItem, nickNameItem, spaceItem1, companyItem, postionItem, roleItem, emailItem, spaceItem2, changePwdItem, spaceItem3]
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        update()
//    }
//    
//    func update() {
//        assert(Account.sharedOne.isLogin, "必须登录才能进这个界面")
//        let user = Account.sharedOne.user
//        
//        nameItem.subTitle = user.realName
//        genderItem.subTitle = user.gender?.rawValue
//        var m = ""
//        if let mobile = user.mobile {
//            if mobile.characters.count >= 11 {
//                let p = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 3))
//                let s = mobile.substring(from: mobile.characters.index(mobile.endIndex, offsetBy: -4))
//                m = p + "****" + s
//            } else {
//                if mobile.characters.count > 0 {
//                    m = mobile
//                }
//            }
//        }
//        mobileItem.subTitle = m
//        //nickNameItem.subTitle = user.nickName
//        
//        companyItem.subTitle = user.company
//        postionItem.subTitle = user.position
//        roleItem.subTitle = user.roleType
//        emailItem.subTitle = user.email
//        tableView.reloadData()
//    }
//    
//    
//    func saveInfo(_ key: String, value: String, success: SettingInputHandler?, fail: SettingInputHandler?) {
////        MyselfManager.shareInstance.saveInfo(key, value: value, success: { (successTuple) in
////            if successTuple.code == 0 {
////                success?(msg: nil)
////            } else {
////                success?(msg: successTuple.message + "(\(successTuple.code))")
////            }
////        }) { (error) in
////            fail?(msg: kWebErrMsg + "(\(error.code))")
////        }
//    }
    
}

