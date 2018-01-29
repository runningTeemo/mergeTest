//
//  RotateArrowsView.swift
//  touzhong
//
//  Created by zerlinda on 2016/11/16.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class RotateArrowsView: RootView {//数据页面机构列表 领域点击旋转

    var label:UILabel = {
       let label = UILabel()
        return label
    }()
    var text:String?{
        didSet{
            label.text = text
            label.sizeToFit()
        }
    }
    var arrow:UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "iconScreenMore")
        return imageView
    }()
    var foldState:Bool = true{
        didSet{
            if foldState == false {
                arrow.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI))
            }else{
               arrow.transform =  CGAffineTransform(rotationAngle: CGFloat(0))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        self.addSubview(arrow)
    }
    func update(){
        label.frame = CGRect(x: 0, y: 0, width: label.frame.width, height: self.frame.height)
        arrow.frame = CGRect(x: label.frame.maxX, y: 0, width: 10, height: 10)
        arrow.center = CGPoint(x: arrow.center.x, y: label.center.y)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
