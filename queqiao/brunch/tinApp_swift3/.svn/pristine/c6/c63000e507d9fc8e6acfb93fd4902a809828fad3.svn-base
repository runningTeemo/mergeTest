//
//  IndustryPickerViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/23.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class IndustryPickerViewController: StaticCellBaseViewController {
    
    var mutiMode: Bool = false
    var respondIndustries: ((_ industries: [Industry]) -> ())?
    var pickOnesOnInit: [Industry]?
    
    fileprivate var selectIdxes: [Int] = [Int]()
    fileprivate var industries: [Industry] = [Industry]()
    
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
        let one = BarButtonItem(title: "确定", responder: { [unowned self] in
            self.handleConfirm()
        })
        return one
    }()
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        
        ArticleManager.shareInstance.getIndustries({ [weak self] (code, msg, industries) in
            if code == 0 {
                if let s = self {
                    var industries = industries!
                    industries = s.filt(allIndustries: industries)
                    if let pickOnesOnInit = s.pickOnesOnInit {
                        s.selectIdxes = s.filtSelects(industries: industries, selectIndustries: pickOnesOnInit)
                    }
                    if industries.count == 0 {
                        done(.empty)
                        s.removeRightNavItems()
                    } else {
                        s.setupRightNavItems(items: s.saveNavItem)
                        done(.noMore)
                    }
                    s.industries = industries
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
    
    func filt(allIndustries: [Industry]) -> [Industry] {
        
        if !Account.sharedOne.isLogin {
            return allIndustries
        }
        
        var industries = [Industry]()
        if let oi = Account.sharedOne.user.industry {
            industries.append(oi)
        }
        industries += Account.sharedOne.user.industries
        
        var resultIndustries = [Industry]()
        resultIndustries += industries
        for industry in allIndustries {
            var notExist: Bool = true
            for myInd in industries {
                if SafeUnwarp(myInd.id, holderForNull: "") == SafeUnwarp(industry.id, holderForNull: "") {
                    notExist = false
                }
            }
            if notExist {
                resultIndustries.append(industry)
            }
        }
        
        // 去重后返回
        return QXDistinct(arr: resultIndustries, compare: { i1 , i2 in
            return i1.id == i2.id
        })
        
    }
    
    func filtSelects(industries: [Industry], selectIndustries: [Industry]) -> [Int] {
        var idxs = [Int]()
        for i in 0..<industries.count {
            let industry = industries[i]
            for ind in selectIndustries {
                if SafeUnwarp(industry.id, holderForNull: "") == SafeUnwarp(ind.id, holderForNull: "") {
                    idxs.append(i)
                    self.industries.append(industry)
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
        setupNavBackBlackButton(nil)
        setupRightNavItems(items: saveNavItem)

        staticItems = [topSpaceItem, headerItem, industriesItem, bottomSpaceItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
        showNav()
    }
    
    func update() {
        title = "选择行业"
        if mutiMode {
            if !editChanged {
                headerItem.attriText = StringTool.makeAttributeString("选择行业:", dic: self.headNorAttriDic)
                industriesItem.mutiMode = true
                industriesItem.selectLimit = 6
                industriesItem.update()
            } else {
                let mAttri = NSMutableAttributedString()
                mAttri.append(StringTool.makeAttributeString("选择行业: 已选", dic: self.headNorAttriDic)!)
                mAttri.append(StringTool.makeAttributeString("\(selectIdxes.count)", dic: self.headAlertAttriDic)!)
                mAttri.append(StringTool.makeAttributeString("个", dic: self.headNorAttriDic)!)
                headerItem.attriText = mAttri
            }
            headerItem.update()
        } else {
            if !editChanged {
                headerItem.attriText = StringTool.makeAttributeString("选择行业:", dic: self.headNorAttriDic)
                industriesItem.mutiMode = false
                industriesItem.update()
            } else {
                if let idx = selectIdxes.first {
                    if industries.count > idx + 1 {
                        let industry = industries[idx]
                        let mAttri = NSMutableAttributedString()
                        mAttri.append(StringTool.makeAttributeString("选择行业: ", dic: self.headNorAttriDic)!)
                        mAttri.append(StringTool.makeAttributeString(SafeUnwarp(industry.name, holderForNull: ""), dic: self.headAlertAttriDic)!)
                        headerItem.attriText = mAttri
                    }
                }
            }
            headerItem.update()
        }
        tableView.reloadData()
    }
    
    func handleConfirm() {
        respondIndustries?(getSelectIndustries())
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getSelectIndustries() -> [Industry] {
        var industries = [Industry]()
        for idx in selectIdxes {
            let industry = self.industries[idx]
            industries.append(industry)
        }
        return industries
    }
    
}
