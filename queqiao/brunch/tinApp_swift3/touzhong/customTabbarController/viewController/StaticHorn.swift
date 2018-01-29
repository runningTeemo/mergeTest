//
//  StaticHorn.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/7.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticHornItem: StaticCellArrowItem {
    
    var horn: HornDataModel?
    var hornCount: Int?
    
    override init() {
        super.init()
        title = "广播喇叭"
        subTitleFont = UIFont.systemFont(ofSize: 14)
        subTitle = "未使用"
    }
}

class StaticHornCell: StaticCellArrowCell {
    override func update() {
        super.update()
        if let item = item as? StaticHornItem {
            
            if let count = item.hornCount {
                if count > 0 {
                    countLabel.text = " \(count)个可用 "
                    countLabel.isHidden = false
                    subTitleLabel.text = "不使用喇叭"
                } else {
                    countLabel.isHidden = true
                    subTitleLabel.text = "无喇叭可用"
                }
            } else {
                countLabel.isHidden = true
                subTitleLabel.text = "未使用"
                subTitleLabel.text = "不使用喇叭"
            }
            if item.horn != nil {
                subTitleLabel.textColor = kClrOrange
                subTitleLabel.text = "使用喇叭"
            } else {
                subTitleLabel.textColor = item.subTitleColor
            }
            
        }
    }
    lazy var countLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 10)
        one.textColor = kClrWhite
        one.backgroundColor = kClrOrange
        one.layer.cornerRadius = 2
        one.clipsToBounds = true
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(countLabel)
        titleLabel.REMOVE_CONSES()
        titleLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        subTitleLabel.REMOVE_CONSES()
        subTitleLabel.LEFT(arrowView).OFFSET(10).CENTER.MAKE()
        subTitleLabel.LEFT.GREAT_THAN_OR_EQUAL(countLabel).RIGHT.OFFSET(20).MAKE()
        countLabel.RIGHT(titleLabel).OFFSET(5).CENTER.HEIGHT(14).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
