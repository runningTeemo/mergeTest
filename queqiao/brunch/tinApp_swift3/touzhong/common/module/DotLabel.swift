//
//  DotLabel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/18.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class DotLabel: RootView {

    var mainColor:UIColor?{
        didSet{
            dotView.backgroundColor = mainColor
        }
    }
    var dotView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    var label:UILabel = {
        let label = UILabel()
        label.textColor = MyColor.colorWithHexString("#333333")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    var text:String?{
        didSet{
            label.text = text
            label.sizeToFit()
            dotView.frame = CGRect(x: 0, y: (label.frame.size.height-4)/2, width: 4, height: 4)
            label.frame = CGRect(x: 15, y: 0, width: label.frame.size.width, height: label.frame.size.height)
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: label.frame.maxX, height: label.frame.size.height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(dotView)
        self.addSubview(label)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: label.frame.maxX, height: label.frame.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
