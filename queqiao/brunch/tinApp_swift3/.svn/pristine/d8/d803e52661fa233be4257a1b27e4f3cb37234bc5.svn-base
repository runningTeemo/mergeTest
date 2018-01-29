//
//  StaticCellSpace.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellSpaceItem: StaticCellBaseItem {
    
    var color: UIColor?
    
    var height: CGFloat = 10 {
        didSet {
            cellHeight = height
        }
    }
    override init() {
        super.init()
        cellHeight = 10
    }
}

class StaticCellSpaceCell: StaticCellBaseCell {
    override func update() {
        super.update()
        if let item = item as? StaticCellSpaceItem {
            if let color = item.color {
                contentView.backgroundColor = color
            } else {
                contentView.backgroundColor = UIColor.clear
            }
        }
    }
}
