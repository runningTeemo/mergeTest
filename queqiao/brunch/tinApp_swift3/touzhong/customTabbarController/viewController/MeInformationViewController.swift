//
//  MeInformationViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeInformationViewController: StaticCellBaseViewController {
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        if !Account.sharedOne.isLogin {
            done(.err)
            return
        }
        
        let me = Account.sharedOne.user
        MyselfManager.shareInstance.getInfo(user: me, success: { [weak self] (code, msg, user) in
            if code == 0 {
                
                if Account.sharedOne.isLogin {
                    let user = user!
                    Account.sharedOne.user.id = user.id
                    Account.sharedOne.user.realName = user.realName
                    Account.sharedOne.user.company = user.company
                    Account.sharedOne.user.position = user.position
                    Account.sharedOne.user.gender = user.gender
                    Account.sharedOne.user.roleType = user.roleType
                    Account.sharedOne.user.avatar = user.avatar
                    Account.sharedOne.user.exmail = user.exmail
                    Account.sharedOne.user.author = user.author
                    Account.sharedOne.saveUser()
                    self?.update()
                    done(.noMore)
                }
                
            } else {
                done(.err)
                QXTiper.showFailed(msg, inView: self?.view, cover: true)
            }
            }) { [weak self] (error) in
                done(.err)
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    lazy var spaceItem0: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var headIconItem: MeInformationImageItem = {
        let one = MeInformationImageItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.showBottomLine = true
        one.title = "头像"
        one.url = nil
        one.responder = { [unowned self] in
            ActionSheet.show("选择头像", actions: [
                ("拍照", {
                    MediaTool.sharedOne.showCamera(edit: true, inVc: self)
                    MediaTool.sharedOne.pixelLimt = 200 * 200
                    MediaTool.sharedOne.respondImage = { [unowned self] image in
                        self.handleUploadImage(image: image)
                    }
                }),
                ("图片库选择", {
                    let vc = AlbumPhotoMainViewController()
                    vc.operateType = .singleSelectAndEdit
                    vc.pixelLimt = 200 * 200
                    let nav = RootNavigationController(rootViewController: vc)
                    self.present(nav, animated: true) {
                        
                    }
                    vc.responder = { [unowned self] images in
                        if images.count > 0 {
                            self.handleUploadImage(image: images.first!)
                        }
                    }
                })
                ], inVc: self)
        }
        return one
    }()

    lazy var realNameItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "真实姓名(认证)"
        one.title = "真实姓名"
        return one
    }()
    
    lazy var genderItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "性别(男/女)"
        one.title = "性别"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kUserSexKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    var arr:[String] = [String]()
    lazy var mobileItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = kClrLightGray
        one.maxCharCount = 11
        one.showBottomLine = true
        one.placeHolder = "手机号码(11位)"
        one.title = "手机"
        one.enabled = false
        return one
    }()
    
