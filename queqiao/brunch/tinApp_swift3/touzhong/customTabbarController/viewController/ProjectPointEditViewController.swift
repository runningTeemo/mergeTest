//
//  ProjectPointEditViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2017/2/9.
//  Copyright © 2017年 zerlinda. All rights reserved.
//

import UIKit

class ProjectPointEditViewController: StaticCellBaseViewController {
    
    var placeHolder: String?
    var text: String?
    var respondText: ((_ text: String?) -> ())?
    
    lazy var topSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var textItem: StaticCellCountTextViewItem = {
        let one = StaticCellCountTextViewItem()
        one.holderText = "项目的特点"
        one.maxCharCount = 300
        one.cellHeight = 200
        return one
    }()
    
    lazy var bottomSpaceItem: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var saveNavItem: BarButtonItem = {
        let one = BarButtonItem(title: "确定", responder: { [unowned self] in
            self.handleSave()
        })
        return one
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StaticHornCell.self, forCellReuseIdentifier: "StaticHornCell")
        
        staticItems = [topSpaceItem, textItem, bottomSpaceItem]
        setupRightNavItems(items: saveNavItem)
        
        setupNavBackBlackButton { [unowned self] in
            self.handleBack()
        }
    }
    
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        textItem.holderText = placeHolder
        textItem.text = text
        tableView.reloadData()
    }
    
    func handleBack() {
        if self.editChanged {
            Confirmer.show("返回确认", message: "返回将不会保存，确认返回？", confirm: "返回", confirmHandler: { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
                }, cancel: "继续修改", cancelHandler: {
            }, inVc: self)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleSave() {
        if NotNullText(textItem.text) {
            _ = self.navigationController?.popViewController(animated: true)
            self.respondText?(textItem.text)
        } else {
            QXTiper.showWarning(SafeUnwarp(title, holderForNull: "") + "不能为空", inView: self.view, cover: true)
        }
    }
    
}
