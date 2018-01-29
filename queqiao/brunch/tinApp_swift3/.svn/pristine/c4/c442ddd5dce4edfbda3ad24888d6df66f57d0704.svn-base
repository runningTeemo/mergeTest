//
//  StaticCellSelect.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/10/25.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class StaticCellSelectItem: StaticCellBaseItem {
    
    var text: String?
    
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    var textColor: UIColor = UIColor.black
    
    var isSelect: Bool = false
    
}

class StaticCellSelectCell: StaticCellBaseCell {
    
    override func update() {
        super.update()
        if let item = item as? StaticCellSelectItem {
            titleLabel.text = item.text
            if item.isSelect {
                selectView.image = UIImage(named: "radioBoxSelect")
            } else {
                selectView.image = UIImage(named: "radioBox")
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let one = UILabel()
        return one
    }()
    lazy var selectView: ImageView = {
        let one = ImageView(type: .image)
        one.image = UIImage(named: "radioBoxSelect")
        return one
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectView)
        titleLabel.IN(contentView).LEFT(12.5).CENTER.WIDTH(100).MAKE()
        selectView.IN(contentView).RIGHT(12.5).CENTER.SIZE(20, 20).MAKE()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

