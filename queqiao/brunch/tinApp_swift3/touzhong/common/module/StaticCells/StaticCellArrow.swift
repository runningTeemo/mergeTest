//
//  StaticCellArrow.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellArrowItem: StaticCellBaseItem {
    
    var title: String?
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    var titleColor: UIColor = HEX("#666666")
    /// 采用富文本覆盖上面的内容
    var attributeTitle: NSAttributedString?
    
    var subTitle: String?
    var subTitleFont: UIFont = UIFont.systemFont(ofSize: 13)
    var subTitleColor: UIColor = HEX("#999999")
    /// 采用富文本覆盖上面的内容
    var subAttributeTitle: NSAttributedString?
    
    var tip: String?
    var tipFont: UIFont = UIFont.systemFont(ofSize: 13)
    var tipColor: UIColor = HEX("#999999")
    /// 采用富文本覆盖上面的内容
    var attributeTip: NSAttributedString?
    
}

class StaticCellArrowCell: StaticCellBaseCell {

    override func update() {
        super.update()
        
        if let item = item as? StaticCellArrowItem {
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
                if let subTitle = item.subTitle {
                    subTitleLabel.font = item.subTitleFont
                    subTitleLabel.text = subTitle
                    subTitleLabel.textColor = item.subTitleColor
                } else {
                    if let attr = item.attributeTip {
                        subTitleLabel.attributedText = attr
                    } else {
                        subTitleLabel.font = item.tipFont
                        subTitleLabel.text = item.tip
                        subTitleLabel.textColor = item.tipColor
                    }
                }
            }
            arrowView.isHidden = item.responder == nil
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
    lazy var arrowView: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconListMore")
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(arrowView)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.MAKE()
        arrowView.IN(contentView).RIGHT(12.5).CENTER.SIZE(15, 15).MAKE()
        subTitleLabel.LEFT(arrowView).OFFSET(10).CENTER.MAKE()
        subTitleLabel.LEFT.GREAT_THAN_OR_EQUAL(titleLabel).RIGHT.OFFSET(20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
