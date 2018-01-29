//
//  ArticleFilteActivityViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleFilteActivityViewController: RootFilterViewController {
    
    func reset() {
        startTimeInputItem.text = nil
        startTimeInputItem.updateCell?()
        endTimeInputItem.text = nil
        startTimeInputItem.updateCell?()
        tableView.reloadData()
        
        self.filterModel.startTime = 0
        self.filterModel.endTime = 0
    }
    
    var filterModel: ArticleFilter!
    var respondConfirm: (() -> ())?

    //MARK: 参会时间
    lazy var timeSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "活动时间"
        one.totalWidth = kScreenW - 100
        one.items = [self.startTimeInputItem, self.timeSpaceItem, self.endTimeInputItem, self.timeBottomSpaceItem]
        return one
    }()
    
    lazy var startTimeInputItem: FilterInputItem = {
        let one = FilterInputItem()
        one.placeHolder = "开始时间"
        one.totalWidth = kScreenW - 100
        let datePicker = DateTimePickerView()
        datePicker.responder = { [unowned self, unowned one] date in
            one.text = DateTool.getDateString(date)
            one.updateCell?()
            self.filterModel.startTime = SafeUnwarp(date?.timeIntervalSince1970, holderForNull: 0) * 1000
        }
        one.customKeyboard = datePicker
        return one
    }()
    lazy var timeSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.cellHeight = 10
        one.totalWidth = kScreenW - 100
        return one
    }()
    lazy var endTimeInputItem: FilterInputItem = {
        let one = FilterInputItem()
        one.placeHolder = "结束时间"
        one.totalWidth = kScreenW - 100
        let datePicker = DateTimePickerView()
        datePicker.responder = { [unowned one] date in
            one.text = DateTool.getDateString(date)
            one.updateCell?()
            self.filterModel.endTime = SafeUnwarp(date?.timeIntervalSince1970, holderForNull: 0) * 1000
        }
        one.customKeyboard = datePicker
        return one
    }()
    
    lazy var timeBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.totalWidth = kScreenW - 100
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        //loadDataOnFirstWillAppear = true
        items = [timeSectionItem]
    }
    
    override func handleBlue() {
        startTimeInputItem.text = nil
        endTimeInputItem.text = nil
        self.filterModel.endTime = 0
        self.filterModel.startTime = 0
        self.tableView.reloadData()
    }
    
    override func handleRed() {
        self.respondConfirm?()
    }
    
    
}
