//
//  ParticipationView.swift
//  touzhong
//
//  Created by zerlinda on 16/9/5.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class ParticipationView: RootView {
    
    var mainColor:UIColor = UIColor.black{
        didSet{
        }
    }
    /// 最后一个label字体变色
    var lastColor:UIColor?{
        didSet{
        }
    }
    
    var textArr:[String?]?{
        didSet{
            removeAllLabel()
            self.labelHeight = 0
            createLabel()
        }
    }
    var textFont:CGFloat = 14
    
    var labelHeight :CGFloat = 0
    var viewHeght:CGFloat{
        get{
            if labelHeight==0 {
                return 0
            }
            return labelHeight + 15
        }
    }
    var maxWidth:CGFloat = 0
    func removeAllLabel(){
        for view in self.subviews {
            if view.tag != 1000 {
                view.removeFromSuperview()
            }
        }
    }
    
    func createLabel(){
        for i in 0..<textArr!.count{
            let label = UILabel()
            label.text = textArr![i]
            label.font = UIFont.systemFont(ofSize: textFont)
            label.sizeToFit()
            if label.frame.size.height != 0 || self.labelHeight == 0{
                self.labelHeight = label.frame.size.height
            }
            self.addSubview(label)
            label.tag = 100 + i
            label.textColor = MyColor.colorWithHexString("#666666")
            if i != textArr!.count-1 {
                let view = UIView()
                view.backgroundColor = verticalLineColor
                view.tag = 200+i
                self.addSubview(view)
            }
        }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        if let arr = textArr {
            changeFrame(arr)
        }
        if lastColor != nil{
            changeLastColor()
        }
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.labelHeight)
    }
    
    func changeFrame(_ arr:[String?]){
        var startX:CGFloat = 0
        var isDelete = false
        for i in 0..<arr.count{
            let label = viewWithTag(100+i) as? UILabel
            var labelW:CGFloat? = label?.bounds.size.width
            if labelW!>=self.frame.width {
                labelW = self.frame.width
            }
            label?.frame = CGRect(x: startX, y: 0, width: labelW!, height: (label?.bounds.size.height)!)
            let view = viewWithTag(200+i)
            view?.frame = CGRect(x: (label?.frame.maxX)!+12, y: 0, width: 1, height: 12)
            view?.center = CGPoint(x: (view?.center.x)!, y: (label?.center.y)!)
            startX += (label?.bounds.size.width)!+25
            if (label?.frame.maxX)!>self.frame.width{
               label?.text = "..."
                isDelete = true
            }
            if isDelete || label?.text == nil || label?.text?.characters.count == 0{
                label?.alpha = 0
                view?.alpha = 0
                let lineView = viewWithTag(200+i-1)
                lineView?.alpha = 0
            }
        }
        
    }
    /**
     改变最后一个label的颜色
     
     - author: zerlinda
     - date: 16-09-06 19:09:11
     */
    func changeLastColor(){
        
        for i in 0..<subviews.count {
            let lable = subviews[i]
            if lable.tag == 100+(self.textArr?.count)!-1 {
                let l:UILabel = lable as! UILabel
                l.textColor = lastColor
            }
        }
    }
    
}
