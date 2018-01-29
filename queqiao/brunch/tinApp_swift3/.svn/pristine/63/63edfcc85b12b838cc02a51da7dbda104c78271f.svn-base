//
//  BorderImageLabel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/12.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class BorderImageLabel: RootView {
   
    var label:UILabel = UILabel()
    var imageV:UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        self.addSubview(imageV)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = MyColor.colorWithHexString("#333333")
        label.text = "不限"
        self.layer.borderWidth = 0.5
        self.layer.borderColor = MyColor.colorWithHexString("#999999").cgColor
        self.isUserInteractionEnabled = true
        
    }
    
    override func layoutSubviews() {
        label.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width-50, height: self.bounds.size.height)
        imageV.frame = CGRect(x: self.bounds.size.width-50, y: (self.bounds.size.height-20)/2, width: 20, height: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
