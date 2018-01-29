//
//  ArticleSearchViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ArticleSearchViewController: RootViewController {
    
    func reset() {
        filteCategoriesVc.reset()
        filteCitiesVc.reset()
        filteOrderVc.reset()
        searchHeader.reset()
        setFold()
        filterModel.articleType = .project
    }
    
    let filterModel: ArticleFilter = ArticleFilter()
    let cleanModel: ArticleFilter = ArticleFilter()

    var respondSearch: ((_ key: String?) -> ())?
    var respondClean: (() -> ())?

    static let initHeight: CGFloat = ArticleSearchHeader.viewHeight()
    static let maxHeight: CGFloat = kScreenH - 49 - 64
    static let orderHeight: CGFloat = ArticleSearchHeader.viewHeight() + ArticleFilteOrderViewController.viewHeight()

    var respondHeight: ((_ height: CGFloat) -> ())?
    var respondFold: ((_ fold: Bool) -> ())?
    var respondFilte: (() -> ())?
    
    var respondKeyboard: ((_ show: Bool) -> ())?

    func setFold() {
        self.searchHeader.segView.foldAll()
        self.filteCategoriesVc.view.isHidden = true
        self.filteCitiesVc.view.isHidden = true
        self.filteOrderVc.view.isHidden = true
        self.respondHeight?(ArticleSearchViewController.initHeight)
        self.respondFold?(true)
    }
    
    lazy var searchHeader: ArticleSearchHeader = {
        let one = ArticleSearchHeader()
        
        one.respondSearch = { [unowned self] key in
            self.respondSearch?(key)
            self.showTip(false)
        }
        
        one.respondClean = { [unowned self] in
            self.respondClean?()
            self.showTip(false)
        }
        
        one.respondChange = { [unowned self] key in
            if let key = key {
                self.tipVc.handleText(key)
            }
            self.showTip(NotNullText(key))
        }
        one.respondBeginEditing = { [unowned self] key in
            if let key = key {
                self.tipVc.handleText(key)
            }
            self.showTip(NotNullText(key))
            self.respondKeyboard?(true)
        }
        one.respondEndEditing = { [unowned self] key in
            if let key = key {
                self.tipVc.handleText(key)
            }
            self.showTip(NotNullText(key))
            self.respondKeyboard?(false)
        }
        one.segView.respondTag = { [unowned self, unowned one] tag, lastTag in
            
            self.filteCategoriesVc.view.isHidden = true
            self.filteCitiesVc.view.isHidden = true
            self.filteOrderVc.view.isHidden = true
            if let tag = tag {
                if tag == 0 {
//                    if self.filterModel.articleType == .all {
//                        self.filterModel.articleType = .project
//                        self.filteCategoriesVc.leftVc.currentIdx = 1
//                        self.filteCategoriesVc.leftVc.tableView.reloadData()
//                        self.filteCategoriesVc.handleTag(1)
//                    }
                    self.filteCategoriesVc.view.isHidden = false
                    self.respondHeight?(ArticleSearchViewController.maxHeight)
                } else if tag == 1 {
                    self.filteCitiesVc.view.isHidden = false
                    self.respondHeight?(ArticleSearchViewController.maxHeight)
                } else {
                    self.filteOrderVc.view.isHidden = false
                    self.respondHeight?(ArticleSearchViewController.orderHeight)
                }
                self.respondFold?(false)

            } else {
                self.respondHeight?(ArticleSearchViewController.initHeight)
                self.respondFold?(true)
                self.respondFilte?()
                if let tag = lastTag {
                    if tag == 0 {
                        let t = self.filteCategoriesVc.leftVc.currentIdx
                        let name = kArticleFilteCategorieNames[t]
                        one.segView.btn0.label.text = name
                    } else if tag == 1 {
                        if let name = self.filteCitiesVc.selectName {
                            if name == "全部" {
                                one.segView.btn1.label.text = "城市不限"
                            } else {
                                one.segView.btn1.label.text = name
                            }
                        } else {
                            one.segView.btn1.label.text = "城市不限"
                        }
                    } else {
                        let t = self.filteOrderVc.currentIdx
                        let name = kArticleFilteOrderNames[t]
                        one.segView.btn2.label.text = name
                    }
                }
            }
        }        
        return one
    }()
    
    lazy var tipVc: MainSearchTipViewController = {
        let one = MainSearchTipViewController()
        one.isCommonSearch = false
        one.respondEndEdit = { [unowned self] in
            self.view.endEditing(true)
        }
        one.view.isHidden = true
        return one
    }()
    
    
    lazy var filteCategoriesVc: ArticleFilteCategoriesViewController = {
        let one = ArticleFilteCategoriesViewController()
        one.view.isHidden = true
        one.filterModel = self.filterModel
        one.respondAll = { [unowned self] in
            self.searchHeader.segView.foldAll()
            self.searchHeader.segView.respondTag?(nil, 0)
        }
        return one
    }()
    lazy var filteCitiesVc: ArticleFilteCitiesViewController = {
        let one = ArticleFilteCitiesViewController()
        one.view.isHidden = true
        one.respondCity = { [unowned self] name in
            self.searchHeader.segView.foldAll()
            self.searchHeader.segView.respondTag?(nil, 1)
        }
        one.filterModel = self.filterModel
        return one
    }()
    lazy var filteOrderVc: ArticleFilteOrderViewController = {
        let one = ArticleFilteOrderViewController()
        one.view.isHidden = true
        one.respondTag = { [unowned self] tag in
            self.searchHeader.segView.foldAll()
            self.searchHeader.segView.respondTag?(nil, 2)
        }
        one.filterModel = self.filterModel
        return one
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        
        let headerHeight = ArticleSearchHeader.viewHeight()
        view.addSubview(searchHeader)
        searchHeader.IN(view).LEFT.RIGHT.TOP.HEIGHT(headerHeight).MAKE()
        
        view.addSubview(filteCategoriesVc.view)
        filteCategoriesVc.view.IN(view).LEFT.RIGHT.TOP(headerHeight).BOTTOM.MAKE()
        self.addChildViewController(filteCategoriesVc)
        
        view.addSubview(filteCitiesVc.view)
        filteCitiesVc.view.IN(view).LEFT.RIGHT.TOP(headerHeight).BOTTOM.MAKE()
        self.addChildViewController(filteCitiesVc)
        
        view.addSubview(filteOrderVc.view)
        filteOrderVc.view.IN(view).LEFT.RIGHT.TOP(headerHeight).BOTTOM.MAKE()
        self.addChildViewController(filteOrderVc)
        
        view.addSubview(tipVc.view)
        tipVc.view.IN(view).LEFT.RIGHT.TOP(ArticleSearchHeader.headerHeight()).BOTTOM.MAKE()
        self.addChildViewController(tipVc)
        
        filterModel.articleType = .project
                
    }
    
    func showTip(_ show: Bool) {
        if show {
            respondHeight?(ArticleSearchViewController.maxHeight)
            tipVc.view.isHidden = false
            self.respondFold?(true)
        } else {
            respondHeight?(ArticleSearchViewController.initHeight)
            tipVc.view.isHidden = true
            self.respondFold?(true)
        }
        self.searchHeader.segView.foldAll()
    }
    
}
