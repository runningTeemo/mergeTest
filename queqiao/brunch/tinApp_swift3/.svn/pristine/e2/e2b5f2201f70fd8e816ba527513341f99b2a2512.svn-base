//
//  ArticleFilteCategoriesViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/30.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

let kArticleFilteCategorieNames = ["全部分类", "项目"/*, "人才", "活动" */]

class ArticleFilteCategoriesViewController: RootViewController {
    
    func reset() {
        projectVc.reset()
        manPowerVc.reset()
        activityVc.reset()
        leftVc.reset()
        projectVc.view.isHidden = false
        manPowerVc.view.isHidden = true
        activityVc.view.isHidden = true
    }
    
    var respondAll: (() -> ())?
    
    var filterModel: ArticleFilter! {
        didSet {
            projectVc.filterModel = filterModel
            manPowerVc.filterModel = filterModel
            activityVc.filterModel = filterModel
        }
    }
    
    lazy var leftVc: ArticleFilteLeftViewController = {
        let one = ArticleFilteLeftViewController()
        one.titles = kArticleFilteCategorieNames
        one.respondSelect = { [unowned self] idx in
            self.handleTag(idx)
        }
        return one
    }()
    
    func handleTag(_ tag: Int) {
        projectVc.view.isHidden = true
        manPowerVc.view.isHidden = true
        activityVc.view.isHidden = true
        if tag == 0 {
            self.filterModel.articleType = .all
            self.respondAll?()
        } else if tag == 1 {
            self.filterModel.articleType = .project
            projectVc.view.isHidden = false
        } else if tag == 2 {
            self.filterModel.articleType = .manpower
            manPowerVc.view.isHidden = false
        } else if tag == 3 {
            self.filterModel.articleType = .activity
            activityVc.view.isHidden = false
        }
    }
    
    lazy var projectVc: ArticleFilteProjectViewController = {
        let one = ArticleFilteProjectViewController()
        one.respondConfirm = { [unowned self] in
            self.manPowerVc.handleBlue()
            self.activityVc.handleBlue()
            self.respondAll?()
        }
        return one
    }()
    lazy var manPowerVc: ArticleFilteManPowerViewController = {
        let one = ArticleFilteManPowerViewController()
        one.respondConfirm = { [unowned self] in
            self.projectVc.handleBlue()
            self.activityVc.handleBlue()
            self.respondAll?()
        }
        return one
    }()
    lazy var activityVc: ArticleFilteActivityViewController = {
        let one = ArticleFilteActivityViewController()
        one.respondConfirm = { [unowned self] in
            self.projectVc.handleBlue()
            self.manPowerVc.handleBlue()
            self.respondAll?()
        }
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kClrWhite
        
        view.addSubview(leftVc.view)
        leftVc.view.IN(view).LEFT.TOP.BOTTOM.WIDTH(100).MAKE()
        self.addChildViewController(leftVc)
        
        view.addSubview(projectVc.view)
        projectVc.view.IN(view).LEFT(100).TOP.BOTTOM.RIGHT.MAKE()
        self.addChildViewController(projectVc)
        
        view.addSubview(manPowerVc.view)
        manPowerVc.view.IN(view).LEFT(100).TOP.BOTTOM.RIGHT.MAKE()
        self.addChildViewController(manPowerVc)
        
        view.addSubview(activityVc.view)
        activityVc.view.IN(view).LEFT(100).TOP.BOTTOM.RIGHT.MAKE()
        self.addChildViewController(activityVc)
        
        projectVc.view.isHidden = false
        manPowerVc.view.isHidden = true
        activityVc.view.isHidden = true
    }
    
}
