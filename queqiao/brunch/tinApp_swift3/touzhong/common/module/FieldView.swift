//
//  FieldView.swift
//  touzhong
//
//  Created by zerlinda on 16/9/7.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit



class FieldView: UIView {
    
    /// 必须传的参数
    var labelWidth:CGFloat = 0
    var labelHeight:CGFloat = 17
    /// 必传参数
    var titleArr:[String?]? = [String?](){
        didSet{
            removeLabel()
            createLabel()
        }
    }
    /// 宽度缝隙
    var widthGap:CGFloat = 10
    /// 高度缝隙
    var heightGap:CGFloat = 10
    
    /// 约束组
    //var group:ConstraintGroup = ConstraintGroup()
    
    var viewHeight:CGFloat = 0
    
    var isHid = false{
        didSet{
            self.isHidden = isHid
        }
    }
    //MARK:private
    /// 每行的个数
    fileprivate var fixnum:Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeight()->CGFloat{
         changeFrame()
        return viewHeight
    }
    //MARK:METHOD
    func createLabel(){
        if titleArr != nil  {
            for i in 0..<titleArr!.count{
                let label = UILabel()
                label.text = titleArr![i]
                label.font = UIFont.systemFont(ofSize: 10)
                label.tag = 100+i
                label.textColor = MyColor.colorWithHexString("#666666")
                label.textAlignment = NSTextAlignment.center
                label.layer.borderWidth = 0.5
                label.layer.borderColor = MyColor.colorWithHexString("#b5b5b5").cgColor
                label.layer.cornerRadius = 2
                label.layer.masksToBounds = true
                label.backgroundColor = UIColor.white
                self.addSubview(label)
            }
        }
    }
    
    func removeLabel(){
        for label in self.subviews {
            label.removeFromSuperview()
        }
    }
    func changeFrame(){
        if self.bounds.size.width==0 {
            return
        }
        calculateGap()
        if titleArr != nil {
            var startX:CGFloat = widthGap
            var startY:CGFloat = heightGap
            for i in 0..<titleArr!.count{
                let label:UILabel? = viewWithTag(100+i) as? UILabel
                if let l = label{
                    if i>0 && i%fixnum==0 {
                        startX = widthGap
                        startY = startY + self.labelHeight + self.heightGap
                    }
                    l.frame = CGRect(x: startX, y: startY, width: self.labelWidth, height: self.labelHeight)
                    startX = startX + (self.labelWidth + self.widthGap)
                }
            }
            viewHeight = startY + heightGap + labelHeight
            if titleArr?.count==0 {
                viewHeight = 0
            }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: viewHeight)
        }
        
    }
    /**
     适用横屏
     
     - author: zerlinda
     - date: 16-09-07 16:09:06
     */
    func calculateGap(){
        widthGap = 10
        let indexF:CGFloat = (self.bounds.size.width-widthGap)/(labelWidth+widthGap)
        fixnum = Int(indexF)
        let width:CGFloat = (labelWidth+widthGap)*(indexF-CGFloat(fixnum))
        widthGap = widthGap+width/CGFloat(fixnum+1) //根据提供的label的宽度自适应宽度间隙
    }
}
