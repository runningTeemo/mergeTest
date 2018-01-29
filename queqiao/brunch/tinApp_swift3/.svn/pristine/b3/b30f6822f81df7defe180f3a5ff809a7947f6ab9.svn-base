//
//  ChooseFontViewController.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ChooseFontViewController: StaticCellBaseViewController {
    
    lazy var spaceItem0: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    lazy var bigItem: StaticCellSelectItem = {
        let one = StaticCellSelectItem()
        one.text = "大"
        one.isSelect = true
        one.showBottomLine = true
        one.responder = { [unowned self] in
            self.changeFont(size: "L")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
        return one
    }()
    
    lazy var mediumItem: StaticCellSelectItem = {
        let one = StaticCellSelectItem()
        one.text = "中"
        one.isSelect = false
        one.showBottomLine = true
        one.responder = { [unowned self] in
            self.changeFont(size: "M")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
        return one
    }()
    
    lazy var smallItem: StaticCellSelectItem = {
        let one = StaticCellSelectItem()
        one.text = "小"
        one.isSelect = false
        one.responder = { [unowned self] in
            self.changeFont(size: "S")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
        return one
    }()
    
    lazy var spaceItem1: StaticCellSpaceItem = {
        let one = StaticCellSpaceItem()
        one.height = 10
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择正文字号"
        setupNavBackBlackButton(nil)
        staticItems = [spaceItem0, bigItem, mediumItem, smallItem, spaceItem1]
    }
    
    override func onFirstWillAppear() {
        super.onFirstWillAppear()
        if let size = UserDefaults.standard.value(forKey: kUserDefaultKeyFontSize) as? String {
            changeFont(size: size)
        } else {
            changeFont(size: "M")
        }
    }
    
    func changeFont(size: String) {
        if size == "L" {
            bigItem.isSelect = true
            mediumItem.isSelect = false
            smallItem.isSelect = false
        } else if size == "M" {
            bigItem.isSelect = false
            mediumItem.isSelect = true
            smallItem.isSelect = false
        } else if size == "S" {
            bigItem.isSelect = false
            mediumItem.isSelect = false
            smallItem.isSelect = true
        }
        tableView.reloadData()
        UserDefaults.standard.set(size, forKey: kUserDefaultKeyFontSize)
    }
    
}
