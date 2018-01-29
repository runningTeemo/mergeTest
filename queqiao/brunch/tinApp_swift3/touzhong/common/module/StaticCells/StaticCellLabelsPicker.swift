//
//  StaticCellLabelsPicker.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

protocol labelProtocol {
    var name: String? { get }
    var content: String? { get }
}

class StaticCellLabelsPickerItem: StaticCellBaseItem {
    
    var labels: [labelProtocol]?
    var respondSelectChange: ((_ selectIdxes: [Int], _ lastIdx: Int) -> ())?
    var respondLimit: (() -> ())?
    
    var mutiMode: Bool = false
    var selectLimit: Int?
    var xCount: Int = kScreenW <= 330 ? 3 : 4
    
    var selectIdxes: [Int] = [Int]()

    fileprivate(set) var item: RectSelectsFixSizeItem?
    
    func update() {
        cellHeight = 50
        let item = RectSelectsFixSizeItem()
        item.itemXMargin = 6
        item.itemYMargin = 6
        var models = [RectSelectFixSizeItem]()
        if let labels = labels {
            for label in labels {
                let model = RectSelectFixSizeItem()
                
                let xCount: CGFloat = CGFloat(self.xCount)
                
                let itemWidth = (totalWidth - kStaticCellLeftMargin - kStaticCellRightMargin - item.itemXMargin * (xCount - 1)) / xCount
                model.size = CGSize(width: itemWidth, height: 37)
                model.title = label.name
                model.norTitleFontSize = 14
                model.selTitleFontSize = 14
                model.update()
                models.append(model)
            }
        }
        
        for model in models {
            model.isSelect = false
        }
        for idx in selectIdxes {
            if idx < models.count {
                let model = models[idx]
                model.isSelect = true
            }
        }
        
        item.models = models
        item.mutiMode = mutiMode
        item.selectLimit = selectLimit
        item.update()
        self.item = item
        cellHeight = item.viewHeight + kStaticCellTopMargin + kStaticCellBottomMargin
    }
    
}

class StaticCellLabelsPickerCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellLabelsPickerItem {
            selectView.item = item.item
            selectView.respondSelectChange = item.respondSelectChange
            selectView.respondLimit = item.respondLimit
        }
    }
    
    lazy var selectView = RectSelectsFixSizeView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(selectView)
        selectView.IN(contentView)
            .LEFT(kStaticCellLeftMargin)
            .RIGHT(kStaticCellRightMargin)
            .TOP(kStaticCellTopMargin)
            .BOTTOM(kStaticCellBottomMargin)
            .MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
