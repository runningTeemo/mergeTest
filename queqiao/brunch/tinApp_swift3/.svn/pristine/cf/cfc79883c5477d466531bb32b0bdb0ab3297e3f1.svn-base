//
//  BorderLabel.swift
//  touzhong
//
//  Created by zerlinda on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class BorderLabel: UILabel {//数据页面融资页面行业类型

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    /// 显示的文字
     var textStr: String?{
        didSet{
            self.layer.borderWidth = 0.4
            self.textAlignment = NSTextAlignment.center
            self.text = textStr
            self.sizeToFit()
            let label = UILabel()
            label.text = textStr
            label.font = self.font
            label.sizeToFit()
//            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: label.frame.size.width + referenceWidth, height:label.frame.size.height + referenceHeight)
//            self.referenceWidth = label.bounds.size.width + self.referenceWidth
//            self.referenceHeight = label.bounds.size.height + self.referenceHeight
        }
    }
    /// 字体和边框的颜色
    var mainColor:UIColor = UIColor.black{
        didSet{
            self.textColor = mainColor
            self.layer.borderColor = mainColor.cgColor
        }
    }
   /// 参考宽度
    var referenceWidth:CGFloat = 0
    var referenceHeight:CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 0.4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
