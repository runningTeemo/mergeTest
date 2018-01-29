//
//  HelpListViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/8.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class HelpListViewController: StaticCellBaseViewController {
    
    lazy var spaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()

    lazy var addFriendItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "添加好友的方法"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "添加好友的方法"
            vc.url = PREFIXURL + "ui/page/help/addFriend.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var removeFriendItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "怎么删除好友"
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "怎么删除好友"
            vc.url = PREFIXURL + "ui/page/help/delFriend.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var whatIsHornItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "什么是喇叭"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "什么是喇叭"
            vc.url = PREFIXURL + "ui/page/help/speaker.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var howToGetHornItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "喇叭如何获取"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "喇叭如何获取"
            vc.url = PREFIXURL + "ui/page/help/getSpeaker.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var howToUseHornItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "喇叭的使用方法"
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "喇叭的使用方法"
            vc.url = PREFIXURL + "ui/page/help/useSpeaker.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var spaceItem2: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    lazy var authorFlowItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "用户认证流程"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "用户认证流程"
            vc.url = PREFIXURL + "ui/page/help/userOauth.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var authorForWhatItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "发布什么内容需要审核"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "发布什么内容需要审核"
            vc.url = PREFIXURL + "ui/page/help/contentAudit.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var projectStatusItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "项目有几种状态"
        one.showBottomLine = true
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "项目有几种状态"
            vc.url = PREFIXURL + "ui/page/help/projectStatus.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var whyCannotSeeProjectItem: StaticCellArrowItem = {
        let one = StaticCellArrowItem()
        one.titleFont = UIFont.systemFont(ofSize: 14)
        one.titleColor = HEX("#666666")
        one.title = "为什么看不了项目详情"
        one.responder = { [unowned self] in
            let vc = CommonWebViewController()
            vc.title = "为什么看不了项目详情"
            vc.url = PREFIXURL + "ui/page/help/projectDetail.html"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return one
    }()
    
    lazy var spaceItem3: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.cellHeight = 10
        one.color = kClrBackGray
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帮助"
        setupNavBackBlackButton(nil)
        staticItems = [spaceItem, addFriendItem, removeFriendItem, spaceItem1, whatIsHornItem, howToGetHornItem, howToUseHornItem, spaceItem2, authorFlowItem, authorForWhatItem, projectStatusItem, whyCannotSeeProjectItem, spaceItem3]
    }
}
