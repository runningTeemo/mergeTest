//
//  SelectItemView.swift
//  touzhong
//
//  Created by zerlinda on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit

class SelectItemView: RootView{
    
    
    var singleSelection:Bool = false
    var model:[FilterViewModel] = [FilterViewModel]()
    var titleArr:[String] = [String](){
        didSet{
            deleteLabel()
            createItemWhenFixNum()
        }
    }
    
    /// 选择的字典
    var selectDic:NSMutableDictionary = NSMutableDictionary()
    var selectArr:NSMutableArray = NSMutableArray()
    
    /// 行间距
    var widthMargin:CGFloat = 10
    /// 列间距
    var heightMargin:CGFloat = 10
    /// 按钮的高度
    var buttonHeght:CGFloat = 37
    /// 按钮宽度
    var buttonWidth:CGFloat = 80
    fileprivate var selfH:CGFloat = 0
    /// 每行个数
    var fixNum:Int = 3
    /// 最少的个数
    var minNum:Int = 3
    
    var clipseHeight:CGFloat? = 0{
        didSet{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: clipseHeight!)
            self.clipsToBounds = true
        }
    }
    var originalHeight:CGFloat{
        get{
            return selfH
        }
    }
    
    var numOfLine:Int{
        get{
            if titleArr.count%fixNum==0 {
                return titleArr.count/fixNum
            }else{
                return titleArr.count/fixNum+1
            }
        }
    }
    //MARK:CREATE
    
    /**
     根据固定个数 创建按钮
     
     - author: zerlinda
     - date: 16-09-01 16:09:23
     */
    func createItemWhenFixNum(){
        for i in 0 ..< titleArr.count{
            let item:SelectItem = SelectItem()
            item.title = titleArr[i]
            item.tag = 100 + i
            self.addSubview(item)
            item.selectFirst = {
                let itemView = self.viewWithTag(100)
                let item = itemView as? SelectItem
                if item != nil{
                    item?.isSelected = true
                }
            }
            
        }
    }
    
    func deleteLabel(){
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    /**
     改变按钮的位置
     
     - author: zerlinda
     - date: 16-09-01 16:09:14
     */
    func changeFrame(){
        calculateGap()
        let marginW = (self.bounds.size.width-buttonWidth*CGFloat(fixNum))/CGFloat(fixNum-1)
        var startX:CGFloat  = 0
        var startY:CGFloat = 0
        for i in 0 ..< titleArr.count{
            let item:SelectItem = self.viewWithTag(100+i) as! SelectItem
            item.frame = CGRect(x: startX, y: startY, width: buttonWidth, height: buttonHeght)
            item.selectDic = self.selectDic
            item.selectArray = self.selectArr
            let tapGes = UITapGestureRecognizer(target: self, action:#selector(SelectItemView.tapAction))
            item.addGestureRecognizer(tapGes)
            startX = startX+buttonWidth+marginW
            if (i+1)%3==0 {
                startX = 0
                startY = startY+buttonHeght+heightMargin
            }
            if i == 0 && selectArr.count == 0{
                item.isSelected = true
            }
        }
        if titleArr.count%3==0 {
            self.selfH  = startY
        }else{
            self.selfH  = startY+buttonHeght+heightMargin
        }
        
    }
    //MARK:action
    
    func unSelectAllAction(){
        for i in 0 ..< titleArr.count{
            let item:SelectItem = self.viewWithTag(100+i) as! SelectItem
            item.isSelected = false
        }
        
    }
    
    func tapAction(_ ges:UITapGestureRecognizer){
        let label = ges.view as! SelectItem
        if ges.state == UIGestureRecognizerState.ended {
            let select = label.isSelected
            if label.tag == 100 {
                self.unSelectAllAction()
                label.isSelected = true
            }else{
                if self.singleSelection{
                    self.unSelectAllAction()
                }
                let item:SelectItem = self.viewWithTag(100) as! SelectItem
                item.isSelected = false
            }
            label.isSelected = !select
            if selectArr.count == 0 {
                let item:SelectItem = self.viewWithTag(100) as! SelectItem
                item.isSelected = true
            }
        }
    }
    
    
    func updata(){
        
        changeFrame()
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: selfH)
    }
    
    /**
     适用横屏
     
     - author: zerlinda
     - date: 16-09-07 16:09:06
     */
    func calculateGap(){
        widthMargin = 10
        let indexF:CGFloat = (self.bounds.size.width-buttonWidth)/(buttonWidth+widthMargin)
        fixNum = Int(indexF) + 1
        if fixNum<minNum {
            buttonWidth = (self.bounds.width - widthMargin*CGFloat(minNum-1))/CGFloat(minNum)
            fixNum = minNum
        }else{
            let width:CGFloat = (buttonWidth+widthMargin)*(indexF-CGFloat(fixNum))
            widthMargin = widthMargin+width/CGFloat(fixNum+1) //根据提供的label的宽度自适应宽度间隙
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


