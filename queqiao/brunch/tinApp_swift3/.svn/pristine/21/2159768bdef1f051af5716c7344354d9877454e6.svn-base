//
//  MeetingFilterViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MeetingFilterViewController: RootFilterViewController {
    
    weak var baseVc: MeetingMainViewController!
    
    //MARK: 主题
    lazy var topicsSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "热门主题"
        one.items = [self.topicsItem, self.topicBottomSpaceItem]
        return one
    }()
    
    lazy var topicsItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = false
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            one.selectIdxes = selectIdxes
            self.updateTopics()
        }
        return one
    }()
    lazy var topicBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        return one
    }()
    
    //MARK: 嘉宾
    lazy var guestsSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "参会嘉宾"
        one.items = [self.guestsInputItem, self.guestsSpaceItem, self.guestsItem, self.guestsBottomSpaceItem]
        return one
    }()
    
    lazy var guestsInputItem: FilterInputItem = {
        let one = FilterInputItem()
        one.placeHolder = "嘉宾名称，以空格分隔"
        return one
    }()
    lazy var guestsSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.cellHeight = 10
        return one
    }()
    lazy var guestsItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.selectIdxes = [0]
        one.mutiMode = true
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateGuests()
        }
        return one
    }()
    lazy var guestsBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        return one
    }()
    
    
    //MARK: 参会时间
    lazy var timeSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "参会时间"
        one.items = [self.timeItemItem, self.timeSpaceItem, self.timeInputItem, self.timeBottomSpaceItem]
        return one
    }()
    
    lazy var timeInputItem: FilterInputItem = {
        let one = FilterInputItem()
        one.placeHolder = "显示[选择日期]之后的会议"
        let datePicker = DateTimePickerView()
        datePicker.responder = { [unowned self, unowned one] date in
            one.text = DateTool.getDateString(date)
            one.updateCell?()
            self.baseVc.searchMeetDate = date?.appToString()
        }
        one.customKeyboard = datePicker
        return one
    }()
    lazy var timeSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.cellHeight = 10
        return one
    }()
    lazy var timeItemItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        let labels = [
            FilterNameLabel(name: "周一至周五", content: "-1"),
            FilterNameLabel(name: "周末", content: "-1")
        ]
        one.firstOneCrossCount = 1
        one.labels = labels.map({ $0 as labelProtocol })
        one.selectIdxes = []
        one.mutiMode = false
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            one.selectIdxes = selectIdxes
            self.updateTime()
        }
        return one
    }()
    lazy var timeBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        return one
    }()
    
    
    //MARK: 会议地点
    lazy var locationSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "会议地点"
        one.items = [self.locationItem, self.locationSpaceItem, self.locationInputItem, self.locationBottomSpaceItem]
        one.showBottomLine = false
        return one
    }()
    
    let addressLabels = [
        FilterNameLabel(name: "全部", content: "-1"),
        FilterNameLabel(name: "北京", content: "-1"),
        FilterNameLabel(name: "上海", content: "-1"),
        FilterNameLabel(name: "天津", content: "-1"),
        FilterNameLabel(name: "广东", content: "-1"),
        FilterNameLabel(name: "浙江", content: "-1"),
        FilterNameLabel(name: "江苏", content: "-1"),
        FilterNameLabel(name: "山东", content: "-1"),
        FilterNameLabel(name: "福建", content: "-1")
    ]
    lazy var locationInputItem: FilterInputItem = {
        let one = FilterInputItem()
        one.placeHolder = "会议地点，以空格分隔"
        one.respondChange = { [unowned self] _ in
            self.updateLocations()
        }
        return one
    }()
    lazy var locationSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.cellHeight = 10
        return one
    }()
    lazy var locationItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = true
        one.labels = self.addressLabels.map({ $0 as labelProtocol })
        one.selectIdxes = []
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            self.handleMutiSelectChange(selectIdxes, lastIdx: lastIdx, item: one)
            self.updateLocations()
        }
        return one
    }()
    lazy var locationBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        items = [topicsSectionItem, guestsSectionItem, timeSectionItem, locationSectionItem]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseVc.refreshData()
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        var tipics: [MeetingTip]?
        var guests: [MeetingTip]?
        MeetingManager.shareInstance.getTopics({ [weak self] (code, msg, tips) in
            if code == 0 {
                tipics = tips
                MeetingManager.shareInstance.getGuests({ [weak self] (code, msg, tips) in
                    if code == 0 {
                        guests = tips
                        done(.noMore)
                        self?.handleWebData(tipics!, guests: guests!)
                    } else {
                        done(.err)
                    }
                    }, failed: { (error) in
                        done(.err)
                })
            } else {
                done(.err)
            }
        }) { (error) in
                done(.err)
        }
    }
    
    func handleWebData(_ tipics: [MeetingTip], guests: [MeetingTip]) {
        
        if tipics.count > 0 {
            items = [topicsSectionItem, guestsSectionItem, timeSectionItem, locationSectionItem]
        } else {
            items = [guestsSectionItem, timeSectionItem, locationSectionItem]
        }
        
        do {
            if tipics.count > 0 {
                var labels = [FilterNameLabel]()
                for tip in tipics {
                    let label = FilterNameLabel(name: tip.name, content: "0")
                    labels.append(label)
                }
                topicsItem.labels = labels.map({ $0 as labelProtocol })
                topicsItem.selectIdxes = []
            } else {
                topicsItem.labels = nil
                topicsItem.selectIdxes.removeAll()
            }
            topicsItem.update()
        }
        do {
            if guests.count > 0 {
                var labels = [FilterNameLabel]()
                labels.append(FilterNameLabel(name: "全部", content: "-1"))
                for tip in guests {
                    let label = FilterNameLabel(name: tip.name, content: "0")
                    labels.append(label)
                }
                guestsItem.labels = labels.map({ $0 as labelProtocol })
                guestsItem.selectIdxes = [0]
            } else {
                guestsItem.labels = nil
                guestsItem.selectIdxes.removeAll()
            }
            guestsItem.update()
        }
        tableView.reloadData()
    }
    
    override func handleRed() {
        baseVc.refreshData()
        dismiss(animated: true, completion: nil)
    }
    
    override func handleBlue() {
        
        topicsItem.selectIdxes = []
        topicsItem.update()
        
        guestsItem.selectIdxes = []
        if let labels = guestsItem.labels {
            if labels.count > 0 {
                guestsItem.selectIdxes = [0]
            }
        }
        guestsItem.update()
        guestsInputItem.text = nil
        
        timeItemItem.selectIdxes = [0]
        timeItemItem.update()
        timeInputItem.text = nil
        
        locationItem.selectIdxes = [0]
        locationItem.update()
        locationInputItem.text = nil
        
        tableView.reloadData()
        
        baseVc.searchKeyWord = nil
        baseVc.searchWeekDay = nil
        baseVc.searchWeekEnd = nil
        baseVc.searchMeetDate = nil
        baseVc.searchAddresses = nil
        baseVc.searchGuests = nil
    }
    
    func updateTopics() {
        let strs = getSelectStrings(topicsItem)
        if let first = strs.first {
            baseVc.searchKeyWord = first
        } else {
            baseVc.searchKeyWord = nil
        }
    }
    
    func updateGuests() {
        var strs = getSelectStrings(guestsItem)
        if let first = strs.first {
            if first == "全部" {
                strs = []
            }
        } else {
            strs = []
        }
        if let text = guestsInputItem.text {
            let strs1 = text.components(separatedBy: " ")
            strs += strs1
        }
        if strs.count > 0 {
            baseVc.searchGuests = strs
        } else {
            baseVc.searchGuests = nil
        }
    }
    
    func updateTime() {
        let strs = getSelectStrings(timeItemItem)
        if strs.count >= 2 {
            baseVc.searchWeekDay = true
            baseVc.searchWeekEnd = true
        } else if strs.count == 1 {
            let first = strs.first!
            if first == "周一至周五" {
                baseVc.searchWeekDay = true
                baseVc.searchWeekEnd = nil
            } else {
                baseVc.searchWeekDay = nil
                baseVc.searchWeekEnd = true
            }
        } else {
            baseVc.searchWeekDay = nil
            baseVc.searchWeekEnd = nil
        }
    }
    
    func updateLocations() {
        var strs = getSelectStrings(locationItem)
        if let first = strs.first {
            if first == "全部" {
                strs = []
            }
        } else {
            strs = []
        }
        if let text = locationInputItem.text {
            let strs1 = text.components(separatedBy: " ")
            strs += strs1
        }
        if strs.count > 0 {
            baseVc.searchAddresses = strs
        } else {
            baseVc.searchAddresses = nil
        }
    }
    
}
