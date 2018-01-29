//
//  PublishManPowerViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/21.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PublishManPowerViewController: StaticCellBaseViewController {
    
    weak var vcBefore: ArticleMainViewControler?
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
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
    
    lazy var jobItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 14)
        one.subTitleColor = HEX("#333333")
        one.showBottomLine = true
        one.title = "职位"
        one.responder = { [unowned self] in
            let vc = PositionsPickerViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.respondPossition = { [unowned self, unowned vc, unowned one] name in
                one.subTitle = name
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var roundItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "公司轮次"
        one.title = "公司轮次"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kManPowerRoundKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var cityItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 14)
        one.subTitleColor = HEX("#333333")
        one.showBottomLine = true
        one.title = "职位地点"
        one.responder = { [unowned self] in
            let vc = LocationPickerMainViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.respondCity = { [unowned self, unowned vc, unowned one] name in
                one.subTitle = name
                self.tableView.reloadData()
            }
            let nav = RootNavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        return one
    }()
    
    lazy var yearLimitItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "单位年(必填项)"
        one.title = "要求年限"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kManPowerYearKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var degreeLimitItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "学历要求(必填项)"
        one.title = "要求学历"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kManPowerDegreeKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var salaryItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = false
        one.placeHolder = "薪资(必填项)"
        one.title = "职位薪资"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kManPowerSalaryKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var textItem: StaticCellTextViewItem = {
        let one = StaticCellTextViewItem()
        one.title = "职位要求"
        one.holderText = "请填写职位要求"
        one.cellHeight = 150
        one.showBottomLine = false
        return one
    }()

    lazy var spaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var hornItem: StaticHornItem = {
        let one = StaticHornItem()
        one.responder = { [unowned self] in
            let vc = UseHornViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            vc.respondHorn = { [unowned self, unowned one] horn in
                one.horn = horn
                self.tableView.reloadData()
            }
        }
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "发布", responder: { [unowned self] in
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
        tableView.register(StaticHornCell.self, forCellReuseIdentifier: "StaticHornCell")

        title = "发布人才"
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
        
        staticItems = [topSpaceItem, companyItem, jobItem, roundItem, cityItem, yearLimitItem, degreeLimitItem, salaryItem, spaceItem1, textItem, spaceItem2, hornItem, bottomSpaceItem]
        
        setupRightNavItems(items: saveNavItem)
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if let city = LocationDataEntry.sharedOne.currentCity {
            cityItem.subTitle = city.name
        }
        tableView.reloadData()
        
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            MyselfManager.shareInstance.getHornCount(me, success: { [weak self] code, msg, data in
                if code == 0 {
                    let n = data
                    self?.hornItem.hornCount = n
                    self?.tableView.reloadData()
                }
                }, failed: { err in
            })
        }
    }
    
    func handleBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func handleSave() {
        view.endEditing(true)
        
        if NullText(companyItem.subTitle) {
            QXTiper.showWarning("请填写\(SafeUnwarp(companyItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(jobItem.subTitle) {
            QXTiper.showWarning("请选择\(SafeUnwarp(jobItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(roundItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(roundItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(cityItem.subTitle) {
            QXTiper.showWarning("请选择\(SafeUnwarp(cityItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(yearLimitItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(yearLimitItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(degreeLimitItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(degreeLimitItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(salaryItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(salaryItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(textItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(textItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.setupRightNavItems(items: self?.loadingNavItem)
            
            let wait = QXTiper.showWaiting("发布中...", inView: self?.view, cover: true)
            self?.sendRequest({ [weak self] in
                QXTiper.hideWaiting(wait)
                self?.setupRightNavItems(items: self?.saveNavItem)
            })
        }
        
    }
    
    
    func sendRequest(_ done: @escaping (() -> ())) {
        
        if !Account.sharedOne.isLogin {
            done()
            return
        }
        let me = Account.sharedOne.user
        
        let attachment = ArticleManpowerAttachments()
        attachment.companyId = organization?.id
        attachment.companyName = companyItem.subTitle
        attachment.duty = jobItem.subTitle
        attachment.round = TinSearch(name: roundItem.text, inKeys: kManPowerRoundKeys)?.code
        attachment.address = cityItem.subTitle
        attachment.requiredAge = TinSearch(name: yearLimitItem.text, inKeys: kManPowerYearKeys)?.code
        attachment.requiredDegree = TinSearch(name: degreeLimitItem.text, inKeys: kManPowerDegreeKeys)?.code
        attachment.salary = TinSearch(name: salaryItem.text, inKeys: kManPowerSalaryKeys)?.code
        attachment.descri = textItem.text

        attachment.broadcast = hornItem.horn != nil
        
        ArticleManager.shareInstance.publishManPower(me, attachments: attachment, horn: self.hornItem.horn, success: { [weak self] (code, message, ret) in
            if code == 0 {
                QXTiper.showSuccess("发布成功", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                    self?.vcBefore?.performRefresh()
                }
            } else {
                QXTiper.showWarning(message, inView: self?.view, cover: true)
            }
            done()
        }) { [weak self] (error) in
            done()
            QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
    }
        
}
