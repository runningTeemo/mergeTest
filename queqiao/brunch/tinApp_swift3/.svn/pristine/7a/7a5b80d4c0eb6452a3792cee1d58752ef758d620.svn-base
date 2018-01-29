//
//  ArticleFilteManPowerViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleFilteManPowerViewController: RootFilterViewController {
    
    func reset() {
        checkOrResetLabelItem(dutyItem)
        checkOrResetLabelItem(yearLimitItem)
        checkOrResetLabelItem(degreeLimitItem)
        checkOrResetLabelItem(salaryItem)
        tableView.reloadData()
        
        updateDuties()
        updateAges()
        updateDegrees()
        updateSalarys()
    }
    
    var filterModel: ArticleFilter!
    var respondConfirm: (() -> ())?

    //MARK: 职位
    
    lazy var dutySectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "职位"
        one.totalWidth = kScreenW - 100
        one.items = [self.dutyItem, self.dutyBottomSpaceItem]
        return one
    }()
    
    lazy var dutyItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateDuties()
        }
        return one
    }()
    lazy var dutyBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        return one
    }()
    
    
    //MARK: 要求年限
    
    lazy var yearLimitSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "要求年限"
        one.totalWidth = kScreenW - 100
        one.items = [self.yearLimitItem, self.yearLimitBottomSpaceItem]
        return one
    }()
    
    lazy var yearLimitItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateAges()
        }
        return one
    }()
    lazy var yearLimitBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    
    //MARK: 要求学历
    
    lazy var degreeLimitSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "要求学历"
        one.totalWidth = kScreenW - 100
        one.items = [self.degreeLimitItem, self.degreeLimitBottomSpaceItem]
        return one
    }()
    
    lazy var degreeLimitItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateDegrees()
        }
        return one
    }()
    lazy var degreeLimitBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    
    
    //MARK: 薪水
    
    lazy var salarySectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "薪水"
        one.totalWidth = kScreenW - 100
        one.items = [self.salaryItem, self.salaryBottomSpaceItem]
        return one
    }()
    
    lazy var salaryItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.totalWidth = kScreenW - 100
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateSalarys()
        }
        return one
    }()
    lazy var salaryBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        items = [dutySectionItem, yearLimitSectionItem, degreeLimitSectionItem, salarySectionItem]
        
    }

    var duties: [String] = [String]()
    override func loadData(_ done: @escaping LoadingDataDone) {
        DispatchQueue.global().async { [weak self] in
            var viewModels = [PositionViewModel]()
            for model in PositionsDataEntry.sharedOne.models {
                let vm = PositionViewModel(model: model)
                viewModels.append(vm)
            }
            var duties = [String]()
            for m in viewModels {
                for sm in m.subModels {
                    if let name = sm.model.name {
                        duties.append(name)
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.duties = duties
                done(.noMore)
                self?.handleLoadData()
            }
        }
    }
    
    func handleLoadData() {
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in duties {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            dutyItem.labels = labels.map({ $0 as labelProtocol })
            dutyItem.selectIdxes = [0]
            dutyItem.update()
        }
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kManPowerYearKeys) {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            yearLimitItem.labels = labels.map({ $0 as labelProtocol })
            yearLimitItem.selectIdxes = [0]
            yearLimitItem.update()
        }
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kManPowerDegreeKeys) {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            degreeLimitItem.labels = labels.map({ $0 as labelProtocol })
            degreeLimitItem.selectIdxes = [0]
            degreeLimitItem.update()
        }
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in TinGetNames(keys: kManPowerSalaryKeys) {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            salaryItem.labels = labels.map({ $0 as labelProtocol })
            salaryItem.selectIdxes = [0]
            salaryItem.update()
        }
        
        tableView.reloadData()
    }

    
    func updateDuties() {
        let labels = getSelectLabels(dutyItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.duties.removeAll()
            } else {
                var duties = [String]()
                for label in labels {
                    if let name = label.name {
                        duties.append(name)
                    }
                }
                filterModel.duties = duties
            }
        } else {
            filterModel.duties.removeAll()
        }
    }
    
    func updateAges() {
        let labels = getSelectLabels(yearLimitItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.reqAges.removeAll()
            } else {
                var ages = [Int]()
                for label in labels {
                    if let code = TinSearch(name: label.name, inKeys: kManPowerYearKeys)?.code {
                        ages.append(code)
                    }
                }
                filterModel.reqAges = ages
            }
        } else {
            filterModel.reqAges.removeAll()
        }
    }
    
    func updateDegrees() {
        let labels = getSelectLabels(degreeLimitItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.reqDegrees.removeAll()
            } else {
                var reqDegrees = [Int]()
                for label in labels {
                    if let code = TinSearch(name: label.name, inKeys: kManPowerDegreeKeys)?.code {
                        reqDegrees.append(code)
                    }
                }
                filterModel.reqDegrees = reqDegrees
            }
        } else {
            filterModel.reqDegrees.removeAll()
        }
    }
    
    func updateSalarys() {
        let labels = getSelectLabels(salaryItem)
        if let first = labels.first {
            if first.name == "全部" {
                filterModel.salarys.removeAll()
            } else {
                var salarys = [Int]()
                for label in labels {
                    if let code = TinSearch(name: label.name, inKeys: kManPowerSalaryKeys)?.code {
                        salarys.append(code)
                    }
                }
                filterModel.salarys = salarys
            }
        } else {
            filterModel.salarys.removeAll()
        }
    }
    
    
    override func handleBlue() {
        dutyItem.selectIdxes = [0]
        dutyItem.update()
        filterModel.duties.removeAll()
        
        yearLimitItem.selectIdxes = [0]
        yearLimitItem.update()
        filterModel.reqAges.removeAll()

        degreeLimitItem.selectIdxes = [0]
        degreeLimitItem.update()
        filterModel.reqDegrees.removeAll()

        salaryItem.selectIdxes = [0]
        salaryItem.update()
        filterModel.salarys.removeAll()

        tableView.reloadData()
    }
    
    override func handleRed() {
        self.respondConfirm?()
    }
    
}
