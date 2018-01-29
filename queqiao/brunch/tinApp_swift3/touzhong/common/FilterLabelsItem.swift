//
//  FilterLabelsItem.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class FilterLabelsItem: RootFilterItem {
    
    var labels: [labelProtocol]?
    var respondSelectChange: ((_ selectIdxes: [Int], _ lastIdx: Int) -> ())?
    var respondLimit: (() -> ())?
    
    var mutiMode: Bool = false
    var selectLimit: Int?
    var xCount: Int = kScreenW <= 330 ? 2 : 3
    
    var selectIdxes: [Int] = [Int]()
    var firstOneCrossCount: Int = 0
    
    fileprivate(set) var item: RectSelectsFixSizeItem?

    func update() {
        cellHeight = 0
        let item = RectSelectsFixSizeItem()
        item.itemXMargin = 6
        item.itemYMargin = 6
        item.maxWidth = totalWidth - 12.5 * 2
        item.firstOneCrossCount = firstOneCrossCount
        var models = [RectSelectFixSizeItem]()
        if let labels = labels {
            for label in labels {
                let model = RectSelectFixSizeItem()
                let xCount: CGFloat = CGFloat(self.xCount)
                let itemWidth = (totalWidth - 12.5 - 12.5 - item.itemXMargin * (xCount - 1)) / xCount
                model.size = CGSize(width: itemWidth, height: 37)
                model.title = label.name
                model.norTitleFontSize = 13
                model.selTitleFontSize = 13
                model.norTitleColor = kClrDarkGray
                model.selTitleColor = HEX("#d61f26")
                model.isFillMode = true
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
        cellHeight = item.viewHeight
    }
}

class FilterLabelsCell: RootFilterCell {
    override func update() {
        super.update()
        if let item = item as? FilterLabelsItem {
            selectView.item = item.item
            selectView.respondSelectChange = { [unowned self] idxes, lastIdx in
                if let item = self.item as? FilterLabelsItem {
                    item.respondSelectChange?(idxes, lastIdx)
                    item.selectIdxes = idxes
                }
            }
            selectView.respondLimit = item.respondLimit
        }
    }
    lazy var selectView = RectSelectsFixSizeView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(selectView)
        selectView.IN(contentView).LEFT(12.5).RIGHT(12.5).TOP.BOTTOM.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
