//
//  NewsFilterViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/1/3.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

let kNewsFilteNotification = "kNewsFilteNotification"

class NewsFilter {
    static let sharedOne = NewsFilter()
    var industry: Industry?
}

class NewsFilterViewController: RootFilterViewController {
    
    var item: MainSearchResultsItem!
    var respondChange: (() -> ())?
    
    func reset() {
        industriesItem.selectIdxes = [0]
        industriesItem.update()
        handleSelectChange()
        tableView.reloadData()
    }

    //MARK: 行业
    
    lazy var industriesSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "行业"
        one.canFold = false
        one.showArrow = false
        one.items = [self.industriesItem, self.industriesBottomSpaceItem]
        return one
    }()
    
    lazy var industriesItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = false
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            one.selectIdxes = selectIdxes
            self.handleSelectChange()
        }
        return one
    }()
    lazy var industriesBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        return one
    }()
    
    func handleSelectChange() {
        if let name = getSelectLabels(industriesItem).first?.name {
            if name == "全部" {
                NewsFilter.sharedOne.industry = nil
            } else {
                for ind in self.industries! {
                    if ind.name == name {
                        NewsFilter.sharedOne.industry = ind
                        break
                    }
                }
            }
        }
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: kNewsFilteNotification), object: nil)
        dismiss(animated: true, completion: nil)
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
    
    var industries: [Industry]?
    func handleWebData(_ industries: [Industry]) {
        
        self.industries = industries
        
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
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        items = [industriesSectionItem]
        showBottomView = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        respondChange?()
    }

}

