//
//  MainSearchViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class MainSearchViewController: RootViewController {
    
    lazy var searchView: MainSearchHeadView = {
        let one = MainSearchHeadView()
        one.frame = CGRect(x: 0, y: 0, width: kScreenW - 15, height: 30)
        one.respondBack = { [unowned self] in
            if self.isTypeShow {
                if self.typeVcFromTip {
                    self.showTip()
                } else {
                    self.showResult()
                }
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        one.respondClean = { [unowned self] in
            self.showHistory()
        }
        one.respondChange = { [unowned self] text in
            self.handleTextChange(text)
        }
        one.respondBeginEditing = { [unowned self] text in
            self.handleTextChange(text)
        }
        one.respondSearch = { [unowned self] text in
            self.handleSearch(text)
            self.checkOrSaveSearch(text)
        }
        one.respondFilter = { [unowned self] in
            self.filterVc.item = self.resultVc.item
            self.filterVc.disSelectAll()
            RootFilterShower.shareOne.show(onLeft: false, vc: self.filterVc, inVc: self, complete: nil)
        }
        return one
    }()
    
    lazy var filterVc: SearchFilterViewController = {
        let one = SearchFilterViewController()
        one.respondChange = { [unowned self] in
            self.showResult()
            self.resultVc.tableView.reloadData()
        }
        return one
    }()
    
    lazy var historyVc: MainSearchHistroyViewController = {
        let one = MainSearchHistroyViewController()
        one.respondEndEdit = { [unowned self] in
            self.searchView.endEditing(true)
        }
        one.respondKey = { [unowned self] key in
            self.searchView.searchBar.textField.text = key
            self.searchView.searchBar.iconView.isHidden = NullText(key)
            self.searchView.searchBtn.forceDown(false)
            self.handleSearch(key)
        }
        return one
    }()
    
    lazy var tipVc: MainSearchTipViewController = {
        let one = MainSearchTipViewController()
        one.respondEndEdit = { [unowned self] in
            self.searchView.endEditing(true)
        }
        one.respondType = { [unowned self] type, key, count in
            print("\(type) - \(key)")
            self.typeVcFromTip = true
            self.showType()
            self.typeVc.key = key
            self.typeVc.type = type
            self.typeVc.initForNew()
            self.typeVc.totalCount = 0
            self.typeVc.loadData()
            self.searchView.endEditing(true)
            self.checkOrSaveSearch(key)
        }
        one.respondId = { [unowned self] type, id, key in
            self.searchView.endEditing(true)
            
            switch type {
            case .enterprise:
                let vc = EnterpriseDetailViewController()
                vc.id = id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .institution:
                let vc = InstitutionDetailViewController()
                vc.id = id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .identity:
                break
            case .person:
                if Account.sharedOne.user.author ==  .isAuthed{
                    let vc = PersonageDetailViewController()
                    vc.id = id
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.remindCertification()
                }
            case .funds:
                break
            case .report:
                break
            case .meeting:
                break
            case .invest:
                let vc = FinancingDetailViewController()
                vc.id = id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .merge:
                let vc = MergerDetailViewController()
                vc.id = id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .exsit:
                let vc = ExitEventDetailViewController()
                vc.id = id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                break
            }
            self.checkOrSaveSearch(key)
        }
        return one
    }()
    
    var typeVcFromTip: Bool = true
    lazy var resultVc: MainSearchResultViewController = {
        let one = MainSearchResultViewController()
        one.respondScroll = { [unowned self] in
            self.searchView.endEditing(true)
            self.searchView.showFilter()
        }
        one.respondType = { [unowned self] type, key, count in
            print("\(type) - \(key)")
            self.typeVcFromTip = false
            self.showType()
            self.typeVc.key = key
            self.typeVc.type = type
            self.typeVc.totalCount = 0
            self.typeVc.initForNew()
            self.typeVc.loadData()
        }
        one.respondCanFilt = { [unowned self] can in
            self.searchView.filterIconBtn.forceDown(!can)
        }
        return one
    }()
    
    lazy var typeVc: MainSearchTypeResultViewController = {
        let one = MainSearchTypeResultViewController()
        one.respondScroll = { [unowned self] in
            self.searchView.endEditing(true)
            self.searchView.showFilter()
        }
        one.respondBack = { [unowned self] in
            if self.typeVcFromTip {
                self.showTip()
            } else {
                self.showResult()
            }
        }
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        
        setupLeftNavItems(items: UIBarButtonItem(customView: searchView))
        
        view.addSubview(historyVc.view)
        addChildViewController(historyVc)
        historyVc.view.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()

        view.addSubview(tipVc.view)
        addChildViewController(tipVc)
        // 添加的第一个tableView上部会自动insert 64
        tipVc.view.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()

        view.addSubview(resultVc.view)
        addChildViewController(resultVc)
        resultVc.view.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()

        view.addSubview(typeVc.view)
        addChildViewController(typeVc)
        typeVc.view.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNav()
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        showHistory()
        searchView.searchBar.textField.becomeFirstResponder()
    }
    
    func handleTextChange(_ text: String?) {
        if NotNullText(text) {
            showTip()
            tipVc.handleText(text!)
        } else {
            self.showHistory()
        }
    }
    
    func handleSearch(_ text: String) {
        self.searchView.endEditing(true)
        showResult()
        resultVc.searchKey = text
        resultVc.loadData()
    }
    
    func checkOrSaveSearch(_ key: String) {
        let history = History(key: key, time: Date())
        var histories = [History]()
        for h in historyVc.histories {
            if h.key != key {
                histories.append(h)
            }
        }
        histories.insert(history, at: 0)
        historyVc.histories = histories
        History.saveHistories(histories)
    }
    
    func showTip() {
        isTypeShow = false
        historyVc.view.isHidden = true
        tipVc.view.isHidden = false
        resultVc.view.isHidden = true
        typeVc.view.isHidden = true
        searchView.showSearch()
    }
    func showHistory() {
        isTypeShow = false
        historyVc.view.isHidden = false
        tipVc.view.isHidden = true
        resultVc.view.isHidden = true
        typeVc.view.isHidden = true
        searchView.showSearch()
    }
    func showResult() {
        isTypeShow = false
        historyVc.view.isHidden = true
        tipVc.view.isHidden = true
        resultVc.view.isHidden = false
        typeVc.view.isHidden = true
        searchView.showFilter()
    }
    
    var isTypeShow: Bool = false
    func showType() {
        isTypeShow = true
        historyVc.view.isHidden = true
        tipVc.view.isHidden = true
        resultVc.view.isHidden = true
        typeVc.view.isHidden = false
        searchView.showFilter()
    }
    
}
