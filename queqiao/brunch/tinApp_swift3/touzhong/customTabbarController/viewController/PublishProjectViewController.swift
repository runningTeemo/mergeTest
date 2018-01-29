//
//  PublishProjectViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/23.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class PublishProjectViewController: StaticCellBaseViewController {
    
    var isFAMode: Bool {
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            if TinSearch(code: me.roleType, inKeys: kUserRoleTypeKeys)?.name == "FA" {
                return true
            }
        }
        return false
    }
    
    var isOtherModel: Bool {
        if Account.sharedOne.isLogin {
            let me = Account.sharedOne.user
            let name = TinSearch(code: me.roleType, inKeys: kUserRoleTypeKeys)?.name
            if name == "FA" {
                return false
            } else if name == "企业" {
                return false
            }
        }
        return true
    }
    
    weak var vcBefore: ArticleMainViewControler?
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var relationItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "身份(必填项)"
        one.title = "你与项目的关系"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kCompanySignedIssueKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var nameItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "项目名称(必填项)"
        one.title = "项目名称"
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
        one.title = "标的公司"
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
    
    lazy var dealTypeItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "交易轮次(必填项)"
        one.title = "交易类型"
        one.text = "VC/PE融资"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kProjectDealTypeKeys)
        listPicker.responder = { [unowned self, unowned one] t in
            if NotNullText(t) {
                one.text = t
                one.updateCell?()
                if t == "VC/PE融资" {                    
                    if let picker = self.nowRoundItem.customKeyboard as? ListPickerView {
                        picker.keys = TinGetNames(keys: kProjectInvestTypeKeys)
                        self.nowRoundItem.text = nil
                    }
                    if let picker = self.lastRoundItem.customKeyboard as? ListPickerView {
                        picker.keys = TinGetNames(keys: kProjectInvestTypeKeys)
                        self.lastRoundItem.text = nil
                    }
                } else if t == "并购收购" {
                    if let picker = self.nowRoundItem.customKeyboard as? ListPickerView {
                        picker.keys = TinGetNames(keys: kProjectMergeTypeKeys)
                        self.nowRoundItem.text = nil
                    }
                    if let picker = self.lastRoundItem.customKeyboard as? ListPickerView {
                        picker.keys = TinGetNames(keys: kProjectMergeTypeKeys)
                        self.lastRoundItem.text = nil
                    }
                }
                self.tableView.reloadData()
            }
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
        one.title = "项目地点"
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
    
    lazy var commissionItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "佣金比例(必填项)"
        one.title = "项目佣金"
        one.text = "2"
        one.units = "%"
        one.keyboardTyle = .decimalPad
        one.textFormatter = { text in
            return StaticCellTools.textToPercentage(origenText: text)
        }
        return one
    }()
    
    var industries: [Industry] = [Industry]()
    
    lazy var industriesItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.subTitleFont = UIFont.systemFont(ofSize: 14)
        one.subTitleColor = HEX("#333333")
        one.showBottomLine = false
        one.title = "行业分类"
        one.responder = { [unowned self] in
            let vc = IndustryPickerViewController()
            vc.mutiMode = true
            vc.hidesBottomBarWhenPushed = true
            vc.respondIndustries = { [unowned self, unowned vc, unowned one] industries in
                var text = ""
                for industry in industries {
                    text += SafeUnwarp(industry.name, holderForNull: "")
                    text += " "
                }
                if industries.count > 0 {
                    let end = text.index(text.endIndex, offsetBy: -1)
                    text = text.substring(to: end)
                }
                one.subTitle = text
                self.industries = industries
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var nowRoundItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "交易轮次(必填项)"
        one.title = "本轮交易"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kProjectInvestTypeKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var moneyTypeItem: MoneyInputItem = {
        let one = MoneyInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.showBottomLine = true
        one.title = "币种偏好"
        one.tags = [0] // 默认选中 元
        one.respondTags = { [unowned self, unowned one] tags in

        }
        return one
    }()
    
    lazy var moneyCurrencyItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "币种"
        one.title = "交易币种"
        one.text = "人民币"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kCurrencyTypeKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
            if t == "美元" {
                self.moneyItem.units = "美元"
                self.moneyProfix = "$"
                self.moneyItem.text = self.moneyProfix + StaticCellTools.textToDecNumber(origenText: self.moneyItem.text)
            } else if t == "欧元" {
                self.moneyItem.units = "欧元"
                self.moneyProfix = "€"
                self.moneyItem.text = self.moneyProfix + StaticCellTools.textToDecNumber(origenText: self.moneyItem.text)
            } else {
                self.moneyItem.units = "元"
                self.moneyProfix = "￥"
                self.moneyItem.text = self.moneyProfix + StaticCellTools.textToDecNumber(origenText: self.moneyItem.text)
            }
            self.tableView.reloadData()
        }
        one.customKeyboard = listPicker
        return one
    }()

    var moneyProfix: String = "￥"
    lazy var moneyItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "数字(必填项)"
        one.title = "交易金额"
        one.units = ""
        one.keyboardTyle = .numberPad
        one.textFormatter = { [unowned self, unowned one] text in
            let value = StaticCellTools.textToDecNumber(origenText: text)
            one.units = "(" + self.moneyProfix + StaticCellTools.textToNatureMoney(origenText: value) + ")"
            return value
        }
        return one
    }()
    
    lazy var stockRateAfterItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = true
        one.placeHolder = "百分比(必填项)"
        one.title = "交易后股权比例"
        one.units = "%"
        one.keyboardTyle = .decimalPad
        one.textFormatter = { text in
            return StaticCellTools.textToPercentage(origenText: text)
        }
        return one
    }()
    
    lazy var lastRoundItem: StaticCellTextInputItem = {
        let one = StaticCellTextInputItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.textFont = UIFont.systemFont(ofSize: 14)
        one.textColor = HEX("#333333")
        one.maxCharCount = 99
        one.showBottomLine = false
        one.placeHolder = "上轮交易轮次"
        one.title = "上轮交易"
        let listPicker = ListPickerView()
        listPicker.keys = TinGetNames(keys: kProjectInvestTypeKeys)
        listPicker.responder = { [unowned one] t in
            one.text = t
            one.updateCell?()
        }
        one.customKeyboard = listPicker
        return one
    }()
    
    lazy var spaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    
    lazy var pointsViewItem: ProjectPointsViewItem = {
        let one = ProjectPointsViewItem()
        one.respondSpot = { [unowned self, unowned one] in
            let vc = ProjectPointEditViewController()
            vc.title = "项目亮点"
            vc.placeHolder = "可以突出介绍团队、合作商、订单量或其他能帮助项目成长的资源等"
            vc.text = one.spot
            vc.respondText = { [unowned self, unowned one] text in
                one.spot = text
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondBrief = { [unowned self, unowned one] in
            let vc = ProjectBriefEditViewController()
            vc.title = "产品概况"
            vc.placeHolder = "目前项目的产品相关介绍"
            vc.text = one.brief
            vc.images = one.images
            vc.respondTextOrImages = { [unowned self, unowned one] text, images in
                one.brief = text
                one.images = images
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondPain = { [unowned self, unowned one] in
            let vc = ProjectPointEditViewController()
            vc.title = "行业痛点"
            vc.placeHolder = "描述客户、市场面临的问题和痛点，目前市场上是如何应对这些问题的，问题的严重性及竞争对手无法满足市场需求的客观事实"
            vc.text = one.pain
            vc.respondText = { [unowned self, unowned one] text in
                one.pain = text
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondMembers = { [unowned self, unowned one] in
            let vc = ProjectPointEditViewController()
            vc.title = "创始团队"
            vc.placeHolder = "项目的主要团队成员及他们的简单介绍"
            vc.text = one.members
            vc.respondText = { [unowned self, unowned one] text in
                one.members = text
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondBussiness = { [unowned self, unowned one] in
            let vc = ProjectPointEditViewController()
            vc.title = "商业模式"
            vc.placeHolder = "主要描述公司商业模式及未来的盈利模式，盈收预测、发展规划等"
            vc.text = one.bussiness
            vc.respondText = { [unowned self, unowned one] text in
                one.bussiness = text
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondData = { [unowned self, unowned one] in
            let vc = ProjectPointEditViewController()
            vc.title = "运营数据"
            vc.placeHolder = "主要描述公司目前及未来的运营数据情况"
            vc.text = one.data
            vc.respondText = { [unowned self, unowned one] text in
                one.data = text
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondMaketing = { [unowned self, unowned one] in
            let vc = ProjectPointEditViewController()
            vc.title = "市场情况"
            vc.placeHolder = "主要描述公司目前的市场占有率、竞争分析等"
            vc.text = one.marketing
            vc.respondText = { [unowned self, unowned one] text in
                one.marketing = text
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        one.respondExit = { [unowned self, unowned one] in
            let vc = ProjectPointEditViewController()
            vc.title = "退出方案"
            vc.placeHolder = "主要描述未来公司将采取的退出方式，比如上市、并购、回购、股权转让等"
            vc.text = one.exit
            vc.respondText = { [unowned self, unowned one] text in
                one.exit = text
                self.tableView.reloadData()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var spaceItem3: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var publicItem: StaticCellSwitchItem = {
        let one = StaticCellSwitchItem()
        one.isOn = false
        one.showBottomLine = true
        one.title = "公开项目详情"
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
        tableView.register(MoneyInputCell.self, forCellReuseIdentifier: "MoneyInputCell")
        tableView.register(ProjectPointsViewCell.self, forCellReuseIdentifier: "ProjectPointsViewCell")

        title = "发布项目"
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
        
        if isOtherModel {
            //staticItems = [topSpaceItem, nameItem, companyItem, dealTypeItem, cityItem, commissionItem, industriesItem, spaceItem1, nowRoundItem, moneyTypeItem, moneyCurrencyItem, moneyItem, stockRateAfterItem, lastRoundItem, spaceItem2, pointsViewItem, spaceItem3, publicItem, hornItem, bottomSpaceItem]
            staticItems = [topSpaceItem, nameItem, companyItem, dealTypeItem, cityItem, commissionItem, industriesItem, spaceItem1, nowRoundItem, moneyTypeItem, moneyCurrencyItem, moneyItem, stockRateAfterItem, lastRoundItem, spaceItem2, pointsViewItem, spaceItem3, publicItem, bottomSpaceItem]
        } else {
            //staticItems = [topSpaceItem, relationItem, nameItem, companyItem, dealTypeItem, cityItem, commissionItem, industriesItem, spaceItem1, nowRoundItem, moneyTypeItem, moneyCurrencyItem, moneyItem, stockRateAfterItem, lastRoundItem, spaceItem2, pointsViewItem, spaceItem3, publicItem, hornItem, bottomSpaceItem]
            staticItems = [topSpaceItem, relationItem, nameItem, companyItem, dealTypeItem, cityItem, commissionItem, industriesItem, spaceItem1, nowRoundItem, moneyTypeItem, moneyCurrencyItem, moneyItem, stockRateAfterItem, lastRoundItem, spaceItem2, pointsViewItem, spaceItem3, publicItem, bottomSpaceItem]
        }
        
        setupRightNavItems(items: saveNavItem)
        
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        
        if isFAMode {
            if let picker = relationItem.customKeyboard as? ListPickerView {
                picker.keys = TinGetNames(keys: kFAProjectSignedIssueKeys)
                relationItem.text = nil
            }
        } else {
            if let picker = relationItem.customKeyboard as? ListPickerView {
                picker.keys = TinGetNames(keys: kCompanySignedIssueKeys)
                relationItem.text = nil
            }
        }
        
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
        
        var hasContent: Bool = false
        
        //if NotNullText(relationItem.text)  { hasContent = true }
        if NotNullText(nameItem.text)  { hasContent = true }
        if NotNullText(companyItem.subTitle)  { hasContent = true }
        //if NotNullText(cityItem.subTitle)  { hasContent = true }
        //if NotNullText(commissionItem.text)  { hasContent = true }
        if NotNullText(industriesItem.subTitle)  { hasContent = true }
        if NotNullText(nowRoundItem.text)  { hasContent = true }
        //if NotNullText(moneyCurrencyItem.text)  { hasContent = true }
        if NotNullText(moneyItem.text)  { hasContent = true }
        if NotNullText(stockRateAfterItem.text)  { hasContent = true }

        if NotNullText(pointsViewItem.spot)  { hasContent = true }
        if NotNullText(pointsViewItem.brief)  { hasContent = true }
        if NotNullText(pointsViewItem.pain)  { hasContent = true }
        if NotNullText(pointsViewItem.members)  { hasContent = true }
        if NotNullText(pointsViewItem.bussiness)  { hasContent = true }
        if NotNullText(pointsViewItem.marketing)  { hasContent = true }
        if NotNullText(pointsViewItem.spot)  { hasContent = true }
        if NotNullText(pointsViewItem.exit)  { hasContent = true }
        
        if hasContent {
            Confirmer.show("返回确认", message: "返回将不会保存，确认返回？", confirm: "返回", confirmHandler: { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
                }, cancel: "继续修改", cancelHandler: {
            }, inVc: self)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }

    func handleSave() {
        view.endEditing(true)
        
        if NullText(relationItem.text) && !isOtherModel {
            QXTiper.showWarning("请选择\(SafeUnwarp(relationItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(nameItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(nameItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(companyItem.subTitle) {
            QXTiper.showWarning("请选择\(SafeUnwarp(companyItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(dealTypeItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(dealTypeItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(cityItem.subTitle) {
            QXTiper.showWarning("请选择\(SafeUnwarp(cityItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(commissionItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(commissionItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(industriesItem.subTitle) {
            QXTiper.showWarning("请选择\(SafeUnwarp(industriesItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        
        if NullText(nowRoundItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(nowRoundItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if moneyTypeItem.tags.count <= 0 {
            QXTiper.showWarning("请选择\(SafeUnwarp(moneyTypeItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(moneyCurrencyItem.text) {
            QXTiper.showWarning("请选择\(SafeUnwarp(moneyCurrencyItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(moneyItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(moneyItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
        if NullText(stockRateAfterItem.text) {
            QXTiper.showWarning("请填写\(SafeUnwarp(stockRateAfterItem.title, holderForNull: ""))", inView: self.view, cover: true)
            return;
        }
//        if NullText(lastRoundItem.text) {
//            QXTiper.showWarning("请选择\(SafeUnwarp(lastRoundItem.title, holderForNull: ""))", inView: self.view, cover: true)
//            return;
//        }
        
        if NullText(pointsViewItem.brief) {
            QXTiper.showWarning("请填写产品概况", inView: self.view, cover: true)
            return;
        }
        if NullText(pointsViewItem.spot) {
            QXTiper.showWarning("请填写项目亮点", inView: self.view, cover: true)
            return;
        }
//        if NullText(pointsViewItem.pain) {
//            QXTiper.showWarning("请填写行业痛点", inView: self.view, cover: true)
//            return;
//        }
//        if NullText(pointsViewItem.members) {
//            QXTiper.showWarning("请填写创始团队", inView: self.view, cover: true)
//            return;
//        }
//        if NullText(pointsViewItem.bussiness) {
//            QXTiper.showWarning("请填写商业模式", inView: self.view, cover: true)
//            return;
//        }
//        if NullText(pointsViewItem.marketing) {
//            QXTiper.showWarning("请填写运营数据", inView: self.view, cover: true)
//            return;
//        }
//        if NullText(pointsViewItem.spot) {
//            QXTiper.showWarning("请填写市场状况", inView: self.view, cover: true)
//            return;
//        }
//        if NullText(pointsViewItem.exit) {
//            QXTiper.showWarning("请填写退出方案", inView: self.view, cover: true)
//            return;
//        }
        
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
        let attachment = ArticleProjectAttachments()
        
        attachment.userType = me.roleType
        
        if isOtherModel {
             attachment.signedIssue = "NULL"
        } else {
            if isFAMode {
                attachment.signedIssue = TinSearch(name: relationItem.text, inKeys: kFAProjectSignedIssueKeys)?.code
            } else {
                attachment.signedIssue = TinSearch(name: relationItem.text, inKeys: kCompanySignedIssueKeys)?.code
            }
        }
        attachment.name = nameItem.text

        attachment.companyId = organization?.id
        attachment.companyName = companyItem.subTitle
        
        attachment.dealType = TinSearch(name: dealTypeItem.text, inKeys: kProjectDealTypeKeys)?.code
        attachment.location = cityItem.subTitle
        if let t = commissionItem.text {
            attachment.commission = (t as NSString).doubleValue
        }
        
        attachment.industries = industries
        
        if dealTypeItem.text == "VC/PE融资" {
            attachment.currentRound = TinSearch(name: nowRoundItem.text, inKeys: kProjectInvestTypeKeys)?.code
        } else if dealTypeItem.text == "并购收购" {
            attachment.currentRound = TinSearch(name: nowRoundItem.text, inKeys: kProjectMergeTypeKeys)?.code
        }
        if dealTypeItem.text == "VC/PE融资" {
            attachment.lastRound = TinSearch(name: lastRoundItem.text, inKeys: kProjectInvestTypeKeys)?.code
        } else if dealTypeItem.text == "并购收购" {
            attachment.lastRound = TinSearch(name: lastRoundItem.text, inKeys: kProjectMergeTypeKeys)?.code
        }

        var preferCurrency = [Int]()
        for tag in moneyTypeItem.tags {
            if tag == 0 {
                if let c = TinSearch(name: "人民币", inKeys: kCurrencyTypeKeys)?.code {
                    preferCurrency.append(c)
                }
            } else if tag == 1 {
                if let c = TinSearch(name: "美元", inKeys: kCurrencyTypeKeys)?.code {
                    preferCurrency.append(c)
                }
            } else if tag == 2 {
                if let c = TinSearch(name: "欧元", inKeys: kCurrencyTypeKeys)?.code {
                    preferCurrency.append(c)
                }
            }
        }
        attachment.preferCurrency = preferCurrency
        attachment.currency = TinSearch(name: moneyCurrencyItem.text, inKeys: kCurrencyTypeKeys)?.code
        attachment.currencyAmount = Double(StaticCellTools.textToNumber(origenText: moneyItem.text))
        
        if let t = stockRateAfterItem.text {
            attachment.investStockRatio = (t as NSString).doubleValue
        }
        
        attachment.spot = pointsViewItem.spot
        attachment.brief = pointsViewItem.brief
        attachment.pain = pointsViewItem.pain
        attachment.members = pointsViewItem.members
        attachment.bussiness = pointsViewItem.bussiness
        attachment.data = pointsViewItem.data
        attachment.marketing = pointsViewItem.marketing
        attachment.exit = pointsViewItem.exit
        
        attachment.detailPublic = publicItem.isOn
        
        if pointsViewItem.images.count > 0 {
            
            ArticleManager.shareInstance.uploadImages(me, images: pointsViewItem.images, success: { [weak self] (code, msg, pictures) in
                if code == 0 {
                    ArticleManager.shareInstance.publishProject(me, attachments: attachment, pics: pictures, horn: self?.hornItem.horn, success: { [weak self] (code, message, ret) in
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
                } else {
                    done()
                    QXTiper.showWarning(msg, inView: self?.view, cover: true)
                }
            }) { [weak self] (error) in
                done()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
            }
            
        } else {
            ArticleManager.shareInstance.publishProject(me, attachments: attachment, pics: nil, horn: self.hornItem.horn, success: { [weak self] (code, message, ret) in
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
    
}

class MoneyInputItem: StaticCellBaseItem {
    
    var title: String?
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var titleColor: UIColor = HEX("#666666")
    /// 采用富文本覆盖上面的内容
    var attributeTitle: NSAttributedString?
    
    var tags: [Int] = [Int]()
    var respondTags: ((_ tags: [Int]) -> ())?
    
}

class MoneyInputCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? MoneyInputItem {
            if let attr = item.attributeTitle {
                titleLabel.attributedText = attr
            } else {
                titleLabel.font = item.titleFont
                titleLabel.text = item.title
                titleLabel.textColor = item.titleColor
            }
            icon0.image = UIImage(named: "radioBox")
            icon1.image = UIImage(named: "radioBox")
            icon2.image = UIImage(named: "radioBox")
            for tag in item.tags {
                if tag == 0 {
                    icon0.image = UIImage(named: "radioBoxSelect")
                } else if tag == 1 {
                    icon1.image = UIImage(named: "radioBoxSelect")
                } else if tag == 2 {
                    icon2.image = UIImage(named: "radioBoxSelect")
                }
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        return one
    }()

    lazy var icon0: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "radioBoxSelect")
        return one
    }()
    lazy var label0: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = UIFont.systemFont(ofSize: 13)
        return one
    }()
    lazy var icon1: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "radioBox")
        return one
    }()
    lazy var label1: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = UIFont.systemFont(ofSize: 13)
        return one
    }()
    lazy var icon2: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "radioBox")
        return one
    }()
    lazy var label2: UILabel = {
        let one = UILabel()
        one.textColor = kClrDeepGray
        one.font = UIFont.systemFont(ofSize: 13)
        return one
    }()
    lazy var btn0: UIButton = {
        let one = UIButton()
        one.tag = 0
        one.addTarget(self, action: #selector(MoneyInputCell.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btn1: UIButton = {
        let one = UIButton()
        one.tag = 1
        one.addTarget(self, action: #selector(MoneyInputCell.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    lazy var btn2: UIButton = {
        let one = UIButton()
        one.tag = 2
        one.addTarget(self, action: #selector(MoneyInputCell.btnClick(_:)), for: .touchUpInside)
        return one
    }()
    func btnClick(_ sender: UIButton) {
        let btnTag = sender.tag
        
        if let item = item as? MoneyInputItem {
            
            var idx: Int?
            for i in 0..<item.tags.count {
                if item.tags[i] == btnTag {
                    idx = i
                }
            }
            if let idx = idx {
                if item.tags.count > 1 {
                    item.tags.remove(at: idx)
                }
            } else {
                item.tags.append(btnTag)
            }
            tableView.reloadData()
            item.respondTags?(item.tags)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon0)
        contentView.addSubview(label0)
        contentView.addSubview(btn0)
        contentView.addSubview(icon1)
        contentView.addSubview(label1)
        contentView.addSubview(btn1)
        contentView.addSubview(icon2)
        contentView.addSubview(label2)
        contentView.addSubview(btn2)
        
        titleLabel.IN(contentView).LEFT(12.5).CENTER.WIDTH(100).MAKE()

        btn2.IN(contentView).RIGHT.CENTER.OFFSET(12.5).SIZE(60, 40).MAKE()
        btn1.LEFT(btn2).CENTER.SIZE(60, 40).MAKE()
        btn0.LEFT(btn1).CENTER.SIZE(70, 40).MAKE()

        icon0.IN(btn0).LEFT.CENTER.SIZE(15, 15).MAKE()
        icon1.IN(btn1).LEFT.CENTER.SIZE(15, 15).MAKE()
        icon2.IN(btn2).LEFT.CENTER.SIZE(15, 15).MAKE()

        label0.RIGHT(icon0).OFFSET(5).CENTER.MAKE()
        label1.RIGHT(icon1).OFFSET(5).CENTER.MAKE()
        label2.RIGHT(icon2).OFFSET(5).CENTER.MAKE()
        
        label0.text = "人民币"
        label1.text = "美元"
        label2.text = "欧元"
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ProjectPointsViewItem: StaticCellBaseItem {
    
    var spot: String?
    var brief: String?
    var pain: String?
    var members: String?
    var bussiness: String?
    var data: String?
    var marketing: String?
    var exit: String?
    
    var images: [UIImage] = [UIImage]()

    var respondSpot: (() -> ())?
    var respondBrief: (() -> ())?
    var respondPain: (() -> ())?
    var respondMembers: (() -> ())?
    var respondBussiness: (() -> ())?
    var respondData: (() -> ())?
    var respondMaketing: (() -> ())?
    var respondExit: (() -> ())?

    override init() {
        super.init()
        cellHeight = ProjectPointsView.height
    }
}

class ProjectPointsViewCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? ProjectPointsViewItem {
            pointsView.heightlightSpot(NotNullText(item.spot))
            pointsView.heightlightBrief(NotNullText(item.brief))
            pointsView.heightlightPain(NotNullText(item.pain))
            pointsView.heightlightMembers(NotNullText(item.members))
            pointsView.heightlightBussiness(NotNullText(item.bussiness))
            pointsView.heightlightData(NotNullText(item.data))
            pointsView.heightlightMarketing(NotNullText(item.marketing))
            pointsView.heightlightExit(NotNullText(item.exit))
        }
    }
    
    lazy var pointsView: ProjectPointsView = {
        let one = ProjectPointsView()
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pointsView)
        pointsView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        pointsView.spotBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondSpot?()
        }
        pointsView.briefBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondBrief?()
        }
        pointsView.painBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondPain?()
        }
        pointsView.memebersBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondMembers?()
        }
        pointsView.bussinessBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondBussiness?()
        }
        pointsView.dataBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondData?()
        }
        pointsView.marketingBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondMaketing?()
        }
        pointsView.exitBtn.signal_event_touchUpInside.head { [unowned self] (s) in
            (self.item as? ProjectPointsViewItem)?.respondExit?()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
