//
//  ArticleFilteCitiesViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleFilteCitiesViewController: RootFilterViewController {
    
    func reset() {
        checkOrResetLabelItem(hotCitiesItem)
        self.moreItem.title = "更多"
        tableView.reloadData()
        filterModel.locations.removeAll()
    }
    
    var filterModel: ArticleFilter!
    
    var respondCity: ((_ name: String?) -> ())?
    var selectName: String?
    
    //MARK: 热门城市
    
    lazy var hotCitiesSectionItem: RootFilterSectionItem = {
        let one = RootFilterSectionItem()
        one.title = "热门城市"
        one.items = [self.hotCitiesItem, self.moreItem, self.hotCitiesBottomSpaceItem]
        return one
    }()
    
    lazy var hotCitiesItem: FilterLabelsItem = {
        let one = FilterLabelsItem()
        one.mutiMode = false
        one.totalWidth = kScreenW
        one.update()
        one.respondSelectChange = { [unowned self, unowned one] selectIdxes, lastIdx in
            one.selectIdxes = selectIdxes
            self.selectName = self.getSelectStrings(one).first            
            if let name = self.selectName {
                if name == "全部" {
                    self.filterModel.locations.removeAll()
                } else {
                    self.filterModel.locations.removeAll()
                    self.filterModel.locations.append(name)
                }
                self.moreItem.title = "更多"
            }
            self.respondCity?(self.selectName)
        }
        return one
    }()
    
    lazy var moreItem: FilterMoreItem = {
        let one = FilterMoreItem()
        one.title = "更多"
        one.respondClick = { [unowned self] in
            let vc = LocationPickerMainViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.respondCity = { [unowned self, unowned vc, unowned one] name in
                if let name = name {
                    self.hotCitiesItem.selectIdxes = []
                    self.hotCitiesItem.update()
                    self.moreItem.title = "更多(\(name))"
                    self.tableView.reloadData()

                    self.filterModel.locations.removeAll()
                    self.filterModel.locations.append(name)
                }
                self.selectName = name
                self.respondCity?(name)
            }
            let nav = RootNavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        return one
    }()
    
    lazy var hotCitiesBottomSpaceItem: FilterSpaceItem = {
        let one = FilterSpaceItem()
        one.cellHeight = 5
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        loadDataOnFirstWillAppear = true
        items = [hotCitiesSectionItem]
        
        self.showBottomView = false
    }
    
    override func loadData(_ done: @escaping LoadingDataDone) {
        handleWebData(LocationDataEntry.hotCityNames)
        done(.noMore)
    }
    
    
    func handleWebData(_ hotCities: [String]) {
        
        do {
            var labels = [FilterNameLabel]()
            labels.append(FilterNameLabel(name: "全部", content: "-1"))
            for key in hotCities {
                let label = FilterNameLabel(name: key, content: "")
                labels.append(label)
            }
            hotCitiesItem.labels = labels.map({ $0 as labelProtocol })
            hotCitiesItem.selectIdxes = [0]
            hotCitiesItem.update()
        }
        
        tableView.reloadData()
    }

}
