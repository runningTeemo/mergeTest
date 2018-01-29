//
//  ArticleFilteProjectViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleFilteProjectViewController: RootFilterViewController {
    
    func reset() {
        checkOrResetLabelItem(industriesItem)
        checkOrResetLabelItem(typeItem)
        checkOrResetLabelItem(roundsItem)
        checkOrResetLabelItem(currencyItem)
        checkOrResetLabelItem(amountItem)
        checkOrResetLabelItem(rolesItem)
        tableView.reloadData()
        
        updateIndustries()
        updateDealType()
        updateRounds()
        updateCurrency()
        updateAmount()
        updateRoles()
    }
    
    var filterModel: ArticleFilter!
    var respondConfirm: (() -> ())?
    
    //MARK: 行业
    
    lazy var industriesSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "行业"
        one.totalWidth = kScreenW - 100
        one.items = [self.industriesItem, self.industriesBottomSpaceItem]
        return one
    }()
    
    lazy var industriesItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateIndustries()
        }
        return one
    }()
    lazy var industriesBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    
    //MARK: 交易类型
    
    lazy var typeSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "交易类型"
        one.totalWidth = kScreenW - 100
        one.items = [self.typeItem, self.typeBottomSpaceItem]
        return one
    }()
    
    lazy var typeItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = false
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutualSelect(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateDealType()
        }
        return one
    }()
    lazy var typeBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    //MARK: 轮次
    
    lazy var roundsSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "轮次"
        one.totalWidth = kScreenW - 100
        one.items = [self.roundsItem, self.roundsBottomSpaceItem]
        return one
    }()
    
    lazy var roundsItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateRounds()
        }
        return one
    }()
    lazy var roundsBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    
    //MARK: 币种
    
    lazy var currencySectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "币种"
        one.totalWidth = kScreenW - 100
        one.items = [self.currencyItem, self.currencyBottomSpaceItem]
        return one
    }()
    
    lazy var currencyItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateCurrency()
        }
        return one
    }()
    lazy var currencyBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    
    //MARK: 金额
    
    lazy var amountSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "金额(元)"
        one.totalWidth = kScreenW - 100
        one.items = [self.amountItem, self.amountBottomSpaceItem]
        return one
    }()
    
    lazy var amountItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = false
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            one.selectIdxes = selectIdxes
            self.updateAmount()
        }
        return one
    }()
    lazy var amountBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    
    //MARK: 发布人
    
    lazy var rolesSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "发布人"
        one.totalWidth = kScreenW - 100
        one.items = [self.rolesItem, self.rolesBottomSpaceItem]
        return one
    }()
    
    lazy var rolesItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = false
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateRoles()
        }
        return one
    }()
    lazy var rolesBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        items = [industriesSectionItem, typeSectionItem, currencySectionItem, amountSectionItem, rolesSectionItem]        
    }

    override func loadData(_ done: @escaping LoadingDataDone) {
        ArticleManager.shareInstance.getIndustries({ [weak self] (code, msg, inds) in
            if code == 0 {
                self?.handleWebData(inds!)
                done(.noMore)
            } else {
                done(.err)
            }
        }) { (error) in
            done(.err)
        }
    }
    
    var investLabels: [FilterNameLabel]?
    var mergeLabels: [FilterNameLabel]?
    func handleWebData(_ industries: [Industry]) {
        
        do {
            if industries.count > 0 {
                var labels = [FilterNameLabel]()
                labels.append(FilterNameLabel(name: "全部", content: "-1"))
                for industry in industries {
                    let label = FilterNameLabel(name: industry.name, content: industry.id)
                    labels.append(label)
                }
                industriesItem.labels = labels.map({ $0 as labelProtocol })
                industriesItem.selectIdxes = [0]
            } else {
                industriesItem.labels = nil
                industriesItem.selectIdxes.removeAll()
            }
            industriesItem.update()
        }
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kProjectDealTypeKeys) {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            typeItem.labels = labels.map({ $0 as labelProtocol })
            typeItem.selectIdxes = [0]
            typeItem.update()
        }
        
        do {
            var investLabels = [FilterNameLabel]()
            investLabels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kProjectInvestTypeKeys) {
                let label = FilterNameLabel(name: key, content: "")
                investLabels.append(label)
            }
            self.investLabels = investLabels
            
            var mergeLabels = [FilterNameLabel]()
            mergeLabels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kProjectMergeTypeKeys) {
                let label = FilterNameLabel(name: key, content: "")
                mergeLabels.append(label)
            }
            self.mergeLabels = mergeLabels
        }
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kCurrencyTypeKeys) {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            currencyItem.labels = labels.map({ $0 as labelProtocol })
            currencyItem.selectIdxes = [0]
            currencyItem.update()
        }
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kProjectMoneyAmountKeys) {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            amountItem.labels = labels.map({ $0 as labelProtocol })
            amountItem.selectIdxes = [0]
            amountItem.update()
        }
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kProjectUserRoleTypeKeys) {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            rolesItem.labels = labels.map({ $0 as labelProtocol })
            rolesItem.selectIdxes = [0]
            rolesItem.update()
        }
        
        tableView.reloadData()
    }
    
    
    func updateIndustries() {
        let labels = getSelectLabels(industriesItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.industries.removeAll()
            } else {
                var inds = [Industry]()
                for label in labels {
                    let ind = Industry()
                    ind.name = label.name
                    ind.id = label.content
                    inds.append(ind)
                }
                filterModel.industries = inds
            }
            
        } else {
            filterModel.industries.removeAll()
        }
    }
    
    func updateDealType() {
        
        if let label = getSelectLabels(typeItem).first {
   
            if label.name == "VC/PE融资" {
                if let code = TinSearch(name: label.name, inKeys: kProjectDealTypeKeys)?.code {
                    filterModel.dealTypes = [code]
                }
                
                roundsItem.labels = investLabels?.map({ $0 as labelProtocol })
                roundsItem.selectIdxes = [0]
                roundsItem.update()
                filterModel.rounds.removeAll()
                
                self.items = [industriesSectionItem, typeSectionItem, roundsSectionItem, currencySectionItem, amountSectionItem, rolesSectionItem]
                self.tableView.reloadData()
                
                self.roundKeys = kProjectInvestTypeKeys
                
            } else if label.name == "并购收购" {
                if let code = TinSearch(name: label.name, inKeys: kProjectDealTypeKeys)?.code {
                    filterModel.dealTypes = [code]
                }
                roundsItem.labels = mergeLabels?.map({ $0 as labelProtocol })
                roundsItem.selectIdxes = [0]
                roundsItem.update()
                filterModel.rounds.removeAll()

                self.items = [industriesSectionItem, typeSectionItem, roundsSectionItem, currencySectionItem, amountSectionItem, rolesSectionItem]
                self.tableView.reloadData()
                
                self.roundKeys = kProjectMergeTypeKeys

            } else {
                filterModel.dealTypes.removeAll()
                filterModel.rounds.removeAll()
                self.items = [industriesSectionItem, typeSectionItem, currencySectionItem, amountSectionItem, rolesSectionItem]
                self.tableView.reloadData()
            }
        }
    }
    
    var roundKeys: [TinKey<Int>]!
    func updateRounds() {
        let labels = getSelectLabels(roundsItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.rounds.removeAll()
            } else {
                var rounds = [Int]()
                for label in labels {
                    if let code = TinSearch(name: label.name, inKeys: roundKeys)?.code {
                        rounds.append(code)
                    }
                }
                filterModel.rounds = rounds
            }
        } else {
            filterModel.rounds.removeAll()
        }
    }
    
    func updateCurrency() {
        let labels = getSelectLabels(currencyItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.currency.removeAll()
            } else {
                var currencys = [Int]()
                for label in labels {
                    if let code = TinSearch(name: label.name, inKeys: kCurrencyTypeKeys)?.code {
                        currencys.append(code)
                    }
                }
                filterModel.currency = currencys
            }
        } else {
            filterModel.currency.removeAll()
        }
    }
    
    
    func updateAmount() {
        let labels = getSelectLabels(amountItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.minAmount = -1
                filterModel.maxAmount = -1
            } else if first.name == "<500万" {
                filterModel.minAmount = 0
                filterModel.maxAmount = 5000000
            } else if first.name == "500~3000万" {
                filterModel.minAmount = 5000000
                filterModel.maxAmount = 30000000
            } else if first.name == "3000~9999万" {
                filterModel.minAmount = 30000000
                filterModel.maxAmount = 99999999
            } else if first.name == "1~5亿" {
                filterModel.minAmount = 100000000
                filterModel.maxAmount = 500000000
            } else if first.name == "5~10亿" {
                filterModel.minAmount = 500000000
                filterModel.maxAmount = 1000000000
            } else if first.name == "10亿以上" {
                filterModel.minAmount = 1000000000
                filterModel.maxAmount = -1
            } else {
                filterModel.minAmount = -1
                filterModel.maxAmount = -1
            }
        } else {
            filterModel.minAmount = -1
            filterModel.maxAmount = -1
        }
    }
    
    func updateRoles() {
        let labels = getSelectLabels(rolesItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.authorRoles.removeAll()
            } else {
                var authorRoles = [Int]()
                for label in labels {
                    if let code = TinSearch(name: label.name, inKeys: kProjectUserRoleTypeKeys)?.code {
                        authorRoles.append(code)
                    }
                }
                filterModel.authorRoles = authorRoles
            }
        } else {
            filterModel.authorRoles.removeAll()
        }
    }
    
    
    override func handleRed() {
        self.respondConfirm?()
    }
    
    override func handleBlue() {
        
        industriesItem.selectIdxes = [0]
        industriesItem.update()
        filterModel.industries.removeAll()
        
        typeItem.selectIdxes = [0]
        typeItem.update()
        
        roundsItem.selectIdxes = [0]
        roundsItem.update()
        
        filterModel.dealTypes.removeAll()
        filterModel.rounds.removeAll()
        self.items = [industriesSectionItem, typeSectionItem, currencySectionItem, amountSectionItem, rolesSectionItem]
        
        currencyItem.selectIdxes = [0]
        currencyItem.update()
        filterModel.currency.removeAll()
        
        amountItem.selectIdxes = [0]
        amountItem.update()
        filterModel.minAmount = -1
        filterModel.maxAmount = -1

        rolesItem.selectIdxes = [0]
        rolesItem.update()
        filterModel.authorRoles.removeAll()
        
        tableView.reloadData()
    }
    
}
