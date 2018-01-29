//
//  SearchFilterViewController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/19.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SearchFilterViewController: RootFilterViewController {
    
    var item: MainSearchResultsItem!
    var respondChange: (() -> ())?
    
    func disSelectAll() {
        topicsItem.selectIdxes = [0]
        topicsItem.update()
        tableView.reloadData()
    }
    
    //MARK: 主题
    
    lazy var topicsSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "数据筛选"
        one.items = [self.topicsItem, self.topicBottomSpaceItem]
        one.canFold = false
        one.showArrow = false
        return one
    }()
    
    let topicLabels = [
        FilterNameLabel(name: "全部", content: "-1"),
        FilterNameLabel(name: "企业", content: "3"),
        FilterNameLabel(name: "事件", content: "101"),
        FilterNameLabel(name: "机构", content: "2"),
        FilterNameLabel(name: "会议", content: "5"),
        FilterNameLabel(name: "新闻", content: "0"),
        FilterNameLabel(name: "人物", content: "4")
    ]
    
    lazy var topicsItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.labels = self.topicLabels.map({ $0 as labelProtocol })
        one.selectIdxes = [0]
        one.mutiMode = true
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] idxes, lastIdx in
            self.handleMutiSelectChange(idxes, lastIdx: lastIdx, item: one)
        }
        return one
    }()
    lazy var topicBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [topicsSectionItem]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        respondChange?()
    }
    
//    func handleSelectChange(_ idxes: [Int], lastIdx: Int) {
//        if idxes.count == 0 {
//            topicsItem.selectIdxes = []
//            topicsItem.update()
//            tableView.reloadData()
//        } else {
//            if lastIdx == 0 {
//                if idxes.first! ==  0 {
//                    topicsItem.selectIdxes = [0]
//                } else {
//                    topicsItem.selectIdxes = []
//                }
//                topicsItem.update()
//                tableView.reloadData()
//            } else {
//                if idxes.first! ==  0 {
//                    var _idexes = idxes
//                    _idexes.remove(at: 0)
//                    topicsItem.selectIdxes = _idexes
//                } else {
//                    topicsItem.selectIdxes = idxes
//                }
//                topicsItem.update()
//                tableView.reloadData()
//            }
//        }
//        updateModel(topicsItem.selectIdxes)
//    }
    
    func updateModel(_ idxes: [Int]) {
        
        if checkExist(0, idxes: idxes) {
            item.enterprisesItem.show = true
            item.eventsItem.show = true
            item.institutionsItem.show = true
            item.meetingsItem.show = true
            item.newsItem.show = true
            item.usersItem.show = true
        } else {
            item.enterprisesItem.show = checkExist(1, idxes: idxes)
            item.eventsItem.show = checkExist(2, idxes: idxes)
            item.institutionsItem.show = checkExist(3, idxes: idxes)
            item.meetingsItem.show = checkExist(4, idxes: idxes)
            item.newsItem.show = checkExist(5, idxes: idxes)
            item.usersItem.show = checkExist(6, idxes: idxes)
        }
    }
    
    func checkExist(_ idx: Int, idxes: [Int]) -> Bool {
        for i in idxes {
            if idx == i {
                return true
            }
        }
        return false
    }
    
    override func handleRed() {
        //respondChange?()
        dismiss(animated: true, completion: nil)
    }
    
    override func handleBlue() {
        topicsItem.selectIdxes = [0]
        topicsItem.update()
        tableView.reloadData()
        updateModel([0])
    }
    
}

