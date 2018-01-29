//
//  StaticCellWarning.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/6.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellWarningItem: StaticCellBaseItem {
    var text: String?
    override init() {
        super.init()
        backColor = HEX("#ffecb2")
        cellHeight = 40
    }
}

class StaticCellWarningCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellWarningItem {
            label.text = item.text
            arrow.isHidden = item.responder == nil
        }
    }
    
    lazy var icon: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconWarn")
        return one
    }()
    
    lazy var label: Label = {
        let one = Label()
        one.font = UIFont.systemFont(ofSize: 13)
        one.textColor = HEX("#795739")
        return one
    }()
    
    lazy var arrow: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "iconWarnMoreOrange")
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(icon)
        contentView.addSubview(label)
        contentView.addSubview(arrow)
        icon.IN(contentView).LEFT(15).SIZE(15, 15).CENTER.MAKE()
        arrow.IN(contentView).RIGHT(15).SIZE(15, 15).CENTER.MAKE()
        label.RIGHT(icon).OFFSET(9).CENTER.MAKE()
        label.RIGHT.LESS_THAN_OR_EQUAL(arrow).LEFT.OFFSET(-10).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
