//
//  LeftAndRightLabel.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/22.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class LeftAndRightLabel: RootView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var textArr:[String] = [String](){
        didSet{
           deleteLabel()
           createLabel()
        }
    }
    var viewHeight:CGFloat = 0
    var heightGap:CGFloat = 10
    
    func createLabel(){
        for  i in 0..<textArr.count {
            let label = UILabel()
            label.text = textArr[i]
            label.textAlignment = NSTextAlignment.left
            label.sizeToFit()
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 14)
            label.tag = 100+i
            label.textColor = MyColor.colorWithHexString("#333333")
            self.addSubview(label)
        }
    }
    
    func deleteLabel(){
        for label in self.subviews {
            label.removeFromSuperview()
        }
    }
    
    func update(){
        var startY:CGFloat = 0
        var startX:CGFloat = 0
        var newLine:Bool = true//控制每行最多显示两个
        viewHeight = 0
        for i in 100..<100+textArr.count {
            let labelView = self.viewWithTag(i)
            if labelView != nil {
                labelView!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
                labelView!.sizeToFit()//为了保证过长超出屏幕的数据可以换行
                labelView!.frame = CGRect(x: startX, y: startY, width: labelView!.frame.width, height: labelView!.frame.height)
                if labelView!.frame.maxX<self.frame.width && newLine && labelView!.frame.width<self.frame.width/2{
                    startX = self.frame.width/2
                    newLine = false
                }else{
                    newLine = true
                    startX = 0
                    startY += labelView!.frame.height + 10
                }
            }
            viewHeight = labelView!.frame.maxY
        }
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: viewHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
