//
//  IndexViewColumnsView.swift
//  touzhong
//
//  Created by Richard.q.x on 16/8/28.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

struct ColumnItem {
    var name: String
    var icon: String
}

class IndexViewColumnsView: UIView {
    
    var viewHeight: CGFloat { return 130 }
    
    var respondItem: ((_ item: ColumnItem) -> ())?
    
    let items = [
        ColumnItem(name: "融资", icon: "iconHomeRZ"),
        ColumnItem(name: "并购", icon: "iconHomeBG"),
        ColumnItem(name: "退出", icon: "iconHomeTC"),
        ColumnItem(name: "机构", icon: "iconHomeJG"),
        ColumnItem(name: "企业", icon: "iconHomeQY"),
        ColumnItem(name: "人物", icon: "iconHomeRW"),
        ColumnItem(name: "榜单", icon: "iconHomeBD"),
        ColumnItem(name: "会议", icon: "iconHomeHY")
    ]
    
    lazy var btns: [IndexViewColumnButton] = {
        var one = [IndexViewColumnButton]()
        for item in self.items {
            let btn = IndexViewColumnButton(item: item)
            one.append(btn)
        }
        return one
    }()
    
    required init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        for btn in btns {
            addSubview(btn)
            btn.signal_event_touchUpInside.head({ [unowned btn, unowned self] (signal) in
                self.respondItem?(btn.item!)
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let xMargin: CGFloat = 10
        let yMargin: CGFloat = 5
        let btnW = (kScreenW - xMargin * 5) / 4
        let btnH = (viewHeight - yMargin * 3) / 2
        var i: Int = 0
        var x: CGFloat = xMargin
        var y: CGFloat = yMargin
        for btn in btns {
            btn.frame = CGRect(x: x, y: y, width: btnW, height: btnH)
            x += btnW + xMargin
            if x > kScreenW - xMargin -  btnW {
                x = xMargin
                y += btnH + yMargin
            }
            i += 1
        }
    }
    
}

class IndexViewColumnButton: ButtonBack {
    
    var item: ColumnItem? {
        didSet {
            if let item = item {
                iconView.image = UIImage(named: item.icon)
                nameLabel.text = item.name
            } else {
                iconView.image = nil
                nameLabel.text = nil
            }
        }
    }
    
    lazy var iconView: ImageView = {
        let one = ImageView(type: .image)
        return one
    }()
    
    lazy var nameLabel: UILabel = {
        let one = UILabel()
        one.font = UIFont.systemFont(ofSize: 13)
        one.textColor = HEX("#333333")
        return one
    }()
    
    lazy var holderView = UIView()
    
    convenience init(item: ColumnItem) {
        self.init()
        iconView.image = UIImage(named: item.icon)
        nameLabel.text = item.name
        self.item = item
    }
    required init() {
        super.init()
        norBgColor = UIColor.clear
        dowBgColor = kClrSlightGray
        addSubview(holderView)
        addSubview(iconView)
        addSubview(nameLabel)
        
        holderView.IN(self).CENTER.MAKE()
        iconView.IN(holderView).TOP.LEFT.RIGHT.SIZE(25, 25).MAKE()
        nameLabel.BOTTOM(iconView).CENTER.OFFSET(5).MAKE()
        nameLabel.BOTTOM.EQUAL(holderView).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