//    lazy var nickNameItem: StaticCellTextInputItem = {
//        let one = StaticCellTextInputItem()
//        one.titleFont = UIFont.systemFont(ofSize: 14)
//        one.titleColor = HEX("#666666")
//        one.textFont = UIFont.systemFont(ofSize: 14)
//        one.textColor = HEX("#333333")
//        one.maxCharCount = 99
//        one.showBottomLine = true
//        one.placeHolder = "在应用中的称呼"
//        one.title = "账户名"
//        return one
//    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.showBottomLine = true
        one.height = 10
        return one
    }()

    var organization: Organization?
    lazy var companyItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 14)
        one.subTitleColor = HEX("#333333")
        one.showBottomLine = true
        one.title = "公司"
        one.responder = { [unowned self] in
            let vc = OrganizationPickerViewController()
            vc.initText = one.subTitle
            vc.type = .combine
            vc.hidesBottomBarWhenPushed = true
            vc.responder = { [unowned self, unowned vc, unowned one] organization in
                one.subTitle = organization.name
                self.organization = organization
                self.tableView.reloadData()
                self.editChanged = true
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var postionItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "在上述公司的职位(认证)"
        one.title = "职位"
        return one
    }()
    
    lazy var roleItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "身份(认证)"
        one.title = "身份"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kUserRoleTypeKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var emailItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.placeHolder = "邮箱(认证)"
        one.title = "邮箱"
        one.disableAutoCorect = true
        one.keyboardTyle = .emailAddress
        return one
    }()
    
    lazy var spaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var spaceItem3: StaticCellSpaceItem = {
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
        
        title = "个人资料"
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
        setupRightNavItems(items: saveNavItem)

        tableView.register(MeInformationImageCell.self, forCellReuseIdentifier: "MeInformationImageCell")
        staticItems = [spaceItem0, headIconItem, realNameItem, genderItem, mobileItem, spaceItem1, companyItem, postionItem, roleItem, emailItem, spaceItem3]
        
        //setupRefreshHeader()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        update()
    }
    
    func update() {

        if !Account.sharedOne.isLogin { return }
        
        let user = Account.sharedOne.user
        
        headIconItem.url = user.avatar
        
        realNameItem.text = user.realName
        
        genderItem.text = TinSearch(code: user.gender, inKeys: kUserSexKeys)?.name
        var m = ""
        if let mobile = user.mobile {
            if mobile.characters.count >= 11 {
                let p = mobile.substring(to: mobile.characters.index(mobile.startIndex, offsetBy: 3))
                let s = mobile.substring(from: mobile.characters.index(mobile.endIndex, offsetBy: -4))
                m = p + "****" + s
            } else {
                if mobile.characters.count > 0 {
                    m = mobile
                }
            }
        }
        mobileItem.text = m
        //nickNameItem.text = user.nickName
        
        postionItem.text = user.position
        roleItem.text = TinSearch(code: user.roleType, inKeys: kUserRoleTypeKeys)?.name
        emailItem.text = user.exmail
        
        if let company = user.company {
            companyItem.subTitle = company
            let organization = Organization()
            organization.name = company
            organization.id = user.companyId
            organization.type = user.companyType
            self.organization = organization
        }
        tableView.reloadData()
    }
    
    var isSaving: Bool = false
    func handleSave() {
        
        view.endEditing(true)
        
        if !editChanged {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
        
            let realName = SafeUnwarp(self?.realNameItem.text, holderForNull: "")
            let gender = SafeUnwarp(TinSearch(name: self?.genderItem.text, inKeys: kUserSexKeys)?.code, holderForNull: "")
            //let nickName = SafeUnwarp(self?.nickNameItem.text, holderForNull: "")
            
            let organization = self?.organization
            //let company = SafeUnwarp(self?.companyItem.subTitle, holderForNull: "")
            let postion = SafeUnwarp(self?.postionItem.text, holderForNull: "")
            
            let role = TinSearch(name: self?.roleItem.text, inKeys: kUserRoleTypeKeys)?.code
            let email = SafeUnwarp(self?.emailItem.text, holderForNull: "")
            
            if  realName.characters.count == 0 {
                QXTiper.showWarning("真实姓名不能为空", inView: self?.view, cover: true)
                return
            }
            if  gender.characters.count == 0 {
                QXTiper.showWarning("性别不能为空", inView: self?.view, cover: true)
                return
            }
//            if  nickName.characters.count == 0 {
//                QXTiper.showWarning("昵称不能为空", inView: self?.view, cover: false)
//                return
//            }
            
            if  NullText(organization?.name) {
                QXTiper.showWarning("公司名不能为空", inView: self?.view, cover: true)
                return
            }
            if postion.characters.count == 0 {
                QXTiper.showWarning("职位不能为空", inView: self?.view, cover: true)
                return
            }
            if role == nil {
                QXTiper.showWarning("身份不能为空", inView: self?.view, cover: true)
                return
            }
            if email.characters.count == 0 {
                QXTiper.showWarning("邮箱不能为空", inView: self?.view, cover: true)
                return
            }
            if self?.checkEmail(email) == false {
                QXTiper.showWarning("邮箱不合法", inView: self?.view, cover: true)
                return
            }
            
            self?.setupRightNavItems(items: self?.loadingNavItem)
            
            let wait = QXTiper.showWaiting("保存中...", inView: self?.view, cover: true)
            
            self?.isSaving = true
            MyselfManager.shareInstance.saveInfo(realName: realName, organization: organization!, roleType: role!, gender: gender, position: postion, exmail: email, success: { [weak self] (code, msg, data) in
                QXTiper.hideWaiting(wait)
                self?.isSaving = false
                self?.setupRightNavItems(items: self?.saveNavItem)
                
                if code == 0 {
                    self?.editChanged = false
                    QXTiper.showSuccess("保存成功", inView: self?.view, cover: true)
                    
                    if Account.sharedOne.isLogin {
                        Account.sharedOne.user.realName = realName
                        Account.sharedOne.user.gender = gender
                        //Account.sharedOne.user.nickName = nickName
                        Account.sharedOne.user.companyId = organization!.id
                        Account.sharedOne.user.company = organization!.name
                        Account.sharedOne.user.position = postion
                        Account.sharedOne.user.roleType = role
                        Account.sharedOne.user.exmail = email
                        Account.sharedOne.saveUser()
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                        _ = self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
            }) { [weak self] (error) in
                self?.isSaving = false
                QXTiper.hideWaiting(wait)
                self?.setupRightNavItems(items: self?.saveNavItem)
                QXTiper.showWarning(kWebErrMsg + "(\(error.code))" , inView: self?.view, cover: true)
            }

        }
        
    }
    
    func checkEmail(_ text: String) -> Bool {
        let mailPattern = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
        if let _ = text.range(of: mailPattern, options: .regularExpression) {
            return true
        }
      return false
    }
    
    func handleBack() {
        if editChanged && isSaving == false {
            Confirmer.show("退出编辑", message: "退出界面将不会保存修改的内容，是否继续？", confirm: "取消编辑", confirmHandler: { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
                }, cancel: "继续编辑", cancelHandler: {
                }, inVc: self)
            
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleUploadImage(image: UIImage) {
        
        if !Account.sharedOne.isLogin { return }
        
        let user = Account.sharedOne.user
        MyselfManager.shareInstance.uploadAvatar(user, image: image, success: { [weak self] (code, msg, pic) in
            if code == 0 {
                let pic = pic!
                if Account.sharedOne.isLogin {
                    Account.sharedOne.user.avatar = pic.url
                    Account.sharedOne.saveUser()
                }
                self?.headIconItem.url = pic.url
                self?.tableView.reloadData()
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
            
            }) { [weak self] (error) in
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))" , inView: self?.view, cover: true)
        }
    }
    
}

class MeInformationImageItem: StaticCellArrowItem {
    var url: String?
    var localName: String?
    override init() {
        super.init()
        cellHeight = 90
    }
}

class MeInformationImageCell: StaticCellArrowCell {
    
    override func update() {
        super.update()
        if let item = item as? MeInformationImageItem {
            if let localName = item.localName {
                iconView.image = UIImage(named: localName)
            } else {
                iconView.fullPath = item.url
                print(item.url ?? "")
            }
        }
    }
    
    lazy var iconView: ImageView = {
        let one = ImageView(type: .user)
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        subTitleLabel.isHidden = true
        addSubview(iconView)
        iconView.LEFT(arrowView).OFFSET(10).CENTER.SIZE(70, 70).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

