//
//  StaticCellSubTitle.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/2.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellSubTitleItem: StaticCellBaseItem {
    
    var title: String?
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    var titleColor: UIColor = HEX("#333333")
    
    /// 采用富文本覆盖上面的内容
    var attributeTitle: NSAttributedString?
    
    var subTitle: String?
    var subTitleFont: UIFont = UIFont.systemFont(ofSize: 13)
    var subTitleColor: UIColor = HEX("#999999")
    
    /// 采用富文本覆盖上面的内容
    var subAttributeTitle: NSAttributedString?
    
}

class StaticCellSubTitleCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellSubTitleItem {
            if let attr = item.attributeTitle {
                titleLabel.attributedText = attr
            } else {
                titleLabel.font = item.titleFont
                titleLabel.text = item.title
                titleLabel.textColor = item.titleColor
            }
            if let attr = item.subAttributeTitle {
                subTitleLabel.attributedText = attr
            } else {
                subTitleLabel.font = item.subTitleFont
                subTitleLabel.text = item.subTitle
                subTitleLabel.textColor = item.subTitleColor
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    lazy var subTitleLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.WIDTH(100).MAKE()
        subTitleLabel.IN(contentView).RIGHT(12.5).CENTER.MAKE()
        subTitleLabel.LEFT.GREAT_THAN_OR_EQUAL(titleLabel).RIGHT.OFFSET(20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
