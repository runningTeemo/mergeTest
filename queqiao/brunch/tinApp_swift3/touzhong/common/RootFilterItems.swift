//
//  RootFilterItems.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class RootFilterSectionItem {
    
    var title: String?
    var showArrow: Bool = true
    var fold: Bool = false
    
    var canFold: Bool = true
    
    var items: [RootFilterItem] = [RootFilterItem]()
    
    var showBottomLine: Bool = true
    
    var totalWidth: CGFloat = kScreenW * 0.8
}

class RootFilterItem {
    var cellHeight: CGFloat = 50
    var totalWidth: CGFloat = kScreenW * 0.8
    
    var updateCell: (() -> ())?
}

class RootFilterCell: RootTableViewCell {
    weak var tableView: UITableView!
    weak var vc: StaticCellBaseViewController!
    var indexPath: IndexPath!
    
    var item: RootFilterItem? {
        didSet {
            update()
        }
    }
    func update() {
        item?.updateCell = { [unowned self] in
            self.update()
        }
    }
}

class FilterNameLabel: labelProtocol {
    var name: String?
    var content: String?
    init(name: String?, content: String?) {
        self.name = name
        self.content = content
    }
}
