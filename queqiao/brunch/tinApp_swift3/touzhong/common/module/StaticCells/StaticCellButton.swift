//
//  StaticCellButton.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellButtonItem: StaticCellBaseItem {
    
    var title: String?
    
    var topMargin: CGFloat = kStaticCellTopMargin
    var bottomMargin: CGFloat = kStaticCellBottomMargin
    
    var buttonClick: (() -> ())?
    
    override init() {
        super.init()
        cellHeight = 40 + kStaticCellTopMargin + kStaticCellBottomMargin
    }
}


class StaticCellButtonCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellButtonItem {
            btn.title = item.title
        }
    }
    
    lazy var btn: TitleButton = {
        let one = TitleButton()
        one.addTarget(self, action: #selector(StaticCellButtonCell.btnClick), for: .touchUpInside)
        return one
    }()
    func btnClick() {
        (item as? StaticCellButtonItem)?.buttonClick?()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(btn)
        btn.IN(contentView).LEFT(kStaticCellLeftMargin).RIGHT(kStaticCellRightMargin).TOP(kStaticCellTopMargin).BOTTOM(kStaticCellBottomMargin).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
