//
//  StaticCellLoadingButton.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/27.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellLoadingButtonItem: StaticCellBaseItem {
    
    var title: String?
    
    var topMargin: CGFloat = kStaticCellTopMargin
    var bottomMargin: CGFloat = kStaticCellBottomMargin
    
    var buttonClick: (() -> ())?
    
    var isLoading: Bool = false
    
    override init() {
        super.init()
        cellHeight = 40 + kStaticCellTopMargin + kStaticCellBottomMargin
    }
}


class StaticCellLoadingButtonCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellLoadingButtonItem {
            btn.title = item.title
            if item.isLoading {
                btn.startLoading()
            } else {
                btn.stopLoading()
            }
        }
    }
    
    lazy var btn: LoadingButton = {
        let one = LoadingButton()
        one.cornerRadius = 3
        one.addTarget(self, action: #selector(StaticCellLoadingButtonCell.btnClick), for: .touchUpInside)
        return one
    }()
    func btnClick() {
        (item as? StaticCellLoadingButtonItem)?.buttonClick?()
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
