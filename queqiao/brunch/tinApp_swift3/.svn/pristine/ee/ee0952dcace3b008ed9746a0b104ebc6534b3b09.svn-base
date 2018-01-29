//
//  SetIndustryViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SetIndustryViewController: StaticCellBaseViewController {
    
    var isAttentionMode: Bool = true
    fileprivate var selectIdxes: [Int] = [Int]()
    fileprivate var industries: [Industry] = [Industry]()
    
    weak var vcBefore: RootTableViewController?
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    let headNorAttriDic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: 16), color: kClrSubTitle)
    let headAlertAttriDic = StringTool.makeAttributeDic(UIFont.systemFont(ofSize: 16), color: kClrSubTitle)
    lazy var headerItem: StaticCellTextItem = {
        let one = StaticCellTextItem()
        one.backColor = kClrWhite
        one.topMargin = 10
        one.bottomMargin = 10
        one.showBottomLine = true
        one.update()
        return one
    }()
    
    lazy var industriesItem: StaticCellLabelsPickerItem = {
        let one = StaticCellLabelsPickerItem()
        one.respondSelectChange = { [unowned self] selectIdxes, lastIdx in
            self.selectIdxes = selectIdxes
            self.editChanged = true
            self.update()
        }
        one.respondLimit = { [weak self] in
            QXTiper.showWarning("最多选6个", inView: self?.view, cover: true)
        }
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
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
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        ArticleManager.shareInstance.getIndustries({ [weak self] (code, msg, industries) in
            if code == 0 {
                if let s = self {
                    var industries = industries!
                    industries = s.filt(industries: industries)
                    if industries.count == 0 {
                        done(.empty)
                        s.removeRightNavItems()
                    } else {
                        s.setupRightNavItems(items: s.saveNavItem)
                        done(.noMore)
                    }
                    s.industries = industries
                    s.selectIdxes = s.filtSelects(industries: industries)
                    s.industriesItem.labels = industries.map({ $0 as labelProtocol })
                    s.industriesItem.selectIdxes = s.selectIdxes
                    s.industriesItem.update()
                    s.tableView.reloadData()
                }
            } else {
                done(.err)
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
                self?.removeRightNavItems()
            }
            }) { [weak self] (error) in
               done(.err)
                self?.removeRightNavItems()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
    }
    
    func filt(industries: [Industry]) -> [Industry] {
        if isAttentionMode {
            if Account.sharedOne.isLogin {
                if let industry = Account.sharedOne.user.industry {
                    var newIndustries = [Industry]()
                    for i in industries {
                        if SafeUnwarp(i.id, holderForNull: "") != SafeUnwarp(industry.id, holderForNull: "") {
                            newIndustries.append(i)
                        }
                    }
                    return newIndustries
                }
            }
        }
        return industries
    }
    
    func filtSelects(industries: [Industry]) -> [Int] {
        var idxs = [Int]()
        if Account.sharedOne.isLogin {
            if isAttentionMode {
                for i in 0..<industries.count {
                    let industry = industries[i]
                    for ind in Account.sharedOne.user.industries {
                        if SafeUnwarp(industry.id, holderForNull: "") == SafeUnwarp(ind.id, holderForNull: "") {
                            idxs.append(i)
                            self.industries.append(industry)
                        }
                    }
                }
            } else {
                for i in 0..<industries.count {
                    let industry = industries[i]
                    if let meIndustry = Account.sharedOne.user.industry {
                        if SafeUnwarp(industry.id, holderForNull: "") == SafeUnwarp(meIndustry.id, holderForNull: "") {
                            idxs.append(i)
                            self.industries.append(industry)
                        }
                    }
                }
            }
        }
        return idxs
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        setupRefreshHeader()
        loadDataOnFirstWillAppear = true
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
        staticItems = [topSpaceItem, headerItem, industriesItem, bottomSpaceItem]

        setupRightNavItems(items: saveNavItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
        showNav()
    }
    
    func update() {
        if isAttentionMode {
            title = "设置关注行业"
            if !editChanged {
                headerItem.attriText = StringTool.makeAttributeString("选择关注行业:", dic: self.headNorAttriDic)
                industriesItem.mutiMode = true
                industriesItem.selectLimit = 6
                industriesItem.update()
            } else {
                let mAttri = NSMutableAttributedString()
                mAttri.append(StringTool.makeAttributeString("选择关注行业: 已选", dic: self.headNorAttriDic)!)
                mAttri.append(StringTool.makeAttributeString("\(selectIdxes.count)", dic: self.headAlertAttriDic)!)
                mAttri.append(StringTool.makeAttributeString("个", dic: self.headNorAttriDic)!)
                headerItem.attriText = mAttri
            }
            headerItem.update()
        } else {
            title = "设置所属行业"
            if !editChanged {
                headerItem.attriText = StringTool.makeAttributeString("选择所属行业:", dic: self.headNorAttriDic)
                industriesItem.mutiMode = false
                industriesItem.update()
            } else {
                if let idx = selectIdxes.first {
                    if industries.count > idx + 1 {
                        let industry = industries[idx]
                        let mAttri = NSMutableAttributedString()
                        mAttri.append(StringTool.makeAttributeString("选择所属行业: ", dic: self.headNorAttriDic)!)
                        mAttri.append(StringTool.makeAttributeString(SafeUnwarp(industry.name, holderForNull: ""), dic: self.headAlertAttriDic)!)
                        headerItem.attriText = mAttri
                    }
                }
            }
            headerItem.update()
        }
        tableView.reloadData()
    }
    
    func handleBack() {
        if editChanged {
            Confirmer.show("返回确认", message: "返回将不会保存设置，确认返回？", confirm: "返回", confirmHandler: { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
                }, cancel: "继续修改", cancelHandler: {
                }, inVc: self)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func handleSave() {
        
        if !editChanged {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        if isAttentionMode {
            if getSelectIndustries().count > 0 {
                setupRightNavItems(items: loadingNavItem)
                let wait = QXTiper.showWaiting("修改中...", inView: view, cover: true)
                saveAttentionIndustries { [weak self] in
                    QXTiper.hideWaiting(wait)
                    self?.setupRightNavItems(items: self?.saveNavItem)
                }
            } else {
                QXTiper.showWarning("行业不能为空", inView: self.view, cover: true)
            }

        } else {
            if getSelectIndustries().count > 0 {
                setupRightNavItems(items: loadingNavItem)
                let wait = QXTiper.showWaiting("修改中...", inView: view, cover: true)
                savePartyIndustry({ [weak self] in
                    QXTiper.hideWaiting(wait)
                    self?.setupRightNavItems(items: self?.saveNavItem)
                    })
            } else {
                QXTiper.showWarning("请选择一个行业", inView: self.view, cover: true)
            }
        }
        
    }
    
    func getSelectIndustries() -> [Industry] {
        var industries = [Industry]()
        for idx in selectIdxes {
            let industry = self.industries[idx]
            industries.append(industry)
        }
        return industries
    }
    
    func saveAttentionIndustries(_ done: @escaping (() -> ())) {
        
        if !Account.sharedOne.isLogin {
            done()
            return
        }
        
        let user = Account.sharedOne.user
        let industries = getSelectIndustries()
        
        ArticleManager.shareInstance.setAttentionIndustries(user, industries: industries, success: { [weak self] (code, message, ret) in
            if code == 0 {
                QXTiper.showSuccess("设置成功", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                    if Account.sharedOne.isLogin {
                        Account.sharedOne.user.industries = industries
                        Account.sharedOne.saveUser()
                    }
                    self?.vcBefore?.clearFirstInStatus()
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
    
    func savePartyIndustry(_ done: @escaping (() -> ())) {
        
        if !Account.sharedOne.isLogin {
            done()
            return
        }
        
        let user = Account.sharedOne.user
        let industry = getSelectIndustries().first!

        ArticleManager.shareInstance.setPartyIndustry(user, industry: industry, success: { [weak self] (code, msg, ret) in
            if code == 0 {
                QXTiper.showSuccess("设置成功", inView: self?.view, cover: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                    _ = self?.navigationController?.popViewController(animated: true)
                    
                    if Account.sharedOne.isLogin {
                        Account.sharedOne.user.industry = industry
                        Account.sharedOne.saveUser()
                    }
                    
                    self?.vcBefore?.clearFirstInStatus()
                }
            } else {
                QXTiper.showWarning(msg, inView: self?.view, cover: true)
            }
            done()
            }) { [weak self] (error) in
                done()
                QXTiper.showFailed(kWebErrMsg + "(\(error.code))", inView: self?.view, cover: true)
        }
        
        
    }
    
}
