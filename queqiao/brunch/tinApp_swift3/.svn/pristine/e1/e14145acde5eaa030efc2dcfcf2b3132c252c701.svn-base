//
//  StaticCellBase.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/26.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation

let kStaticCellLeftMargin: CGFloat = 15
let kStaticCellRightMargin: CGFloat = 15
let kStaticCellTopMargin: CGFloat = 20
let kStaticCellBottomMargin: CGFloat = 20

class StaticCellBaseItem {
    var cellHeight: CGFloat = 54
    var responder: (() -> ())?
    var enabled: Bool = true
    var backColor: UIColor = UIColor.white
    var totalWidth: CGFloat = kScreenW
    
    var showBottomLine: Bool = false
    var bottomLineLeftMargin: CGFloat = 0
    var bottomLineRightMargin: CGFloat = 0
        
    var updateCell: (() -> ())?
}

class StaticCellBaseCell: UITableViewCell {
    
    weak var tableView: UITableView!
    weak var vc: StaticCellBaseViewController!
    var indexPath: IndexPath!
    
    var item: StaticCellBaseItem? {
        didSet {
            update()
        }
    }
    
    lazy var bottomLine: UIView = {
        let one = UIView()
        one.backgroundColor = HEX("#e7e7e7")
        return one
    }()
    
    /// 当调用item的updateCell方法，则会调用此方法(子类内需要重写)
    func update() {
        if let item = item {
            isUserInteractionEnabled = item.enabled
            contentView.backgroundColor = item.backColor
            if item.showBottomLine {
                bottomLine.isHidden = false
                bottomLineLeftCons?.constant = item.bottomLineLeftMargin
                bottomLineRightCons?.constant = -item.bottomLineRightMargin
            } else {
                bottomLine.isHidden = true
            }
            item.updateCell = { [unowned self] in
                self.update()
            }
        }
    }
    
    fileprivate var bottomLineLeftCons: NSLayoutConstraint?
    fileprivate var bottomLineRightCons: NSLayoutConstraint?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bottomLine)
        bottomLine.IN(contentView).BOTTOM.HEIGHT(0.5).MAKE()
        bottomLineLeftCons = bottomLine.LEFT.EQUAL(contentView).MAKE()
        bottomLineRightCons = bottomLine.RIGHT.EQUAL(contentView).MAKE()
        backgroundColor = UIColor.clear
        contentView.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


