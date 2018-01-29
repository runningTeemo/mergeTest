//
//  FilterMoreItem.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/12/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

class FilterMoreItem: RootFilterItem {
    override init() {
        super.init()
        cellHeight = 40
    }
    
    var respondClick: (() -> ())?
    var title: String? = "更多"
    
}
class FilterMoreCell: RootFilterCell {
    override func update() {
        super.update()
        if let item = item as? FilterMoreItem {
            btn.title = item.title
        }
    }
    
    lazy var btn: TitleButton = {
        let one = TitleButton()
        one.norBgColor = UIColor.clear
        one.dowBgColor = UIColor.clear
        one.dowTitlefont = UIFont.systemFont(ofSize: 14)
        one.norTitlefont = UIFont.systemFont(ofSize: 14)
        one.norTitleColor = kClrBlue
        one.dowTitleColor = kClrBlue
        one.signal_event_touchUpInside.head({ [unowned self] (s) in
            (self.item as? FilterMoreItem)?.respondClick?()
        })
        return one
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(btn)
        btn.IN(contentView).LEFT(12.5).TOP.BOTTOM.RIGHT(12.5).MAKE()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
