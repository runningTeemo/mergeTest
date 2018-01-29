//
//  StaticCellButton.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellTextButtonItem: StaticCellBaseItem {
    
    var title: String?
    var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var titleColor: UIColor = HEX("#666666")
    
    /// 采用富文本覆盖上面的内容
    var attributeTitle: NSAttributedString?
    
}


class StaticCellTextButtonCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellTextButtonItem {
            if let attr = item.attributeTitle {
                titleLabel.attributedText = attr
            } else {
                titleLabel.font = item.titleFont
                titleLabel.text = item.title
                titleLabel.textColor = item.titleColor
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        one.textAlignment = .center
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.IN(contentView).LEFT(15).RIGHT(15).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
