//
//  StaticCellArrow.swift
//  touzhong
//
//  Created by Richard.q.x on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellSwitchItem: StaticCellBaseItem {
    
    var title: String?
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    var titleColor: UIColor = HEX("#333333")
    
    /// 采用富文本覆盖上面的内容
    var attributeTitle: NSAttributedString?
    
    var isOn: Bool = false
    
    var respondChange: ((_ isOn: Bool) -> ())?
    
}

class StaticCellSwitchCell: StaticCellBaseCell {

    override func update() {
        super.update()
        if let item = item as? StaticCellSwitchItem {
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
        return one
    }()
    lazy var aSwitch: UISwitch = {
        let one = UISwitch()
        one.isOn = false
        one.signal_event_valueChanged.head { [unowned self, unowned one] (s) in
            (self.item as? StaticCellSwitchItem)?.isOn = one.isOn
            (self.item as? StaticCellSwitchItem)?.respondChange?(one.isOn)
        }
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(aSwitch)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.WIDTH(100).MAKE()
        aSwitch.IN(contentView).RIGHT(12.5).CENTER.MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
